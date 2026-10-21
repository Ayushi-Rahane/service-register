import '../core/utils/dates.dart';

class PlannedNotification {
  const PlannedNotification(
    this.id,
    this.at,
    this.title,
    this.body,
    this.payload,
  );
  final int id;

  /// Local wall-clock time.
  final DateTime at;
  final String title;
  final String body;

  /// Route to open when tapped.
  final String payload;
}

class VisitForReminder {
  const VisitForReminder(
    this.id,
    this.date,
    this.time,
    this.company,
    this.purpose,
  );
  final String id, date, company;
  final String? time, purpose;
}

class ReminderForPlan {
  const ReminderForPlan(
    this.id,
    this.date,
    this.time,
    this.title,
    this.company,
  );
  final String id, date, title;
  final String? time, company;
}

class InvoiceForPlan {
  const InvoiceForPlan(
    this.id,
    this.invoiceNo,
    this.company,
    this.dueDate,
    this.balance,
  );
  final String id, invoiceNo, company, dueDate;
  final int balance;
}

/// Decides which local notifications to schedule. Platforms limit pending
/// notifications (iOS: 64), so only the nearest [max] are kept. Delivery is
/// best effort: the OS may delay or drop notifications (battery savers).
abstract final class NotificationPlanner {
  static const max = 50;
  static const horizonDays = 30;

  static DateTime _at(String isoDate, String? time, {int defaultHour = 8}) {
    final d = Dates.parse(isoDate);
    if (time != null && time.contains(':')) {
      final p = time.split(':');
      return DateTime(d.year, d.month, d.day, int.parse(p[0]), int.parse(p[1]));
    }
    return DateTime(d.year, d.month, d.day, defaultHour);
  }

  static List<PlannedNotification> plan({
    required DateTime now,
    required List<VisitForReminder> visits,
    required List<ReminderForPlan> reminders,
    required List<InvoiceForPlan> openInvoices,
  }) {
    final horizon = now.add(const Duration(days: horizonDays));
    final out = <PlannedNotification>[];
    var id = 1000;

    for (final v in visits) {
      final start = _at(v.date, v.time);
      // 1 hour before a timed visit, else 8 AM on the day.
      final at = v.time == null
          ? start
          : start.subtract(const Duration(hours: 1));
      if (at.isBefore(now) || at.isAfter(horizon)) continue;
      out.add(
        PlannedNotification(
          id++,
          at,
          'Visit ${v.time == null ? 'today' : 'at ${Dates.displayTime(v.time)}'}: ${v.company}',
          v.purpose?.isNotEmpty == true
              ? v.purpose!
              : 'Scheduled service visit',
          '/visits/${v.id}',
        ),
      );
    }
    for (final r in reminders) {
      final at = _at(r.date, r.time, defaultHour: 9);
      if (at.isBefore(now) || at.isAfter(horizon)) continue;
      out.add(
        PlannedNotification(
          id++,
          at,
          'Reminder: ${r.title}',
          r.company ?? 'Tap to open',
          '/schedule',
        ),
      );
    }
    var overdueNow = 0;
    for (final i in openInvoices) {
      final due = Dates.parse(i.dueDate);
      final firstOverdueMorning = DateTime(
        due.year,
        due.month,
        due.day + 1,
        10,
      );
      if (firstOverdueMorning.isBefore(now)) {
        overdueNow++;
        continue;
      }
      if (firstOverdueMorning.isAfter(horizon)) continue;
      out.add(
        PlannedNotification(
          id++,
          firstOverdueMorning,
          'Payment overdue: ${i.invoiceNo}',
          '${i.company} has not cleared this invoice',
          '/invoices/${i.id}',
        ),
      );
    }
    if (overdueNow > 0) {
      final tomorrow = DateTime(now.year, now.month, now.day + 1, 10);
      out.add(
        PlannedNotification(
          999,
          tomorrow,
          '$overdueNow invoice${overdueNow == 1 ? '' : 's'} overdue',
          'Open Payments to follow up',
          '/billing',
        ),
      );
    }
    out.sort((a, b) => a.at.compareTo(b.at));
    return out.take(max).toList();
  }
}
