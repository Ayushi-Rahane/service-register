import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/duplicates.dart';
import '../../domain/numbering.dart';
import '../local/app_database.dart';
import 'base_repository.dart';
import 'sql.dart';

class CompanyListItem {
  const CompanyListItem({
    required this.company,
    required this.machineCount,
    required this.outstanding,
    required this.lastVisit,
  });
  final Company company;
  final int machineCount;
  final int outstanding;
  final String? lastVisit;
}

class CompanySummary {
  const CompanySummary({
    required this.billed,
    required this.received,
    required this.outstanding,
    required this.credit,
    required this.lastVisit,
    required this.nextVisit,
    required this.visitCount,
  });
  final int billed;

  /// Total of non-void payments (including unallocated advances).
  final int received;
  final int outstanding;

  /// Payments not yet applied to any invoice (advance / credit).
  final int credit;
  final String? lastVisit;
  final String? nextVisit;
  final int visitCount;
}

class DuplicateMatch {
  const DuplicateMatch(this.company, this.reason);
  final Company company;
  final String reason;
}

enum CompanySort { name, recent, outstanding }

class CompanyRepository extends BaseRepository {
  CompanyRepository(super.db);

  static const _listSql =
      '''
    SELECT c.*,
      (SELECT COUNT(*) FROM machines m
         WHERE m.company_id = c.id AND m.archived_at IS NULL) AS machine_count,
      COALESCE((SELECT SUM(i.total_paise) FROM invoices i
         WHERE i.company_id = c.id AND i.cancelled_at IS NULL), 0)
      - COALESCE((SELECT SUM(pb.paid) FROM (${Sql.paidByInvoice}) pb
         JOIN invoices i ON i.id = pb.invoice_id
         WHERE i.company_id = c.id AND i.cancelled_at IS NULL), 0) AS outstanding,
      (SELECT MAX(v.visit_date) FROM service_visits v
         WHERE v.company_id = c.id AND v.status = 'completed'
           AND v.archived_at IS NULL) AS last_visit
    FROM companies c''';

  Set<ResultSetImplementation<dynamic, dynamic>> get _reads => {
    db.companies,
    db.machines,
    db.invoices,
    db.payments,
    db.paymentAllocations,
    db.serviceVisits,
  };

  Stream<List<CompanyListItem>> watchList({
    String query = '',
    bool archived = false,
    CompanySort sort = CompanySort.name,
  }) {
    final q = query.trim().toLowerCase();
    final digits = q.replaceAll(RegExp(r'\D'), '');
    final where = StringBuffer(
      archived ? 'c.archived_at IS NOT NULL' : 'c.archived_at IS NULL',
    );
    final vars = <Variable<Object>>[];
    if (q.isNotEmpty) {
      where.write(
        ' AND (LOWER(c.name) LIKE ? OR LOWER(COALESCE(c.code, \'\')) LIKE ?'
        ' OR LOWER(COALESCE(c.contact_person, \'\')) LIKE ?'
        ' OR LOWER(COALESCE(c.city, \'\')) LIKE ?',
      );
      vars.addAll([for (var i = 0; i < 4; i++) Variable.withString('%$q%')]);
      if (digits.length >= 3) {
        where.write(
          " OR REPLACE(REPLACE(COALESCE(c.phone, ''), ' ', ''), '-', '') LIKE ?"
          " OR REPLACE(REPLACE(COALESCE(c.alt_phone, ''), ' ', ''), '-', '') LIKE ?",
        );
        vars.addAll([
          Variable.withString('%$digits%'),
          Variable.withString('%$digits%'),
        ]);
      }
      where.write(')');
    }
    final order = switch (sort) {
      CompanySort.name => 'c.name COLLATE NOCASE',
      CompanySort.recent =>
        'COALESCE(last_visit, \'\') DESC, c.name COLLATE NOCASE',
      CompanySort.outstanding => 'outstanding DESC, c.name COLLATE NOCASE',
    };
    return db
        .customSelect(
          '$_listSql WHERE $where ORDER BY $order',
          variables: vars,
          readsFrom: _reads,
        )
        .watch()
        .map(
          (rows) => [
            for (final r in rows)
              CompanyListItem(
                company: db.companies.map(r.data),
                machineCount: r.read<int>('machine_count'),
                outstanding: r.read<int>('outstanding'),
                lastVisit: r.readNullable<String>('last_visit'),
              ),
          ],
        );
  }

