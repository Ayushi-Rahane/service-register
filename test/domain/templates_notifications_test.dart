import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/domain/app_settings.dart';
import 'package:service_register/domain/notification_plan.dart';
import 'package:service_register/domain/templates.dart';

void main() {
  test('payment reminder template fills placeholders', () {
    final text = MessageTemplates.paymentReminder(
      template: BusinessSettings.defaultReminderTemplate,
      companyName: 'Shree Electronics',
      contactPerson: 'Mr. Patil',
      invoiceNo: 'INV-2627-0012',
      invoiceDate: '2026-09-20',
      totalPaise: 1250000,
      balancePaise: 450000,
      dueDate: '2026-10-05',
      today: '2026-10-16',
      businessName: 'Rahane Services',
      upiId: 'rahane@upi',
    );
    expect(text, contains('Dear Mr. Patil'));
    expect(text, contains('INV-2627-0012'));
    expect(text, contains('₹12,500.00'));
    expect(text, contains('₹4,500.00, overdue since 05 Oct 2026'));
    expect(text, contains('UPI: rahane@upi'));
    expect(text, isNot(contains('{')));
  });

  test(
    'notification plan: nearest first, past items skipped, overdue summary',
    () {
      final now = DateTime(2026, 10, 16, 12);
      final plans = NotificationPlanner.plan(
        now: now,
        visits: const [
          VisitForReminder('v1', '2026-10-17', null, 'Shree', 'AMC'),
          VisitForReminder('v2', '2026-10-16', '15:30', 'Alpha', null),
          VisitForReminder('v3', '2026-10-10', null, 'Old', null),
        ],
        reminders: const [
          ReminderForPlan('r1', '2026-10-18', null, 'Call', null),
        ],
        openInvoices: const [
          InvoiceForPlan('i1', 'INV-1', 'Shree', '2026-10-01', 100),
          InvoiceForPlan('i2', 'INV-2', 'Alpha', '2026-10-20', 100),
        ],
      );
      expect(plans.map((p) => p.payload), [
        '/visits/v2',
        '/visits/v1',
        '/billing',
        '/schedule',
        '/invoices/i2',
      ]);
      expect(plans.first.at, DateTime(2026, 10, 16, 14, 30));
      expect(
        plans.firstWhere((p) => p.payload == '/billing').title,
        '1 invoice overdue',
      );
    },
  );
}
