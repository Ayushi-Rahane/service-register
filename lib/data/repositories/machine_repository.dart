import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/enums.dart';
import '../local/app_database.dart';
import 'base_repository.dart';

class MachineListItem {
  const MachineListItem(this.machine, this.lastVisit, this.companyName);
  final Machine machine;
  final String? lastVisit;
  final String companyName;
}

class PartReplacement {
  const PartReplacement({
    required this.partName,
    required this.qtyMilli,
    required this.visitNo,
    required this.visitDate,
  });
  final String partName;
  final int qtyMilli;
  final String visitNo;
  final String visitDate;
}

class RecurringFault {
  const RecurringFault(this.description, this.count, this.lastDate);
  final String description;
  final int count;
  final String lastDate;
}

class MachineStats {
  const MachineStats({
    required this.visitCount,
    required this.totalSpend,
    required this.lastVisit,
    required this.partsReplaced,
    required this.recurringFaults,
  });
  final int visitCount;
  final int totalSpend;
  final String? lastVisit;
  final List<PartReplacement> partsReplaced;
  final List<RecurringFault> recurringFaults;
}

class MachineRepository extends BaseRepository {
  MachineRepository(super.db);

  static const _listSql = '''
    SELECT m.*, c.name AS company_name,
      (SELECT MAX(v.visit_date) FROM service_visits v WHERE v.machine_id = m.id
         AND v.status = 'completed' AND v.archived_at IS NULL) AS last_visit
    FROM machines m JOIN companies c ON c.id = m.company_id''';

  Stream<List<MachineListItem>> watchForCompany(
    String companyId, {
    bool includeArchived = false,
  }) => db
      .customSelect(
        '$_listSql WHERE m.company_id = ?'
        '${includeArchived ? '' : ' AND m.archived_at IS NULL'}'
        ' ORDER BY m.archived_at IS NOT NULL, m.name COLLATE NOCASE',
        variables: [Variable.withString(companyId)],
        readsFrom: {db.machines, db.serviceVisits, db.companies},
      )
      .watch()
      .map(_mapList);

  /// Machines whose next maintenance is due on or before [untilIso].
  Stream<List<MachineListItem>> watchMaintenanceDue(String untilIso) => db
      .customSelect(
        '$_listSql WHERE m.archived_at IS NULL AND c.archived_at IS NULL'
        " AND m.status != 'decommissioned' AND m.next_service_due IS NOT NULL"
        ' AND m.next_service_due <= ? ORDER BY m.next_service_due',
        variables: [Variable.withString(untilIso)],
        readsFrom: {db.machines, db.serviceVisits, db.companies},
      )
      .watch()
      .map(_mapList);

  List<MachineListItem> _mapList(List<QueryRow> rows) => [
    for (final r in rows)
      MachineListItem(
        db.machines.map(r.data),
        r.readNullable<String>('last_visit'),
        r.read<String>('company_name'),
      ),
  ];

