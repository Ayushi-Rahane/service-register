// End-to-end check of the core workflow on a device/emulator:
//   flutter test integration_test -d <device-id>
// Uses an in-memory database, so it never touches real data on the phone.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:service_register/app.dart';
import 'package:service_register/core/providers.dart';
import 'package:service_register/data/local/app_database.dart';
import 'package:service_register/domain/app_settings.dart';

Future<void> settle(WidgetTester tester, [int frames = 15]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

Future<void> tapText(WidgetTester tester, String text) async {
  final f = find.text(text).last;
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('company → visit → invoice → partial payment', (tester) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          initialSettingsProvider.overrideWithValue(
            const BusinessSettings(
              onboarded: true,
              businessName: 'Rahane Services',
            ),
          ),
        ],
        child: const ServiceApp(
          onboarded: true,
          enableBackgroundServices: false,
        ),
      ),
    );
    await settle(tester);

    // 1. Add a company.
    await tapText(tester, 'Companies');
    await tapText(tester, 'Add company');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Company name *'),
      'Shree Electronics',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone number'),
      '9822012345',
    );
    await tapText(tester, 'Save company');
    expect(find.text('Account'), findsOneWidget);

    // 2. Record a visit from the company screen.
    await tapText(tester, 'New visit');
    await tester.enterText(
      find.widgetWithText(TextFormField, "Customer's complaint"),
      'Spindle not rotating',
    );
    await tester.scrollUntilVisible(
      find.widgetWithText(TextFormField, 'Labour / service charges'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester, 2);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Labour / service charges'),
      '1500',
    );
    await settle(tester, 3);

    // 3. Complete it and create the invoice.
    await tapText(tester, 'Complete visit');
    expect(find.text('Complete this visit?'), findsOneWidget);
    await tapText(tester, 'Complete');
    await settle(tester, 25);
    // Post-completion shortcuts appear.
    expect(find.text('Visit completed. What next?'), findsOneWidget);
    await tapText(tester, 'Record a payment');

    // 4. Record a partial payment of ₹500.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount received *'),
      '500',
    );
    await settle(tester, 3);
    await tester.scrollUntilVisible(
      find.widgetWithText(TextFormField, 'Amount for this invoice'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester, 2);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount for this invoice'),
      '500',
    );
    await settle(tester, 3);
    await tapText(tester, 'Save payment • ₹500.00');
    await settle(tester, 20);

    final invoice = await db.select(db.invoices).getSingle();
    expect(invoice.totalPaise, 150000);
    final alloc = await db.select(db.paymentAllocations).getSingle();
    expect(alloc.amountPaise, 50000);
    expect(
      find.text('RCPT-${invoice.invoiceNo.split('-')[1]}-0001'),
      findsWidgets,
    );

    await tester.pumpWidget(const SizedBox());
    await settle(tester, 3);
    await db.close();
  });
}
