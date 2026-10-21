import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/core/utils/dates.dart';
import 'package:service_register/data/local/app_database.dart';
import 'package:service_register/data/repositories/attachment_repository.dart';
import 'package:service_register/data/repositories/billing_repository.dart';
import 'package:service_register/data/repositories/settings_repository.dart';
import 'package:service_register/data/sync/sync_remote.dart';
import 'package:service_register/data/sync/sync_service.dart';
import 'package:service_register/domain/drafts.dart';

import '../support/fake_remote.dart';
import '../support/test_db.dart';

SyncService syncFor(TestEnv env, FakeRemote remote, Directory dir) =>
    SyncService(
      db: env.db,
      remote: remote,
      settings: SettingsRepository(env.db),
      attachments: AttachmentRepository(env.db, () async => dir),
    );

void main() {
  late Directory tmp;
  setUp(() {
    fixToday('2026-10-16');
    tmp = Directory.systemTemp.createTempSync('sync_test');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  Future<void> billableVisit(TestEnv env) async {
    final co = await env.addCompany('Shree');
    final draft = VisitDraft(
      companyId: co,
      visitDate: Dates.today(),
      labourPaise: 100000,
      onsitePaymentPaise: 40000,
    );
    await env.billing.completeVisit(
      draft,
      settings: env.settings,
      createInvoice: true,
    );
  }

  test('offline changes survive an app restart and sync later', () async {
    final file = File('${tmp.path}/app.sqlite');
    var env = TestEnv(AppDatabase(NativeDatabase(file)));
    await billableVisit(env);
    final pendingBefore = await env.db.select(env.db.syncOutbox).get();
    expect(pendingBefore, isNotEmpty);
    await env.close();

    // "Restart": reopen the same file.
    env = TestEnv(AppDatabase(NativeDatabase(file)));
    expect(await env.companies.watchList().first, hasLength(1));
    expect(
      await env.billing.watchInvoices(const InvoiceFilter()).first,
      hasLength(1),
    );
    expect(
      (await env.db.select(env.db.syncOutbox).get()).length,
      pendingBefore.length,
    );

    final remote = FakeRemote();
    await syncFor(env, remote, tmp).syncNow();
    expect(await env.db.select(env.db.syncOutbox).get(), isEmpty);
    expect(remote.rows('invoices'), hasLength(1));
    expect(remote.rows('payments'), hasLength(1));
    final local = await env.db.select(env.db.invoices).getSingle();
    expect(local.serverRev, 1);
    await env.close();
  });

  test('failed sync while offline keeps changes queued', () async {
    final env = TestEnv();
    await env.addCompany('Shree');
    final remote = FakeRemote()..offline = true;
    final sync = syncFor(env, remote, tmp);
    await expectLater(sync.syncNow(), throwsA(isA<SyncTransportException>()));
    expect(await env.db.select(env.db.syncOutbox).get(), hasLength(1));
    remote.offline = false;
    await sync.syncNow();
    expect(await env.db.select(env.db.syncOutbox).get(), isEmpty);
    expect(remote.rows('companies'), hasLength(1));
    await env.close();
  });

  test(
    'retries after a lost response do not duplicate invoices or payments',
    () async {
      final env = TestEnv();
      await billableVisit(env);
      final remote = FakeRemote()..loseNextResponse = true;
      final sync = syncFor(env, remote, tmp);
      await expectLater(sync.syncNow(), throwsA(isA<SyncTransportException>()));
      // Server applied everything, client did not hear back: all still queued.
      expect(await env.db.select(env.db.syncOutbox).get(), isNotEmpty);

      await sync.syncNow();
      await sync.syncNow();
      expect(remote.rows('invoices'), hasLength(1));
      expect(remote.rows('payments'), hasLength(1));
      expect(remote.rows('payment_allocations'), hasLength(1));
      expect(remote.rows('invoices').single['rev'], 1);
      expect(await env.db.select(env.db.syncOutbox).get(), isEmpty);
      expect(await env.db.select(env.db.syncConflicts).get(), isEmpty);
      await env.close();
    },
  );

  test('an edit made during an in-flight push is not lost', () async {
    final env = TestEnv();
    final id = await env.addCompany('Shree');
    final remote = FakeRemote()..loseNextResponse = true;
    final sync = syncFor(env, remote, tmp);
    await expectLater(sync.syncNow(), throwsA(isA<SyncTransportException>()));
    // User edits again before the retry: new op id, same device.
    await env.companies.save(
      const CompaniesCompanion(city: Value('Pune')),
      id: id,
    );
    await sync.syncNow();
    expect(remote.rows('companies').single['city'], 'Pune');
    expect(await env.db.select(env.db.syncConflicts).get(), isEmpty);
    await env.close();
  });

  test('stale local edits never overwrite newer server data', () async {
    final env = TestEnv();
    final id = await env.addCompany('Shree');
    final remote = FakeRemote();
    final sync = syncFor(env, remote, tmp);
    await sync.syncNow();

    remote.editFromOtherDevice('companies', id, {'phone': '9999999999'});
    await env.companies.save(
      const CompaniesCompanion(city: Value('Nashik')),
      id: id,
    );
    await sync.syncNow();

    // Server version kept; local edit saved for review.
    expect(remote.rows('companies').single['phone'], '9999999999');
    expect(remote.rows('companies').single['city'], isNull);
    final local = (await env.companies.get(id))!;
    expect(local.phone, '9999999999');
    final conflicts = await env.db.select(env.db.syncConflicts).get();
    expect(conflicts.single.localData, contains('Nashik'));
    await env.close();
  });

  test(
    'pull brings records from another device (restore on a new phone)',
    () async {
      final phoneA = TestEnv();
      await billableVisit(phoneA);
      final remote = FakeRemote();
      await syncFor(phoneA, remote, tmp).syncNow();

      final phoneB = TestEnv();
      final report = await syncFor(phoneB, remote, tmp).syncNow();
      expect(report.pulled, greaterThan(5));
      final inv =
          (await phoneB.billing.watchInvoices(const InvoiceFilter()).first)
              .single;
      expect(inv.balance.outstanding, 60000);
      expect(inv.invoice.invoiceNo, 'INV-2627-0001');
      // A second pull is a no-op.
      final again = await syncFor(phoneB, remote, tmp).syncNow();
      expect(again.pulled, 0);
      // Next invoice number continues the series on the new phone.
      await billableVisit(phoneB);
      final nos = (await phoneB.db.select(phoneB.db.invoices).get()).map(
        (i) => i.invoiceNo,
      );
      expect(nos, containsAll(['INV-2627-0001', 'INV-2627-0002']));
      await phoneA.close();
      await phoneB.close();
    },
  );

  group('switching accounts on one device', () {
    Future<int> count(TestEnv env) async =>
        (await env.db.select(env.db.companies).get()).length;

    test('first sign-in adopts the local records', () async {
      final env = TestEnv();
      await env.addCompany('Shree');
      final sync = syncFor(env, FakeRemote(), tmp);
      var wiped = false;
      expect(
        await sync.ensureAccount(
          userId: 'user-a',
          clearLocalData: () async => wiped = true,
        ),
        isNull,
      );
      expect(wiped, isFalse);
      expect(await count(env), 1);
      await env.close();
    });

    test('another account of the same business keeps the records', () async {
      final env = TestEnv();
      final remote = FakeRemote();
      final sync = syncFor(env, remote, tmp);
      await env.addCompany('Shree');
      await sync.ensureAccount(userId: 'daughter', clearLocalData: () async {});
      await sync.syncNow();
      var wiped = false;
      expect(
        await sync.ensureAccount(
          userId: 'father',
          clearLocalData: () async => wiped = true,
        ),
        isNull,
      );
      expect(wiped, isFalse);
      await env.close();
    });

    test(
      'fully uploaded copy is replaced when a different account signs in',
      () async {
        final env = TestEnv();
        final remote = FakeRemote();
        final sync = syncFor(env, remote, tmp);
        await env.addCompany('Shree');
        await sync.ensureAccount(userId: 'user-a', clearLocalData: () async {});
        await sync.syncNow();
        expect(await env.db.select(env.db.syncOutbox).get(), isEmpty);

        remote.business = 'biz-2';
        var wiped = false;
        expect(
          await sync.ensureAccount(
            userId: 'user-b',
            clearLocalData: () async => wiped = true,
          ),
          isNull,
        );
        expect(wiped, isTrue);
        await env.close();
      },
    );

    test(
      'changes not yet uploaded block a different account (nothing lost)',
      () async {
        final env = TestEnv();
        final remote = FakeRemote();
        final sync = syncFor(env, remote, tmp);
        await sync.ensureAccount(userId: 'user-a', clearLocalData: () async {});
        await env.addCompany('Not uploaded yet');

        remote.business = 'biz-2';
        var wiped = false;
        final message = await sync.ensureAccount(
          userId: 'user-b',
          clearLocalData: () async => wiped = true,
        );
        expect(message, contains('not uploaded yet'));
        expect(wiped, isFalse);
        expect(await count(env), 1);
        await env.close();
      },
    );

    test(
      'devices from before this check (user id only) keep working',
      () async {
        final env = TestEnv();
        final settings = SettingsRepository(env.db);
        await settings.setValue(SyncService.ownerKey, 'user-a');
        await env.addCompany('Shree');
        final sync = syncFor(env, FakeRemote(), tmp);
        var wiped = false;
        expect(
          await sync.ensureAccount(
            userId: 'user-a',
            clearLocalData: () async => wiped = true,
          ),
          isNull,
        );
        expect(wiped, isFalse);
        expect(await settings.getValue(SyncService.businessKey), 'biz-1');
        await env.close();
      },
    );
  });
}
