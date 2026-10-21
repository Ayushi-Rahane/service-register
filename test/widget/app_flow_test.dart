import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/app.dart';
import 'package:service_register/core/providers.dart';
import 'package:service_register/data/local/app_database.dart';
import 'package:service_register/domain/app_settings.dart';

/// Pumps the real app (router, screens, repositories) on an in-memory DB.
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  bool onboarded = true,
}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase(NativeDatabase.memory());
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(
          BusinessSettings(
            onboarded: onboarded,
            businessName: 'Rahane Services',
          ),
        ),
      ],
      child: ServiceApp(onboarded: onboarded, enableBackgroundServices: false),
    ),
  );
  await settle(tester);
  return db;
}

/// Lets real database I/O complete between frames (pumpAndSettle alone would
/// spin forever on loading indicators inside the fake-async test zone).
Future<void> settle(WidgetTester tester, {int rounds = 12}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 15)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> disposeApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  // Flush drift's stream-cleanup timers (fake zone) before closing for real.
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(db.close);
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('home dashboard shows key sections and empty states', (
    tester,
  ) async {
    final db = await pumpApp(tester);
    expect(find.text('Rahane Services'), findsOneWidget);
    expect(find.text('Collected this month'), findsOneWidget);
    expect(find.text('Billed this month'), findsOneWidget);
    expect(find.text('No visits planned for today'), findsOneWidget);
    expect(find.text('New service visit'), findsOneWidget);
    // Bottom navigation
    for (final label in ['Home', 'Companies', 'Visits', 'Payments', 'More']) {
      expect(find.text(label), findsWidgets);
    }
    await disposeApp(tester, db);
  });

  testWidgets('add a company: validation, save, appears in list and search', (
    tester,
  ) async {
    final db = await pumpApp(tester);
    await tester.tap(find.text('Companies').last);
    await settle(tester);
    expect(find.text('No companies yet'), findsOneWidget);

    await tester.tap(find.text('Add company').first);
    await settle(tester);
    await tester.tap(find.text('Save company'));
    await settle(tester);
    expect(find.text('Company name is required'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Company name *'),
      'Shree Electronics',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone number'),
      '98220 12345',
    );
    await tester.tap(find.text('Save company'));
    await settle(tester);
    // Lands on the company detail screen.
    expect(find.text('Shree Electronics'), findsWidgets);
    expect(find.text('Account'), findsOneWidget);

    final rows = await db.select(db.companies).get();
    expect(rows.single.code, 'C-0001');
    expect(
      await db.select(db.syncOutbox).get(),
      isNotEmpty,
      reason: 'change queued for sync',
    );
    await disposeApp(tester, db);
  });

  testWidgets('duplicate company warning lets the user go back', (
    tester,
  ) async {
    final db = await pumpApp(tester);
    final now = DateTime.now().toUtc();
    await db
        .into(db.companies)
        .insert(
          CompaniesCompanion.insert(
            id: 'c1',
            name: 'Shree Electronics Pvt Ltd',
            createdAt: now,
            updatedAt: now,
            phone: const Value('9822012345'),
          ),
        );
    await tester.tap(find.text('Companies').last);
    await settle(tester);
    await tester.tap(find.text('Add company').first);
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Company name *'),
      'Shree Electronics',
    );
    await tester.tap(find.text('Save company'));
    await settle(tester);
    expect(find.text('Possible duplicate'), findsOneWidget);
    await tester.tap(find.text('Go back'));
    await settle(tester);
    expect(await db.select(db.companies).get(), hasLength(1));
    await disposeApp(tester, db);
  });

  testWidgets('quick visit: save as draft with only a company', (tester) async {
    final db = await pumpApp(tester);
    final now = DateTime.now().toUtc();
    await db
        .into(db.companies)
        .insert(
          CompaniesCompanion.insert(
            id: 'c1',
            name: 'Alpha Circuits',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await tester.tap(find.text('New service visit'));
    await settle(tester);
    expect(find.text('Visit details'), findsOneWidget);

    await tester.tap(find.widgetWithText(InputDecorator, 'Company *'));
    await settle(tester);
    await tester.tap(find.text('Alpha Circuits'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, "Customer's complaint"),
      'Conveyor jam',
    );
    await tester.tap(find.text('Save as draft'));
    await settle(tester);

    final visit = await db.select(db.serviceVisits).getSingle();
    expect(visit.status, 'in_progress');
    expect(visit.reportedProblem, 'Conveyor jam');
    expect(find.text(visit.visitNo), findsWidgets); // detail screen
    await disposeApp(tester, db);
  });

  testWidgets('onboarding saves the business name', (tester) async {
    final db = await pumpApp(tester, onboarded: false);
    expect(find.text('Welcome to Service Register'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Business name *'),
      'Rahane Machine Services',
    );
    await tester.tap(find.text('Start using the app'));
    await settle(tester);
    final saved = await (db.select(
      db.appSettings,
    )..where((t) => t.key.equals('business_name'))).getSingle();
    expect(saved.value, 'Rahane Machine Services');
    await disposeApp(tester, db);
  });

  testWidgets(
    'full flow: company → complete visit → invoice → partial payment',
    (tester) async {
      final db = await pumpApp(tester);
      Future<void> tapText(String t) async {
        final f = find.text(t).last;
        await tester.ensureVisible(f);
        await tester.pump();
        await tester.tap(f);
        await settle(tester);
      }

      await tapText('Companies');
      await tapText('Add company');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Company name *'),
        'Shree Electronics',
      );
      await tapText('Save company');
      expect(find.text('Account'), findsOneWidget);

      await tapText('New visit');
      await tester.enterText(
        find.widgetWithText(TextFormField, "Customer's complaint"),
        'Spindle not rotating',
      );
      await tester.scrollUntilVisible(
        find.widgetWithText(TextFormField, 'Labour / service charges'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await settle(tester, rounds: 2);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Labour / service charges'),
        '1500',
      );
      await settle(tester, rounds: 3);
      await tapText('Complete visit');
      expect(find.text('Complete this visit?'), findsOneWidget);
      await tapText('Complete');
      await settle(tester, rounds: 20);
      expect(find.text('Visit completed. What next?'), findsOneWidget);
      await tapText('Record a payment');

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount received *'),
        '500',
      );
      await settle(tester, rounds: 3);
      await tester.scrollUntilVisible(
        find.widgetWithText(TextFormField, 'Amount for this invoice'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await settle(tester, rounds: 2);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount for this invoice'),
        '500',
      );
      await settle(tester, rounds: 3);
      await tapText('Save payment • ₹500.00');
      await settle(tester, rounds: 15);

      final invoice = await db.select(db.invoices).getSingle();
      expect(invoice.totalPaise, 150000);
      expect(
        (await db.select(db.paymentAllocations).getSingle()).amountPaise,
        50000,
      );
      expect(
        (await db.select(db.serviceVisits).getSingle()).status,
        'completed',
      );
      expect(
        find.text('Applied to invoices'),
        findsOneWidget,
      ); // payment detail screen
      await disposeApp(tester, db);
    },
  );

  testWidgets(
    'large system text: tab labels keep their size; one "New visit" button',
    (tester) async {
      final db = await pumpApp(tester);
      double labelHeight() =>
          tester.getSize(find.text('Companies').last).height;
      final normal = labelHeight();
      // Phone / browser text size turned up (as on the reported iPhone).
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await settle(tester);
      expect(
        labelHeight(),
        normal,
        reason: 'tab labels must not grow and wrap',
      );

      await tester.tap(find.text('Visits').last);
      await settle(tester);
      expect(find.text('New visit'), findsOneWidget);
      await disposeApp(tester, db);
    },
  );
}