  Stream<Machine?> watch(String id) => (db.select(
    db.machines,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<Machine?> get(String id) =>
      (db.select(db.machines)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Machine>> forCompany(String companyId) =>
      (db.select(db.machines)
            ..where(
              (t) => t.companyId.equals(companyId) & t.archivedAt.isNull(),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.name.lower())]))
          .get();

  Future<String> save(MachinesCompanion data, {String? id}) => write(() async {
    if (data.name.present && data.name.value.trim().isEmpty) {
      throw BusinessRuleException('Machine name is required');
    }
    final now = nowUtc();
    final existing = id == null ? null : await get(id);
    final rowId = id ?? Ids.newId();
    if (existing == null) {
      if (!data.companyId.present) {
        throw BusinessRuleException('Select the company for this machine');
      }
      await db
          .into(db.machines)
          .insert(
            data.copyWith(
              id: Value(rowId),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    } else {
      await (db.update(db.machines)..where((t) => t.id.equals(rowId))).write(
        data.copyWith(updatedAt: Value(now)),
      );
    }
    await markChanged('machines', rowId);
    return rowId;
  });

  Future<void> setArchived(String id, bool archived) => write(() async {
    final now = nowUtc();
    await (db.update(db.machines)..where((t) => t.id.equals(id))).write(
      MachinesCompanion(
        archivedAt: Value(archived ? now : null),
        updatedAt: Value(now),
      ),
    );
    await markChanged('machines', id);
  });

  /// Updates the machine after a completed visit (status / next due date).
  Future<void> applyVisitOutcome({
    required String machineId,
    required ServiceVisit visit,
  }) async {
    final machine = await get(machineId);
    if (machine == null) return;
    String? nextDue = visit.nextServiceDate;
    if (nextDue == null &&
        machine.serviceIntervalDays != null &&
        machine.serviceIntervalDays! > 0 &&
        visit.serviceType == ServiceType.routineMaintenance.db) {
      nextDue = Dates.addDays(visit.visitDate, machine.serviceIntervalDays!);
    }
    final status = visit.machineStatusAfter;
    if (nextDue == machine.nextServiceDue &&
        (status == null || status == machine.status)) {
      return;
    }
    await (db.update(db.machines)..where((t) => t.id.equals(machineId))).write(
      MachinesCompanion(
        nextServiceDue: nextDue == null ? const Value.absent() : Value(nextDue),
        status: status == null ? const Value.absent() : Value(status),
        updatedAt: Value(nowUtc()),
      ),
    );
    await markChanged('machines', machineId);
  }

  Stream<MachineStats> watchStats(String machineId) {
    final visitsQuery =
        (db.select(db.serviceVisits)
              ..where(
                (t) =>
                    t.machineId.equals(machineId) &
                    t.status.equals(VisitStatus.completed.db) &
                    t.archivedAt.isNull(),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.visitDate)]))
            .watch();
    return visitsQuery.asyncMap((visits) async {
      final ids = visits.map((v) => v.id).toList();
      final parts = ids.isEmpty
          ? <VisitPart>[]
          : await (db.select(
              db.visitParts,
            )..where((t) => t.visitId.isIn(ids) & t.deletedAt.isNull())).get();
      final byId = {for (final v in visits) v.id: v};
      final replaced = [
        for (final p in parts)
          PartReplacement(
            partName: p.partName,
            qtyMilli: p.qtyMilli,
            visitNo: byId[p.visitId]!.visitNo,
            visitDate: byId[p.visitId]!.visitDate,
          ),
      ]..sort((a, b) => b.visitDate.compareTo(a.visitDate));
      return MachineStats(
        visitCount: visits.length,
        totalSpend: visits.fold(0, (s, v) => s + v.totalPaise),
        lastVisit: visits.isEmpty ? null : visits.first.visitDate,
        partsReplaced: replaced,
        recurringFaults: recurringFaults(visits),
      );
    });
  }

  /// Faults reported or diagnosed on two or more visits.
  static List<RecurringFault> recurringFaults(List<ServiceVisit> visits) {
    final counts = <String, ({String text, int count, String last})>{};
    for (final v in visits) {
      final seen = <String>{};
      for (final text in [v.diagnosis, v.reportedProblem]) {
        if (text == null || text.trim().isEmpty) continue;
        final key = text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
        if (!seen.add(key)) continue;
        final prev = counts[key];
        counts[key] = (
          text: prev?.text ?? text.trim(),
          count: (prev?.count ?? 0) + 1,
          last: prev == null || v.visitDate.compareTo(prev.last) > 0
              ? v.visitDate
              : prev.last,
        );
      }
    }
    return [
      for (final e in counts.values)
        if (e.count >= 2) RecurringFault(e.text, e.count, e.last),
    ]..sort((a, b) => b.count.compareTo(a.count));
  }
}
