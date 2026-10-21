import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/app.dart';
import 'package:service_register/core/providers.dart';
import 'package:service_register/data/local/app_database.dart';
import 'package:service_register/data/repositories/settings_repository.dart';
import 'package:service_register/domain/app_settings.dart';
import 'package:service_register/services/account_gate.dart';
import 'package:service_register/services/auth_service.dart';

import 'app_flow_test.dart' show disposeApp, settle;

/// Account service stand-in: cloud "configured", no network.
class FakeAuth extends AuthService {
  FakeAuth() : super.test();
  final calls = <String>[];

  @override
  bool get configured => true;
  @override
  Stream<void> get signedOutEvents => const Stream.empty();
  @override
  Stream<bool> get signedInChanges => const Stream.empty();

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
    String? businessName,
  }) async {
    calls.add('signUp $email $fullName $businessName');
    return false; // signed in straight away (no email confirmation)
  }

  @override
  Future<void> signIn(String email, String password) async =>
      calls.add('signIn $email');

  @override
  Future<({String? businessName, String? fullName})> accountInfo() async =>
      (businessName: 'Rahane Machine Services', fullName: 'M Rahane');

  @override
  Future<void> signOut() async => calls.add('signOut');
}

Future<(AppDatabase, FakeAuth, AccountGate)> pumpSignedOut(
  WidgetTester tester,
) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase(NativeDatabase.memory());
  final auth = FakeAuth();
  final gate = AccountGate(
    auth: auth,
    settings: SettingsRepository(db),
    signedIn: false,
  );
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        authServiceProvider.overrideWithValue(auth),
        accountGateProvider.overrideWithValue(gate),
        initialSettingsProvider.overrideWithValue(const BusinessSettings()),
      ],
      child: const ServiceApp(
        onboarded: false,
        enableBackgroundServices: false,
      ),
    ),
  );
  await settle(tester);
  return (db, auth, gate);
}

Future<String?> setting(AppDatabase db, String key) async => (await (db.select(
  db.appSettings,
)..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

void main() {
  // The connectivity plugin has no implementation in widget tests.
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          const EventChannel('dev.fluttercommunity.plus/connectivity_status'),
          MockStreamHandler.inline(
            onListen: (_, sink) => sink.success(['wifi']),
          ),
        );
  });

  testWidgets(
    'first screen is sign in / create account; sign-up opens the app',
    (tester) async {
      final (db, auth, _) = await pumpSignedOut(tester);
      expect(find.text('Sign in'), findsWidgets);
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Business name *'), findsNothing); // only when creating

      await tester.tap(find.text('Create account'));
      await settle(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Your name *'),
        'M Rahane',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Business name *'),
        'Rahane Machine Services',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email *'),
        'father@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password *'),
        'secret-123',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await settle(tester, rounds: 20);

      expect(
        auth.calls.single,
        'signUp father@example.com M Rahane Rahane Machine Services',
      );
      expect(
        find.text('Rahane Machine Services'),
        findsOneWidget,
      ); // home app bar
      expect(find.text('Collected this month'), findsOneWidget);
      expect(await setting(db, 'business_name'), 'Rahane Machine Services');
      expect(await setting(db, AccountGate.key), 'true');
      await disposeApp(tester, db);
    },
  );

  testWidgets(
    'sign-in on a new device restores business details; sign-out returns here',
    (tester) async {
      final (db, auth, gate) = await pumpSignedOut(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email *'),
        'father@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password *'),
        'secret-123',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await settle(tester, rounds: 20);

      expect(auth.calls, ['signIn father@example.com']);
      expect(find.text('Rahane Machine Services'), findsOneWidget);
      expect(await setting(db, 'owner_name'), 'M Rahane');

      await gate.signOut();
      await settle(tester);
      expect(find.text('Create account'), findsOneWidget);
      expect(await setting(db, AccountGate.key), isNull);
      await disposeApp(tester, db);
    },
  );

  testWidgets('wrong password shows a message and stays on the first screen', (
    tester,
  ) async {
    final (db, _, _) = await pumpSignedOut(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await settle(tester);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(find.text('Collected this month'), findsNothing);
    await disposeApp(tester, db);
  });
}
