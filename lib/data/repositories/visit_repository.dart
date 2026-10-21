import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../domain/drafts.dart';
import '../../domain/enums.dart';
import '../../domain/numbering.dart';
import '../local/app_database.dart';
import 'base_repository.dart';
import 'inventory_repository.dart';
import 'machine_repository.dart';

class VisitListItem {
  const VisitListItem(this.visit, this.companyName, this.machineName);
  final ServiceVisit visit;
  final String companyName;
  final String? machineName;
}

class VisitFilter {
  const VisitFilter({
    this.statuses = const {},
    this.from,
    this.to,
    this.companyId,
    this.machineId,
    this.serviceType,
    this.category,
    this.query = '',
    this.newestFirst = true,
    this.limit,
  });
  final Set<VisitStatus> statuses;
  final String? from;
  final String? to;
  final String? companyId;
  final String? machineId;
  final ServiceType? serviceType;
  final MachineCategory? category;
  final String query;
  final bool newestFirst;
  final int? limit;
}

class VisitRepository extends BaseRepository {
  VisitRepository(super.db, this.inventory, this.machines);

  final InventoryRepository inventory;
  final MachineRepository machines;

  Stream<List<VisitListItem>> watchList(VisitFilter f) {
    final where = <String>['v.archived_at IS NULL'];
    final vars = <Variable<Object>>[];
    if (f.statuses.isNotEmpty) {
      where.add(
        'v.status IN (${List.filled(f.statuses.length, '?').join(',')})',
      );
      vars.addAll(f.statuses.map((s) => Variable.withString(s.db)));
    }
    void add(String clause, String? value) {
      if (value == null) return;
      where.add(clause);
      vars.add(Variable.withString(value));
    }

    add('v.visit_date >= ?', f.from);
    add('v.visit_date <= ?', f.to);
    add('v.company_id = ?', f.companyId);
    add('v.machine_id = ?', f.machineId);
    add('v.service_type = ?', f.serviceType?.db);
    add('m.category = ?', f.category?.db);
    final q = f.query.trim().toLowerCase();
    if (q.isNotEmpty) {
      const cols = [
        'v.visit_no',
        'c.name',
        'm.name',
        'v.reported_problem',
        'v.diagnosis',
        'v.work_done',
        'm.serial_number',
      ];
      where.add(
        '(${cols.map((c) => "LOWER(COALESCE($c, '')) LIKE ?").join(' OR ')})',
      );
      vars.addAll(cols.map((_) => Variable.withString('%$q%')));
    }
    final dir = f.newestFirst ? 'DESC' : 'ASC';
    return db
        .customSelect(
          'SELECT v.*, c.name AS company_name, m.name AS machine_name '
          'FROM service_visits v JOIN companies c ON c.id = v.company_id '
          'LEFT JOIN machines m ON m.id = v.machine_id '
          'WHERE ${where.join(' AND ')} '
          "ORDER BY v.visit_date $dir, COALESCE(v.arrival_time, '') $dir, "
          'v.created_at $dir'
          '${f.limit == null ? '' : ' LIMIT ${f.limit}'}',
          variables: vars,
          readsFrom: {db.serviceVisits, db.companies, db.machines},
        )
        .watch()
        .map(
          (rows) => [
            for (final r in rows)
              VisitListItem(
                db.serviceVisits.map(r.data),
                r.read<String>('company_name'),
                r.readNullable<String>('machine_name'),
              ),
          ],
        );
  }

