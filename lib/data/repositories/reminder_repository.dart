import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../../domain/enums.dart';
import '../local/app_database.dart';
import 'base_repository.dart';

class ReminderItem {
  const ReminderItem(this.reminder, this.companyName, this.invoiceNo);
  final Reminder reminder;
  final String? companyName;
  final String? invoiceNo;
}

class ReminderRepository extends BaseRepository {
  ReminderRepository(super.db);

  Stream<List<ReminderItem>> watch({
    Set<ReminderStatus> statuses = const {ReminderStatus.pending},
    String? until,
    String? companyId,
  }) {
    final where = <String>[
      'r.status IN (${List.filled(statuses.length, '?').join(',')})',
    ];
    final vars = <Variable<Object>>[
      ...statuses.map((s) => Variable.withString(s.db)),
    ];
    if (until != null) {
      where.add('r.due_date <= ?');
      vars.add(Variable.withString(until));
    }
    if (companyId != null) {
      where.add('r.company_id = ?');
      vars.add(Variable.withString(companyId));
    }
    return db
        .customSelect(
          'SELECT r.*, c.name AS company_name, i.invoice_no AS invoice_no '
          'FROM reminders r LEFT JOIN companies c ON c.id = r.company_id '
          'LEFT JOIN invoices i ON i.id = r.invoice_id '
          'WHERE ${where.join(' AND ')} '
          "ORDER BY r.due_date, COALESCE(r.due_time, '')",
          variables: vars,
          readsFrom: {db.reminders, db.companies, db.invoices},
        )
        .watch()
        .map(
          (rows) => [
            for (final r in rows)
              ReminderItem(
                db.reminders.map(r.data),
                r.readNullable<String>('company_name'),
                r.readNullable<String>('invoice_no'),
              ),
          ],
        );
  }

  Future<Reminder?> get(String id) => (db.select(
    db.reminders,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> save(RemindersCompanion data, {String? id}) => write(() async {
    if (data.title.present && data.title.value.trim().isEmpty) {
      throw BusinessRuleException('Enter what the reminder is about');
    }
    final now = nowUtc();
    final rowId = id ?? Ids.newId();
    final existing = await get(rowId);
    if (existing == null) {
      await db
          .into(db.reminders)
          .insert(
            data.copyWith(
              id: Value(rowId),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    } else {
      await (db.update(db.reminders)..where((t) => t.id.equals(rowId))).write(
        data.copyWith(updatedAt: Value(now)),
      );
    }
    await markChanged('reminders', rowId);
    return rowId;
  });

  Future<void> markDone(String id) => save(
    RemindersCompanion(
      status: Value(ReminderStatus.done.db),
      doneAt: Value(nowUtc()),
    ),
    id: id,
  );

  Future<void> cancel(String id) => save(
    RemindersCompanion(status: Value(ReminderStatus.cancelled.db)),
    id: id,
  );

  Future<void> reschedule(String id, String date, String? time) => save(
    RemindersCompanion(
      dueDate: Value(date),
      dueTime: Value(time),
      status: Value(ReminderStatus.pending.db),
      doneAt: const Value(null),
    ),
    id: id,
  );
}
