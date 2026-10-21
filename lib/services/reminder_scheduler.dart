import 'dart:async';

import 'package:drift/drift.dart';

import '../core/utils/dates.dart';
import '../data/local/app_database.dart';
import '../data/repositories/sql.dart';
import '../domain/notification_plan.dart';
import 'notification_service.dart';

/// Keeps scheduled local notifications in line with the data: whenever visits,
/// reminders or invoices change, the plan is recomputed (debounced).
class ReminderScheduler {
  ReminderScheduler(this.db, this.notifications);

  final AppDatabase db;
  final NotificationService notifications;
  StreamSubscription<Object?>? _sub;
  Timer? _debounce;
  bool enabled = true;

  void start() {
    _sub ??= db
        .tableUpdates(
          TableUpdateQuery.onAllTables([
            db.serviceVisits,
            db.reminders,
            db.invoices,
            db.paymentAllocations,
            db.payments,
          ]),
        )
        .listen((_) => schedule());
    schedule();
  }

  void schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), () => unawaited(refresh()));
  }

  Future<void> refresh() async {
    if (!enabled) {
      await notifications.cancelAll();
      return;
    }
    final today = Dates.today();
    final until = Dates.addDays(today, NotificationPlanner.horizonDays);
    final visits = await db
        .customSelect(
          'SELECT v.id, v.visit_date, v.arrival_time, v.reported_problem, c.name FROM service_visits v '
          "JOIN companies c ON c.id = v.company_id WHERE v.status = 'scheduled' AND v.archived_at IS NULL "
          'AND v.visit_date BETWEEN ? AND ?',
          variables: [Variable.withString(today), Variable.withString(until)],
        )
        .get();
    final reminders = await db
        .customSelect(
          'SELECT r.id, r.due_date, r.due_time, r.title, c.name FROM reminders r '
          "LEFT JOIN companies c ON c.id = r.company_id WHERE r.status = 'pending' AND r.due_date BETWEEN ? AND ?",
          variables: [Variable.withString(today), Variable.withString(until)],
        )
        .get();
    final invoices = await db
        .customSelect(
          'SELECT i.id, i.invoice_no, i.due_date, c.name, i.total_paise - COALESCE(pb.paid, 0) AS balance '
          'FROM invoices i JOIN companies c ON c.id = i.company_id '
          'LEFT JOIN (${Sql.paidByInvoice}) pb ON pb.invoice_id = i.id '
          'WHERE i.cancelled_at IS NULL AND i.due_date IS NOT NULL AND i.total_paise > COALESCE(pb.paid, 0)',
        )
        .get();
    final plans = NotificationPlanner.plan(
      now: DateTime.now(),
      visits: [
        for (final r in visits)
          VisitForReminder(
            r.read<String>('id'),
            r.read<String>('visit_date'),
            r.readNullable<String>('arrival_time'),
            r.read<String>('name'),
            r.readNullable<String>('reported_problem'),
          ),
      ],
      reminders: [
        for (final r in reminders)
          ReminderForPlan(
            r.read<String>('id'),
            r.read<String>('due_date'),
            r.readNullable<String>('due_time'),
            r.read<String>('title'),
            r.readNullable<String>('name'),
          ),
      ],
      openInvoices: [
        for (final r in invoices)
          InvoiceForPlan(
            r.read<String>('id'),
            r.read<String>('invoice_no'),
            r.read<String>('name'),
            r.read<String>('due_date'),
            r.read<int>('balance'),
          ),
      ],
    );
    await notifications.apply(plans);
  }

  void dispose() {
    _debounce?.cancel();
    unawaited(_sub?.cancel());
  }
}
