import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../core/utils/quantity.dart';
import '../../domain/app_settings.dart';
import '../../domain/billing.dart';
import '../../domain/drafts.dart';
import '../../domain/enums.dart';
import '../../domain/numbering.dart';
import '../local/app_database.dart';
import 'base_repository.dart';
import 'sql.dart';
import 'visit_repository.dart';

class InvoiceListItem {
  const InvoiceListItem(this.invoice, this.companyName, this.balance);
  final Invoice invoice;
  final String companyName;
  final InvoiceBalance balance;
  PaymentStatus get status => balance.status;
}

class PaymentListItem {
  const PaymentListItem(
    this.payment,
    this.companyName,
    this.allocated,
    this.invoiceNos,
  );
  final Payment payment;
  final String companyName;
  final int allocated;
  final String? invoiceNos;
  int get unallocated =>
      payment.voidedAt != null ? 0 : payment.amountPaise - allocated;
}

class AllocationRow {
  const AllocationRow(this.allocation, this.payment, this.invoiceNo);
  final PaymentAllocation allocation;
  final Payment payment;
  final String invoiceNo;
}

class InvoiceFilter {
  const InvoiceFilter({
    this.companyId,
    this.statuses = const {},
    this.from,
    this.to,
    this.query = '',
    this.includeCancelled = false,
  });
  final String? companyId;
  final Set<PaymentStatus> statuses;
  final String? from;
  final String? to;
  final String query;
  final bool includeCancelled;
}

class PaymentFilter {
  const PaymentFilter({
    this.companyId,
    this.method,
    this.from,
    this.to,
    this.query = '',
    this.includeVoided = false,
  });
  final String? companyId;
  final PaymentMethod? method;
  final String? from;
  final String? to;
  final String query;
  final bool includeVoided;
}

class CompletionResult {
  const CompletionResult(this.visit, this.invoice, this.payment);
  final ServiceVisit visit;
  final Invoice? invoice;
  final Payment? payment;
}

class BillingRepository extends BaseRepository {
  BillingRepository(super.db, this.visits);

  final VisitRepository visits;

  Set<ResultSetImplementation<dynamic, dynamic>> get _reads => {
    db.invoices,
    db.companies,
    db.payments,
    db.paymentAllocations,
  };

  static const _invoiceSql = '''
    SELECT i.*, c.name AS company_name, COALESCE(pb.paid, 0) AS paid
    FROM invoices i JOIN companies c ON c.id = i.company_id
    LEFT JOIN (${Sql.paidByInvoice}) pb ON pb.invoice_id = i.id''';

  InvoiceListItem _mapInvoice(QueryRow r, String today) {
    final inv = db.invoices.map(r.data);
    return InvoiceListItem(
      inv,
      r.read<String>('company_name'),
      InvoiceBalance(
        total: inv.totalPaise,
        paid: r.read<int>('paid'),
        dueDate: inv.dueDate,
        today: today,
        cancelled: inv.cancelledAt != null,
      ),
    );
  }

  Stream<List<InvoiceListItem>> watchInvoices(InvoiceFilter f) {
    final where = <String>[];
    final vars = <Variable<Object>>[];
    if (!f.includeCancelled) where.add('i.cancelled_at IS NULL');
    if (f.companyId != null) {
      where.add('i.company_id = ?');
      vars.add(Variable.withString(f.companyId!));
    }
    if (f.from != null) {
      where.add('i.invoice_date >= ?');
      vars.add(Variable.withString(f.from!));
    }
    if (f.to != null) {
      where.add('i.invoice_date <= ?');
      vars.add(Variable.withString(f.to!));
    }
    final q = f.query.trim().toLowerCase();
    if (q.isNotEmpty) {
      where.add('(LOWER(i.invoice_no) LIKE ? OR LOWER(c.name) LIKE ?)');
      vars.addAll([Variable.withString('%$q%'), Variable.withString('%$q%')]);
    }
    final sql =
        '$_invoiceSql${where.isEmpty ? '' : ' WHERE ${where.join(' AND ')}'}'
        ' ORDER BY i.invoice_date DESC, i.invoice_no DESC';
    return db.customSelect(sql, variables: vars, readsFrom: _reads).watch().map(
      (rows) {
        final today = Dates.today();
        final items = rows.map((r) => _mapInvoice(r, today));
        return f.statuses.isEmpty
            ? items.toList()
            : items.where((i) => f.statuses.contains(i.status)).toList();
      },
    );
  }