  Stream<Company?> watch(String id) => (db.select(
    db.companies,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<Company?> get(String id) => (db.select(
    db.companies,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Company>> activeCompanies() =>
      (db.select(db.companies)
            ..where((t) => t.archivedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.name.lower())]))
          .get();

  Stream<CompanySummary> watchSummary(String companyId) {
    return db
        .customSelect(
          '''
      SELECT
        COALESCE((SELECT SUM(total_paise) FROM invoices
           WHERE company_id = ?1 AND cancelled_at IS NULL), 0) AS billed,
        COALESCE((SELECT SUM(amount_paise) FROM payments
           WHERE company_id = ?1 AND voided_at IS NULL), 0) AS received,
        COALESCE((SELECT SUM(pb.paid) FROM (${Sql.paidByInvoice}) pb
           JOIN invoices i ON i.id = pb.invoice_id
           WHERE i.company_id = ?1 AND i.cancelled_at IS NULL), 0) AS allocated,
        COALESCE((SELECT SUM(ab.allocated) FROM (${Sql.allocatedByPayment}) ab
           JOIN payments p ON p.id = ab.payment_id
           WHERE p.company_id = ?1), 0) AS payments_allocated,
        (SELECT MAX(visit_date) FROM service_visits WHERE company_id = ?1
           AND status = 'completed' AND archived_at IS NULL) AS last_visit,
        (SELECT MIN(visit_date) FROM service_visits WHERE company_id = ?1
           AND status = 'scheduled' AND archived_at IS NULL
           AND visit_date >= ?2) AS next_visit,
        (SELECT COUNT(*) FROM service_visits WHERE company_id = ?1
           AND status = 'completed' AND archived_at IS NULL) AS visit_count
      ''',
          variables: [
            Variable.withString(companyId),
            Variable.withString(Dates.today()),
          ],
          readsFrom: _reads,
        )
        .watchSingle()
        .map((r) {
          final billed = r.read<int>('billed');
          final received = r.read<int>('received');
          return CompanySummary(
            billed: billed,
            received: received,
            outstanding: billed - r.read<int>('allocated'),
            credit: received - r.read<int>('payments_allocated'),
            lastVisit: r.readNullable<String>('last_visit'),
            nextVisit: r.readNullable<String>('next_visit'),
            visitCount: r.read<int>('visit_count'),
          );
        });
  }

  /// Likely duplicates by similar name or same phone number.
  Future<List<DuplicateMatch>> findPossibleDuplicates({
    required String name,
    String? phone,
    String? altPhone,
    String? excludeId,
  }) async {
    final all = await db.select(db.companies).get();
    final matches = <DuplicateMatch>[];
    for (final c in all) {
      if (c.id == excludeId) continue;
      final phones = [c.phone, c.altPhone];
      final phoneHit = [
        phone,
        altPhone,
      ].any((p) => phones.any((q) => Duplicates.samePhone(p, q)));
      if (phoneHit) {
        matches.add(DuplicateMatch(c, 'Same phone number'));
      } else if (name.trim().isNotEmpty &&
          Duplicates.similarName(name, c.name)) {
        matches.add(DuplicateMatch(c, 'Similar name'));
      }
    }
    return matches;
  }

  Future<String> nextCode() async {
    final rows = await db.customSelect('SELECT code FROM companies').get();
    return DocNumbers.nextCompanyCode(
      rows.map((r) => r.readNullable<String>('code')),
    );
  }

  /// Creates or updates a company. [data] holds the editable fields.
  Future<String> save(CompaniesCompanion data, {String? id}) {
    return write(() async {
      final now = nowUtc();
      final existing = id == null ? null : await get(id);
      final rowId = id ?? Ids.newId();
      if (data.name.present && data.name.value.trim().isEmpty) {
        throw BusinessRuleException('Company name is required');
      }
      if (existing == null) {
        var code = data.code.present ? emptyToNull(data.code.value) : null;
        code ??= await nextCode();
        await db
            .into(db.companies)
            .insert(
              data.copyWith(
                id: Value(rowId),
                code: Value(code),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      } else {
        await (db.update(db.companies)..where((t) => t.id.equals(rowId))).write(
          data.copyWith(updatedAt: Value(now)),
        );
      }
      await markChanged('companies', rowId);
      return rowId;
    });
  }

  Future<void> setArchived(String id, bool archived) {
    return write(() async {
      final now = nowUtc();
      await (db.update(db.companies)..where((t) => t.id.equals(id))).write(
        CompaniesCompanion(
          archivedAt: Value(archived ? now : null),
          updatedAt: Value(now),
        ),
      );
      await markChanged('companies', id);
      await audit(
        entityType: 'company',
        entityId: id,
        action: archived ? 'archive' : 'restore',
        summary: archived ? 'Company archived' : 'Company restored',
      );
    });
  }
}