  Stream<ServiceVisit?> watch(String id) => (db.select(
    db.serviceVisits,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<ServiceVisit?> get(String id) => (db.select(
    db.serviceVisits,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<List<VisitPart>> watchParts(String visitId) =>
      (db.select(db.visitParts)
            ..where((t) => t.visitId.equals(visitId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .watch();

  Future<List<VisitPart>> parts(String visitId) =>
      (db.select(db.visitParts)
            ..where((t) => t.visitId.equals(visitId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .get();

  /// Most recent completed visit of a machine.
  Future<ServiceVisit?> lastVisitForMachine(String machineId) =>
      (db.select(db.serviceVisits)
            ..where(
              (t) =>
                  t.machineId.equals(machineId) &
                  t.status.equals(VisitStatus.completed.db) &
                  t.archivedAt.isNull(),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.visitDate)])
            ..limit(1))
          .getSingleOrNull();

  /// Completed visits of a company that are not on any invoice yet.
  Future<List<ServiceVisit>> uninvoicedVisits(String companyId) =>
      (db.select(db.serviceVisits)
            ..where(
              (t) =>
                  t.companyId.equals(companyId) &
                  t.status.equals(VisitStatus.completed.db) &
                  t.invoiceId.isNull() &
                  t.archivedAt.isNull() &
                  t.totalPaise.isBiggerThanValue(0),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.visitDate)]))
          .get();

  static VisitDraft toDraft(ServiceVisit v, List<VisitPart> parts) =>
      VisitDraft(
        id: v.id,
        companyId: v.companyId,
        machineId: v.machineId,
        visitDate: v.visitDate,
        arrivalTime: v.arrivalTime,
        departureTime: v.departureTime,
        serviceType: ServiceType.fromDb(v.serviceType),
        status: VisitStatus.fromDb(v.status),
        technicianName: v.technicianName,
        reportedProblem: v.reportedProblem,
        symptoms: v.symptoms,
        diagnosis: v.diagnosis,
        rootCause: v.rootCause,
        workDone: v.workDone,
        actionsTaken: v.actionsTaken,
        testsPerformed: v.testsPerformed,
        machineStatusAfter: v.machineStatusAfter == null
            ? null
            : MachineStatus.fromDb(v.machineStatusAfter),
        recommendations: v.recommendations,
        labourPaise: v.labourPaise,
        travelPaise: v.travelPaise,
        discountPaise: v.discountPaise,
        taxRateBp: v.taxRateBp,
        onsitePaymentPaise: v.onsitePaymentPaise,
        onsitePaymentMethod: PaymentMethod.fromDb(v.onsitePaymentMethod),
        customerFeedback: v.customerFeedback,
        signedBy: v.signedBy,
        nextServiceDate: v.nextServiceDate,
        internalNotes: v.internalNotes,
        parts: [
          for (final p in parts)
            VisitPartDraft(
              id: p.id,
              partId: p.partId,
              partName: p.partName,
              partNumber: p.partNumber,
              qtyMilli: p.qtyMilli,
              unitCostPaise: p.unitCostPaise,
              unitPricePaise: p.unitPricePaise,
            ),
        ],
      );

  Future<String> _nextVisitNo(String prefix) async {
    final series = DocNumbers.seriesPrefix(prefix, Dates.now());
    final rows = await db
        .customSelect(
          'SELECT visit_no FROM service_visits WHERE visit_no LIKE ?',
          variables: [Variable.withString('$series%')],
        )
        .get();
    return DocNumbers.next(
      prefix,
      Dates.now(),
      rows.map((r) => r.read<String>('visit_no')),
    );
  }

  void _validate(VisitDraft d) {
    if (d.companyId.isEmpty) throw BusinessRuleException('Select a company');
    if (Dates.tryParse(d.visitDate) == null) {
      throw BusinessRuleException('Select a valid visit date');
    }
    final chargeError = d.charges.validate();
    if (chargeError != null) throw BusinessRuleException(chargeError);
    if (d.onsitePaymentPaise < 0) {
      throw BusinessRuleException('Amount received cannot be negative');
    }
    for (final p in d.parts) {
      if (p.partName.trim().isEmpty) {
        throw BusinessRuleException('Every spare part needs a name');
      }
      if (p.qtyMilli <= 0) {
        throw BusinessRuleException(
          'Quantity for ${p.partName} must be more than zero',
        );
      }
      if (p.unitPricePaise < 0 || (p.unitCostPaise ?? 0) < 0) {
        throw BusinessRuleException('Prices cannot be negative');
      }
    }
  }

  /// Saves a visit (new or existing). With [complete] the visit is finalised:
  /// status becomes completed, stock is deducted, and the machine is updated.
  /// Editing a completed visit is allowed but recorded in the audit log.
  Future<ServiceVisit> save(
    VisitDraft d, {
    bool complete = false,
    required String visitPrefix,
    required bool inventoryEnabled,
    String? actor,
  }) {
    _validate(d);
    return write(() async {
      final now = nowUtc();
      final existing = await get(d.id);
      if (d.machineId != null) {
        final m = await machines.get(d.machineId!);
        if (m == null || m.companyId != d.companyId) {
          throw BusinessRuleException(
            'The selected machine does not belong to this company',
          );
        }
      }
      final wasCompleted = existing?.status == VisitStatus.completed.db;
      // A completed visit always stays completed (a stale form or a retried
      // request can never "un-complete" it).
      final status = complete || wasCompleted
          ? VisitStatus.completed
          : d.status;
      d.status = status;

      // Unlisted parts the user asked to add to the catalogue.
      for (final p in d.parts) {
        if (p.partId == null && p.addToCatalogue) {
          p.partId = await inventory.savePart(
            PartsCompanion.insert(
              id: '',
              createdAt: now,
              updatedAt: now,
              name: p.partName.trim(),
              partNumber: Value(emptyToNull(p.partNumber)),
              purchasePaise: Value(p.unitCostPaise),
              sellingPaise: Value(p.unitPricePaise),
            ),
          );
          p.addToCatalogue = false;
        }
      }

      final charges = d.charges;
      final companion = ServiceVisitsCompanion(
        companyId: Value(d.companyId),
        machineId: Value(d.machineId),
        visitDate: Value(d.visitDate),
        arrivalTime: Value(emptyToNull(d.arrivalTime)),
        departureTime: Value(emptyToNull(d.departureTime)),
        serviceType: Value(d.serviceType.db),
        status: Value(status.db),
        technicianName: Value(emptyToNull(d.technicianName)),
        reportedProblem: Value(emptyToNull(d.reportedProblem)),
        symptoms: Value(emptyToNull(d.symptoms)),
        diagnosis: Value(emptyToNull(d.diagnosis)),
        rootCause: Value(emptyToNull(d.rootCause)),
        workDone: Value(emptyToNull(d.workDone)),
        actionsTaken: Value(emptyToNull(d.actionsTaken)),
        testsPerformed: Value(emptyToNull(d.testsPerformed)),
        machineStatusAfter: Value(d.machineStatusAfter?.db),
        recommendations: Value(emptyToNull(d.recommendations)),
        labourPaise: Value(d.labourPaise),
        travelPaise: Value(d.travelPaise),
        discountPaise: Value(d.discountPaise),
        taxRateBp: Value(d.taxRateBp),
        partsTotalPaise: Value(charges.parts),
        totalPaise: Value(charges.total),
        // The on-site amount becomes a payment on completion; afterwards it
        // is history and cannot be edited here.
        onsitePaymentPaise: wasCompleted
            ? const Value.absent()
            : Value(d.onsitePaymentPaise),
        onsitePaymentMethod: wasCompleted
            ? const Value.absent()
            : Value(d.onsitePaymentMethod.db),
        customerFeedback: Value(emptyToNull(d.customerFeedback)),
        signedBy: Value(emptyToNull(d.signedBy)),
        nextServiceDate: Value(emptyToNull(d.nextServiceDate)),
        internalNotes: Value(emptyToNull(d.internalNotes)),
        completedAt: status == VisitStatus.completed
            ? Value(existing?.completedAt ?? now)
            : const Value(null),
        updatedAt: Value(now),
      );

      if (existing == null) {
        await db
            .into(db.serviceVisits)
            .insert(
              companion.copyWith(
                id: Value(d.id),
                visitNo: Value(await _nextVisitNo(visitPrefix)),
                createdAt: Value(now),
              ),
            );
      } else {
        await (db.update(
          db.serviceVisits,
        )..where((t) => t.id.equals(d.id))).write(companion);
      }
      await markChanged('service_visits', d.id);

      final partsChange = await _saveParts(d, now);
      final saved = (await get(d.id))!;

      if (status == VisitStatus.completed) {
        if (saved.machineId != null) {
          await machines.applyVisitOutcome(
            machineId: saved.machineId!,
            visit: saved,
          );
        }
        await inventory.syncVisitStock(
          d.id,
          inventoryEnabled: inventoryEnabled,
        );
      }

      if (existing == null) {
        await audit(
          entityType: 'visit',
          entityId: d.id,
          action: 'create',
          summary: 'Visit ${saved.visitNo} created (${status.label})',
          actor: actor,
        );
      }
      if (!wasCompleted &&
          status == VisitStatus.completed &&
          existing != null) {
        await audit(
          entityType: 'visit',
          entityId: d.id,
          action: 'complete',
          summary: 'Visit completed',
          actor: actor,
        );
      } else if (wasCompleted) {
        final changes = BaseRepository.diff(existing!.toJson(), saved.toJson());
        if (partsChange != null) changes['parts'] = partsChange;
        if (changes.isNotEmpty) {
          await audit(
            entityType: 'visit',
            entityId: d.id,
            action: 'edit_completed',
            summary:
                'Completed visit edited (${changes.length} change'
                '${changes.length == 1 ? '' : 's'})',
            changes: changes,
            actor: actor,
          );
        }
      }
      return saved;
    });
  }

  /// Upserts the draft's parts and soft-deletes removed ones. Returns a short
  /// description of the change (for the audit log), or null if unchanged.
  Future<String?> _saveParts(VisitDraft d, DateTime now) async {
    final current = await (db.select(
      db.visitParts,
    )..where((t) => t.visitId.equals(d.id) & t.deletedAt.isNull())).get();
    final currentById = {for (final p in current) p.id: p};
    final changes = <String>[];
    for (var i = 0; i < d.parts.length; i++) {
      final p = d.parts[i];
      final old = currentById.remove(p.id);
      final row = VisitPartsCompanion(
        visitId: Value(d.id),
        partId: Value(p.partId),
        partName: Value(p.partName.trim()),
        partNumber: Value(emptyToNull(p.partNumber)),
        qtyMilli: Value(p.qtyMilli),
        unitCostPaise: Value(p.unitCostPaise),
        unitPricePaise: Value(p.unitPricePaise),
        sortOrder: Value(i),
        updatedAt: Value(now),
      );
      if (old == null) {
        await db
            .into(db.visitParts)
            .insert(row.copyWith(id: Value(p.id), createdAt: Value(now)));
        changes.add('added ${p.partName}');
      } else {
        final changed =
            old.partId != p.partId ||
            old.partName != p.partName.trim() ||
            old.qtyMilli != p.qtyMilli ||
            old.unitPricePaise != p.unitPricePaise ||
            old.unitCostPaise != p.unitCostPaise ||
            old.sortOrder != i ||
            old.partNumber != emptyToNull(p.partNumber);
        if (!changed) continue;
        await (db.update(
          db.visitParts,
        )..where((t) => t.id.equals(p.id))).write(row);
        if (old.qtyMilli != p.qtyMilli ||
            old.unitPricePaise != p.unitPricePaise) {
          changes.add('changed ${p.partName}');
        }
      }
      await markChanged('visit_parts', p.id);
    }
    for (final removed in currentById.values) {
      await (db.update(
        db.visitParts,
      )..where((t) => t.id.equals(removed.id))).write(
        VisitPartsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await markChanged('visit_parts', removed.id);
      changes.add('removed ${removed.partName}');
    }
    return changes.isEmpty ? null : changes.join(', ');
  }

  /// Creates a scheduled (future) visit.
  Future<ServiceVisit> schedule({
    required String companyId,
    String? machineId,
    required String date,
    String? time,
    ServiceType serviceType = ServiceType.routineMaintenance,
    String? purpose,
    String? notes,
    String? technicianName,
    required String visitPrefix,
    String? id,
  }) => save(
    VisitDraft(
      id: id,
      companyId: companyId,
      machineId: machineId,
      visitDate: date,
      arrivalTime: time,
      serviceType: serviceType,
      status: VisitStatus.scheduled,
      reportedProblem: purpose,
      internalNotes: notes,
      technicianName: technicianName,
    ),
    visitPrefix: visitPrefix,
    inventoryEnabled: false,
  );

  Future<void> _setFields(
    String id,
    ServiceVisitsCompanion data, {
    required String action,
    required String summary,
  }) => write(() async {
    final v = await get(id);
    if (v == null) throw BusinessRuleException('Visit not found');
    if (v.status == VisitStatus.completed.db) {
      throw BusinessRuleException('This visit is already completed');
    }
    await (db.update(db.serviceVisits)..where((t) => t.id.equals(id))).write(
      data.copyWith(updatedAt: Value(nowUtc())),
    );
    await markChanged('service_visits', id);
    await audit(
      entityType: 'visit',
      entityId: id,
      action: action,
      summary: summary,
    );
  });

  Future<void> reschedule(String id, String date, String? time) => _setFields(
    id,
    ServiceVisitsCompanion(
      visitDate: Value(date),
      arrivalTime: Value(time),
      status: Value(VisitStatus.scheduled.db),
    ),
    action: 'reschedule',
    summary: 'Rescheduled to ${Dates.display(date)}',
  );

  Future<void> start(String id) => _setFields(
    id,
    ServiceVisitsCompanion(
      status: Value(VisitStatus.inProgress.db),
      visitDate: Value(Dates.today()),
    ),
    action: 'start',
    summary: 'Visit started',
  );

  Future<void> cancel(String id, String? reason) => _setFields(
    id,
    ServiceVisitsCompanion(status: Value(VisitStatus.cancelled.db)),
    action: 'cancel',
    summary:
        'Visit cancelled${reason == null || reason.isEmpty ? '' : ': $reason'}',
  );

  /// Removes an unfinished visit from lists (kept in the database).
  Future<void> archive(String id) => _setFields(
    id,
    ServiceVisitsCompanion(archivedAt: Value(nowUtc())),
    action: 'archive',
    summary: 'Visit deleted',
  );

  Stream<List<AuditEntry>> watchHistory(String entityType, String entityId) =>
      (db.select(db.auditLog)
            ..where(
              (t) =>
                  t.entityType.equals(entityType) & t.entityId.equals(entityId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();
}