  Stream<InvoiceListItem?> watchInvoice(String id) => db
      .customSelect(
        '$_invoiceSql WHERE i.id = ?',
        variables: [Variable.withString(id)],
        readsFrom: _reads,
      )
      .watchSingleOrNull()
      .map((r) => r == null ? null : _mapInvoice(r, Dates.today()));

  Future<InvoiceListItem?> getInvoice(String id) async {
    final r = await db
        .customSelect(
          '$_invoiceSql WHERE i.id = ?',
          variables: [Variable.withString(id)],
        )
        .getSingleOrNull();
    return r == null ? null : _mapInvoice(r, Dates.today());
  }

  /// Unpaid / partially paid invoices of a company, oldest first.
  Future<List<InvoiceListItem>> openInvoices(String companyId) async {
    final rows = await db
        .customSelect(
          '$_invoiceSql WHERE i.company_id = ? AND i.cancelled_at IS NULL'
          ' ORDER BY i.invoice_date, i.invoice_no',
          variables: [Variable.withString(companyId)],
        )
        .get();
    final today = Dates.today();
    return rows
        .map((r) => _mapInvoice(r, today))
        .where((i) => i.balance.outstanding > 0)
        .toList();
  }

  Stream<List<InvoiceItem>> watchItems(String invoiceId) =>
      (db.select(db.invoiceItems)
            ..where((t) => t.invoiceId.equals(invoiceId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .watch();

  Future<List<InvoiceItem>> items(String invoiceId) =>
      (db.select(db.invoiceItems)
            ..where((t) => t.invoiceId.equals(invoiceId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .get();

  Stream<List<ServiceVisit>> watchInvoiceVisits(String invoiceId) =>
      (db.select(db.serviceVisits)
            ..where((t) => t.invoiceId.equals(invoiceId))
            ..orderBy([(t) => OrderingTerm(expression: t.visitDate)]))
          .watch();

  static const _allocSql = '''
    SELECT a.*, i.invoice_no AS invoice_no,
      p.id AS "p.id", p.receipt_no AS "p.receipt_no", p.company_id AS "p.company_id",
      p.paid_on AS "p.paid_on", p.amount_paise AS "p.amount_paise",
      p.method AS "p.method", p.reference AS "p.reference", p.notes AS "p.notes",
      p.voided_at AS "p.voided_at", p.void_reason AS "p.void_reason",
      p.created_at AS "p.created_at", p.updated_at AS "p.updated_at",
      p.server_rev AS "p.server_rev"
    FROM payment_allocations a
    JOIN payments p ON p.id = a.payment_id
    JOIN invoices i ON i.id = a.invoice_id
    WHERE a.deleted_at IS NULL''';

  Stream<List<AllocationRow>> _watchAllocations(String where, String id) => db
      .customSelect(
        '$_allocSql AND $where = ? ORDER BY p.paid_on, p.created_at',
        variables: [Variable.withString(id)],
        readsFrom: {db.paymentAllocations, db.payments, db.invoices},
      )
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            AllocationRow(
              db.paymentAllocations.map(r.data),
              db.payments.map(r.data, tablePrefix: 'p'),
              r.read<String>('invoice_no'),
            ),
        ],
      );

  /// Active payments applied to an invoice.
  Stream<List<AllocationRow>> watchInvoiceAllocations(String invoiceId) =>
      _watchAllocations('a.invoice_id', invoiceId);

  Stream<List<AllocationRow>> watchPaymentAllocations(String paymentId) =>
      _watchAllocations('a.payment_id', paymentId);

  // ---------------------------------------------------------------------------
  // Invoices
  // ---------------------------------------------------------------------------

  /// Builds an invoice draft from completed visits (for review before saving).
  Future<InvoiceDraft> draftFromVisits(
    List<String> visitIds,
    BusinessSettings settings, {
    String? invoiceDate,
  }) async {
    if (visitIds.isEmpty) {
      throw BusinessRuleException('Select at least one visit');
    }
    final list = <ServiceVisit>[];
    for (final id in visitIds) {
      final v = await visits.get(id);
      if (v == null) throw BusinessRuleException('Visit not found');
      list.add(v);
    }
    list.sort((a, b) => a.visitDate.compareTo(b.visitDate));
    final companyId = list.first.companyId;
    if (list.any((v) => v.companyId != companyId)) {
      throw BusinessRuleException('All visits must be for the same company');
    }
    final date = invoiceDate ?? Dates.today();
    final lines = <InvoiceLineDraft>[];
    var discount = 0;
    var taxRate = 0;
    for (final v in list) {
      final machine = v.machineId == null
          ? null
          : await (db.select(
              db.machines,
            )..where((t) => t.id.equals(v.machineId!))).getSingleOrNull();
      final ref =
          '${v.visitNo}, ${Dates.display(v.visitDate)}'
          '${machine == null ? '' : ', ${machine.name}'}';
      if (v.labourPaise > 0) {
        lines.add(
          InvoiceLineDraft(
            kind: InvoiceItemKind.labour,
            description:
                'Service charges – ${ServiceType.fromDb(v.serviceType).label} ($ref)',
            unitPricePaise: v.labourPaise,
            visitId: v.id,
          ),
        );
      }
      for (final p in await visits.parts(v.id)) {
        lines.add(
          InvoiceLineDraft(
            kind: InvoiceItemKind.part,
            description: p.partNumber == null
                ? p.partName
                : '${p.partName} (${p.partNumber})',
            qtyMilli: p.qtyMilli,
            unitPricePaise: p.unitPricePaise,
            visitId: v.id,
          ),
        );
      }
      if (v.travelPaise > 0) {
        lines.add(
          InvoiceLineDraft(
            kind: InvoiceItemKind.travel,
            description: 'Travel / other charges (${v.visitNo})',
            unitPricePaise: v.travelPaise,
            visitId: v.id,
          ),
        );
      }
      discount += v.discountPaise;
      if (taxRate == 0 && v.taxRateBp > 0) taxRate = v.taxRateBp;
    }
    return InvoiceDraft(
      companyId: companyId,
      invoiceDate: date,
      dueDate: Dates.addDays(date, settings.defaultDueDays),
      discountPaise: discount,
      taxLabel: taxRate > 0 ? settings.taxLabel : null,
      taxRateBp: taxRate,
      notes: settings.invoiceTerms,
      lines: lines,
      visitIds: list.map((v) => v.id).toSet(),
    );
  }

  Future<String> _nextNo(
    String table,
    String column,
    String prefix,
    String date,
  ) async {
    final d = Dates.parse(date);
    final series = DocNumbers.seriesPrefix(prefix, d);
    final rows = await db
        .customSelect(
          'SELECT $column AS n FROM $table WHERE $column LIKE ?',
          variables: [Variable.withString('$series%')],
        )
        .get();
    return DocNumbers.next(prefix, d, rows.map((r) => r.read<String>('n')));
  }

  Future<int> _paidOnInvoice(String invoiceId) async {
    final r = await db
        .customSelect(
          'SELECT COALESCE(SUM(amount_paise), 0) AS paid FROM (${Sql.activeAllocations}) '
          'WHERE invoice_id = ?',
          variables: [Variable.withString(invoiceId)],
        )
        .getSingle();
    return r.read<int>('paid');
  }

  Future<Invoice> saveInvoice(
    InvoiceDraft d, {
    required String invoicePrefix,
    String? actor,
  }) {
    if (d.lines.isEmpty) throw BusinessRuleException('Add at least one item');
    for (final l in d.lines) {
      if (l.description.trim().isEmpty) {
        throw BusinessRuleException('Every item needs a description');
      }
      if (l.qtyMilli <= 0) {
        throw BusinessRuleException('Quantity must be more than zero');
      }
      if (l.unitPricePaise < 0) {
        throw BusinessRuleException('Prices cannot be negative');
      }
    }
    final charges = d.charges;
    final err = charges.validate();
    if (err != null) throw BusinessRuleException(err);
    if (Dates.tryParse(d.invoiceDate) == null) {
      throw BusinessRuleException('Select a valid invoice date');
    }
    if (d.dueDate != null && d.dueDate!.compareTo(d.invoiceDate) < 0) {
      throw BusinessRuleException('Due date cannot be before the invoice date');
    }

    return write(() async {
      final now = nowUtc();
      final company = await (db.select(
        db.companies,
      )..where((t) => t.id.equals(d.companyId))).getSingleOrNull();
      if (company == null) throw BusinessRuleException('Select a company');
      final existing = await (db.select(
        db.invoices,
      )..where((t) => t.id.equals(d.id))).getSingleOrNull();
      if (existing?.cancelledAt != null) {
        throw BusinessRuleException('A cancelled invoice cannot be edited');
      }
      if (existing != null && existing.companyId != d.companyId) {
        throw BusinessRuleException(
          'The company of an invoice cannot be changed',
        );
      }
      if (existing != null) {
        final paid = await _paidOnInvoice(d.id);
        if (charges.total < paid) {
          throw BusinessRuleException(
            'The new total is less than the amount already paid',
          );
        }
      }
      for (final vid in d.visitIds) {
        final v = await visits.get(vid);
        if (v == null || v.companyId != d.companyId) {
          throw BusinessRuleException(
            'A selected visit belongs to another company',
          );
        }
        if (v.invoiceId != null && v.invoiceId != d.id) {
          final other = await (db.select(
            db.invoices,
          )..where((t) => t.id.equals(v.invoiceId!))).getSingleOrNull();
          if (other != null && other.cancelledAt == null) {
            throw BusinessRuleException(
              'Visit ${v.visitNo} is already on invoice ${other.invoiceNo}',
            );
          }
        }
      }

      final companion = InvoicesCompanion(
        companyId: Value(d.companyId),
        invoiceDate: Value(d.invoiceDate),
        dueDate: Value(d.dueDate),
        discountPaise: Value(d.discountPaise),
        taxLabel: Value(
          d.taxRateBp > 0 ? emptyToNull(d.taxLabel) ?? 'Tax' : null,
        ),
        taxRateBp: Value(d.taxRateBp),
        subtotalPaise: Value(charges.subtotal),
        taxPaise: Value(charges.tax),
        totalPaise: Value(charges.total),
        notes: Value(emptyToNull(d.notes)),
        updatedAt: Value(now),
      );
      if (existing == null) {
        await db
            .into(db.invoices)
            .insert(
              companion.copyWith(
                id: Value(d.id),
                invoiceNo: Value(
                  await _nextNo(
                    'invoices',
                    'invoice_no',
                    invoicePrefix,
                    d.invoiceDate,
                  ),
                ),
                billToName: Value(company.name),
                billToAddress: Value(
                  emptyToNull(
                    [
                      company.address,
                      company.city,
                      company.state,
                      company.pincode,
                    ].where((s) => s != null && s.trim().isNotEmpty).join(', '),
                  ),
                ),
                billToPhone: Value(company.phone),
                billToGstin: Value(company.gstin),
                createdAt: Value(now),
              ),
            );
      } else {
        await (db.update(
          db.invoices,
        )..where((t) => t.id.equals(d.id))).write(companion);
      }
      await markChanged('invoices', d.id);

      // Items.
      final current = await items(d.id);
      final currentIds = current.map((i) => i.id).toSet();
      for (var i = 0; i < d.lines.length; i++) {
        final l = d.lines[i];
        final row = InvoiceItemsCompanion(
          invoiceId: Value(d.id),
          visitId: Value(l.visitId),
          kind: Value(l.kind.db),
          description: Value(l.description.trim()),
          qtyMilli: Value(l.qtyMilli),
          unitPricePaise: Value(l.unitPricePaise),
          amountPaise: Value(l.amount),
          sortOrder: Value(i),
          updatedAt: Value(now),
        );
        if (currentIds.remove(l.id)) {
          await (db.update(
            db.invoiceItems,
          )..where((t) => t.id.equals(l.id))).write(row);
        } else {
          await db
              .into(db.invoiceItems)
              .insert(row.copyWith(id: Value(l.id), createdAt: Value(now)));
        }
        await markChanged('invoice_items', l.id);
      }
      for (final removed in currentIds) {
        await (db.update(
          db.invoiceItems,
        )..where((t) => t.id.equals(removed))).write(
          InvoiceItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
        await markChanged('invoice_items', removed);
      }

      // Visit links.
      final linked = await (db.select(
        db.serviceVisits,
      )..where((t) => t.invoiceId.equals(d.id))).get();
      for (final v in linked) {
        if (!d.visitIds.contains(v.id)) await _linkVisit(v.id, null, now);
      }
      for (final vid in d.visitIds) {
        if (!linked.any((v) => v.id == vid)) await _linkVisit(vid, d.id, now);
      }

      final saved = await (db.select(
        db.invoices,
      )..where((t) => t.id.equals(d.id))).getSingle();
      await audit(
        entityType: 'invoice',
        entityId: d.id,
        action: existing == null ? 'create' : 'edit',
        summary: existing == null
            ? 'Invoice ${saved.invoiceNo} created'
            : 'Invoice edited',
        changes: existing == null
            ? null
            : BaseRepository.diff(existing.toJson(), saved.toJson()),
        actor: actor,
      );
      return saved;
    });
  }

  Future<void> _linkVisit(
    String visitId,
    String? invoiceId,
    DateTime now,
  ) async {
    await (db.update(
      db.serviceVisits,
    )..where((t) => t.id.equals(visitId))).write(
      ServiceVisitsCompanion(
        invoiceId: Value(invoiceId),
        updatedAt: Value(now),
      ),
    );
    await markChanged('service_visits', visitId);
  }

  /// Cancels an invoice that has no payments applied. Its visits become
  /// available for invoicing again.
  Future<void> cancelInvoice(String id, String reason, {String? actor}) =>
      write(() async {
        if (await _paidOnInvoice(id) > 0) {
          throw BusinessRuleException(
            'This invoice has payments. Void or move the payments first.',
          );
        }
        final now = nowUtc();
        await (db.update(db.invoices)..where((t) => t.id.equals(id))).write(
          InvoicesCompanion(
            cancelledAt: Value(now),
            cancelReason: Value(emptyToNull(reason)),
            updatedAt: Value(now),
          ),
        );
        await markChanged('invoices', id);
        final linked = await (db.select(
          db.serviceVisits,
        )..where((t) => t.invoiceId.equals(id))).get();
        for (final v in linked) {
          await _linkVisit(v.id, null, now);
        }
        await audit(
          entityType: 'invoice',
          entityId: id,
          action: 'cancel',
          summary: 'Invoice cancelled${reason.isEmpty ? '' : ': $reason'}',
          actor: actor,
        );
      });

  // ---------------------------------------------------------------------------
  // Payments
  // ---------------------------------------------------------------------------

  static const _paymentSql = '''
    SELECT p.*, c.name AS company_name, COALESCE(ab.allocated, 0) AS allocated,
      (SELECT GROUP_CONCAT(i.invoice_no, ', ') FROM payment_allocations a
         JOIN invoices i ON i.id = a.invoice_id
         WHERE a.payment_id = p.id AND a.deleted_at IS NULL) AS invoice_nos
    FROM payments p JOIN companies c ON c.id = p.company_id
    LEFT JOIN (${Sql.allocatedByPayment}) ab ON ab.payment_id = p.id''';

  PaymentListItem _mapPayment(QueryRow r) => PaymentListItem(
    db.payments.map(r.data),
    r.read<String>('company_name'),
    r.read<int>('allocated'),
    r.readNullable<String>('invoice_nos'),
  );

  Stream<List<PaymentListItem>> watchPayments(PaymentFilter f) {
    final where = <String>[];
    final vars = <Variable<Object>>[];
    if (!f.includeVoided) where.add('p.voided_at IS NULL');
    void add(String clause, String? v) {
      if (v == null) return;
      where.add(clause);
      vars.add(Variable.withString(v));
    }

    add('p.company_id = ?', f.companyId);
    add('p.method = ?', f.method?.db);
    add('p.paid_on >= ?', f.from);
    add('p.paid_on <= ?', f.to);
    final q = f.query.trim().toLowerCase();
    if (q.isNotEmpty) {
      where.add(
        "(LOWER(p.receipt_no) LIKE ? OR LOWER(c.name) LIKE ? OR LOWER(COALESCE(p.reference, '')) LIKE ?)",
      );
      vars.addAll([for (var i = 0; i < 3; i++) Variable.withString('%$q%')]);
    }
    return db
        .customSelect(
          '$_paymentSql${where.isEmpty ? '' : ' WHERE ${where.join(' AND ')}'}'
          ' ORDER BY p.paid_on DESC, p.created_at DESC',
          variables: vars,
          readsFrom: _reads,
        )
        .watch()
        .map((rows) => rows.map(_mapPayment).toList());
  }

  Stream<PaymentListItem?> watchPayment(String id) => db
      .customSelect(
        '$_paymentSql WHERE p.id = ?',
        variables: [Variable.withString(id)],
        readsFrom: _reads,
      )
      .watchSingleOrNull()
      .map((r) => r == null ? null : _mapPayment(r));

  Future<PaymentListItem?> getPayment(String id) async {
    final r = await db
        .customSelect(
          '$_paymentSql WHERE p.id = ?',
          variables: [Variable.withString(id)],
        )
        .getSingleOrNull();
    return r == null ? null : _mapPayment(r);
  }

  /// Non-void payments of a company with money not yet applied to invoices.
  Future<List<PaymentListItem>> creditPayments(String companyId) async {
    final rows = await db
        .customSelect(
          '$_paymentSql WHERE p.company_id = ? AND p.voided_at IS NULL'
          ' ORDER BY p.paid_on',
          variables: [Variable.withString(companyId)],
        )
        .get();
    return rows.map(_mapPayment).where((p) => p.unallocated > 0).toList();
  }

  /// Records a payment and applies it to invoices. Idempotent on the payment
  /// id: re-submitting the same draft returns the existing payment.
  Future<Payment> recordPayment(
    PaymentDraft d, {
    required String receiptPrefix,
    String? actor,
  }) {
    if (d.amountPaise <= 0) {
      throw BusinessRuleException('Amount received must be more than zero');
    }
    if (Dates.tryParse(d.paidOn) == null) {
      throw BusinessRuleException('Select a valid payment date');
    }
    final allocTotal = d.allocations.values.fold(0, (s, v) => s + v);
    if (allocTotal > d.amountPaise) {
      throw BusinessRuleException('Applied amounts are more than the payment');
    }
    return write(() async {
      final existing = await (db.select(
        db.payments,
      )..where((t) => t.id.equals(d.id))).getSingleOrNull();
      if (existing != null) return existing;

      for (final e in d.allocations.entries) {
        if (e.value <= 0) continue;
        final inv = await getInvoice(e.key);
        if (inv == null || inv.invoice.companyId != d.companyId) {
          throw BusinessRuleException(
            'Invoice does not belong to this company',
          );
        }
        final error = Allocation.validate(
          amount: e.value,
          invoiceOutstanding: inv.balance.outstanding,
          paymentUnallocated: d.amountPaise,
        );
        if (error != null) {
          throw BusinessRuleException('${inv.invoice.invoiceNo}: $error');
        }
      }
      final now = nowUtc();
      await db
          .into(db.payments)
          .insert(
            PaymentsCompanion.insert(
              id: d.id,
              createdAt: now,
              updatedAt: now,
              receiptNo: await _nextNo(
                'payments',
                'receipt_no',
                receiptPrefix,
                d.paidOn,
              ),
              companyId: d.companyId,
              paidOn: d.paidOn,
              amountPaise: d.amountPaise,
              method: Value(d.method.db),
              reference: Value(emptyToNull(d.reference)),
              notes: Value(emptyToNull(d.notes)),
            ),
          );
      await markChanged('payments', d.id);
      for (final e in d.allocations.entries) {
        if (e.value <= 0) continue;
        await _insertAllocation(
          id: Ids.derived('alloc:${d.id}:${e.key}'),
          paymentId: d.id,
          invoiceId: e.key,
          amount: e.value,
          now: now,
        );
      }
      final saved = await (db.select(
        db.payments,
      )..where((t) => t.id.equals(d.id))).getSingle();
      await audit(
        entityType: 'payment',
        entityId: d.id,
        action: 'create',
        summary: 'Payment ${saved.receiptNo} recorded',
        actor: actor,
      );
      return saved;
    });
  }

  Future<void> _insertAllocation({
    required String id,
    required String paymentId,
    required String invoiceId,
    required int amount,
    required DateTime now,
  }) async {
    await db
        .into(db.paymentAllocations)
        .insert(
          PaymentAllocationsCompanion.insert(
            id: id,
            createdAt: now,
            updatedAt: now,
            paymentId: paymentId,
            invoiceId: invoiceId,
            amountPaise: amount,
          ),
        );
    await markChanged('payment_allocations', id);
  }

  /// Applies unused money of an existing payment (advance / credit) to an
  /// invoice.
  Future<void> applyCredit({
    required String paymentId,
    required String invoiceId,
    required int amount,
    String? actor,
  }) => write(() async {
    final p = await getPayment(paymentId);
    final inv = await getInvoice(invoiceId);
    if (p == null || inv == null) {
      throw BusinessRuleException('Record not found');
    }
    if (p.payment.voidedAt != null) {
      throw BusinessRuleException('This payment is void');
    }
    if (p.payment.companyId != inv.invoice.companyId) {
      throw BusinessRuleException(
        'Payment and invoice are for different companies',
      );
    }
    final error = Allocation.validate(
      amount: amount,
      invoiceOutstanding: inv.balance.outstanding,
      paymentUnallocated: p.unallocated,
    );
    if (error != null) throw BusinessRuleException(error);
    await _insertAllocation(
      id: Ids.newId(),
      paymentId: paymentId,
      invoiceId: invoiceId,
      amount: amount,
      now: nowUtc(),
    );
    await audit(
      entityType: 'payment',
      entityId: paymentId,
      action: 'apply_credit',
      summary: 'Applied to ${inv.invoice.invoiceNo}',
      actor: actor,
    );
  });

  /// Edits the non-financial details of a payment. The amount cannot be
  /// changed; void and re-enter instead so history is preserved.
  Future<void> updatePaymentDetails(
    String id, {
    required String paidOn,
    required PaymentMethod method,
    String? reference,
    String? notes,
    String? actor,
  }) => write(() async {
    final before = await (db.select(
      db.payments,
    )..where((t) => t.id.equals(id))).getSingle();
    await (db.update(db.payments)..where((t) => t.id.equals(id))).write(
      PaymentsCompanion(
        paidOn: Value(paidOn),
        method: Value(method.db),
        reference: Value(emptyToNull(reference)),
        notes: Value(emptyToNull(notes)),
        updatedAt: Value(nowUtc()),
      ),
    );
    await markChanged('payments', id);
    final after = await (db.select(
      db.payments,
    )..where((t) => t.id.equals(id))).getSingle();
    await audit(
      entityType: 'payment',
      entityId: id,
      action: 'edit',
      summary: 'Payment details edited',
      changes: BaseRepository.diff(before.toJson(), after.toJson()),
      actor: actor,
    );
  });

  Future<void> voidPayment(String id, String reason, {String? actor}) =>
      write(() async {
        final now = nowUtc();
        await (db.update(db.payments)..where((t) => t.id.equals(id))).write(
          PaymentsCompanion(
            voidedAt: Value(now),
            voidReason: Value(emptyToNull(reason)),
            updatedAt: Value(now),
          ),
        );
        await markChanged('payments', id);
        final allocs = await (db.select(
          db.paymentAllocations,
        )..where((t) => t.paymentId.equals(id) & t.deletedAt.isNull())).get();
        for (final a in allocs) {
          await (db.update(
            db.paymentAllocations,
          )..where((t) => t.id.equals(a.id))).write(
            PaymentAllocationsCompanion(
              deletedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
          await markChanged('payment_allocations', a.id);
        }
        await audit(
          entityType: 'payment',
          entityId: id,
          action: 'void',
          summary: 'Payment voided${reason.isEmpty ? '' : ': $reason'}',
          actor: actor,
        );
      });

  // ---------------------------------------------------------------------------
  // Visit completion
  // ---------------------------------------------------------------------------

  /// Completes a visit and, in the same transaction, optionally creates its
  /// invoice and records the amount received on site. All generated ids are
  /// derived from the visit id, so retrying never duplicates anything.
  Future<CompletionResult> completeVisit(
    VisitDraft d, {
    required BusinessSettings settings,
    required bool createInvoice,
    String? actor,
  }) => write(() async {
    final before = await visits.get(d.id);
    final firstCompletion = before?.status != VisitStatus.completed.db;
    final visit = await visits.save(
      d,
      complete: true,
      visitPrefix: settings.visitPrefix,
      inventoryEnabled: settings.inventoryEnabled,
      actor: actor,
    );
    Invoice? invoice;
    if (createInvoice && visit.invoiceId == null && visit.totalPaise > 0) {
      final draft = await draftFromVisits([visit.id], settings);
      invoice = await saveInvoice(
        InvoiceDraft(
          id: Ids.derived('visit-invoice:${visit.id}'),
          companyId: draft.companyId,
          invoiceDate: draft.invoiceDate,
          dueDate: draft.dueDate,
          discountPaise: draft.discountPaise,
          taxLabel: draft.taxLabel,
          taxRateBp: draft.taxRateBp,
          notes: draft.notes,
          lines: draft.lines,
          visitIds: draft.visitIds,
        ),
        invoicePrefix: settings.invoicePrefix,
        actor: actor,
      );
    }
    Payment? payment;
    if (firstCompletion && visit.onsitePaymentPaise > 0) {
      final target = invoice?.id ?? visit.invoiceId;
      var apply = 0;
      if (target != null) {
        final inv = await getInvoice(target);
        apply = inv == null
            ? 0
            : Allocation.maxAllocatable(
                invoiceOutstanding: inv.balance.outstanding,
                paymentUnallocated: visit.onsitePaymentPaise,
              );
      }
      payment = await recordPayment(
        PaymentDraft(
          id: Ids.derived('visit-payment:${visit.id}'),
          companyId: visit.companyId,
          paidOn: visit.visitDate,
          amountPaise: visit.onsitePaymentPaise,
          method: PaymentMethod.fromDb(visit.onsitePaymentMethod),
          notes: 'Received during visit ${visit.visitNo}',
          allocations: {if (target != null && apply > 0) target: apply},
        ),
        receiptPrefix: settings.receiptPrefix,
        actor: actor,
      );
    }
    return CompletionResult((await visits.get(d.id))!, invoice, payment);
  });

  /// Quantity label helper used by documents.
  static String qtyLabel(int milli) => Qty.format(milli);
}
