// End-to-end sync against a real PostgreSQL database with the Supabase
// schema (RLS, triggers, sync_push). Skipped when no local Postgres runs.
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/core/utils/dates.dart';
import 'package:service_register/data/local/app_database.dart';
import 'package:service_register/data/repositories/attachment_repository.dart';
import 'package:service_register/data/repositories/billing_repository.dart';
import 'package:service_register/data/repositories/settings_repository.dart';
import 'package:service_register/data/sync/sync_service.dart';
import 'package:service_register/domain/drafts.dart';
import 'package:service_register/domain/enums.dart';

import '../support/pg_remote.dart';
import '../support/test_db.dart';

void main() {
  late PgRemote remote;
  late Directory tmp;

  setUpAll(() async {
    if (PgRemote.available) remote = await PgRemote.create();
  });
  tearDownAll(() async {
    if (PgRemote.available) await remote.drop();
  });
  setUp(() {
    fixToday('2026-10-16');
    tmp = Directory.systemTemp.createTempSync('pg_sync');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  SyncService syncFor(TestEnv env) => SyncService(
    db: env.db,
    remote: remote,
    settings: SettingsRepository(env.db),
    attachments: AttachmentRepository(env.db, () async => tmp),
  );

  test(
    'records uploaded by one device download completely on another',
    () async {
      // Phone: the kind of data the real account holds.
      final phone = TestEnv();
      final co = await phone.companies.save(
        const CompaniesCompanion(
          name: Value('Techno Circuit Systems'),
          phone: Value('9822012345'),
          city: Value('Pune'),
        ),
      );
      final m1 = await phone.addMachine(co, 'PCB Drilling Machine');
      await phone.addMachine(co, 'CBC Unit', category: 'cbc');
      final relay = await phone.addPart(
        'Relay 24V',
        stockMilli: 10000,
        sellingPaise: 25000,
      );
      final v1 = VisitDraft(
        companyId: co,
        machineId: m1,
        visitDate: Dates.today(),
        serviceType: ServiceType.breakdownRepair,
        reportedProblem: 'Spindle not rotating',
        arrivalTime: '10:30',
        labourPaise: 150000,
        taxRateBp: 1800,
        nextServiceDate: '2027-01-16',
        machineStatusAfter: MachineStatus.operational,
        onsitePaymentPaise: 50000,
        onsitePaymentMethod: PaymentMethod.upi,
        parts: [
          VisitPartDraft(
            partId: relay,
            partName: 'Relay 24V',
            qtyMilli: 2000,
            unitPricePaise: 25000,
          ),
        ],
      );
      await phone.billing.completeVisit(
        v1,
        settings: phone.settings,
        createInvoice: true,
      );
      await phone.visits.schedule(
        companyId: co,
        machineId: m1,
        date: '2026-10-30',
        visitPrefix: 'SV',
        purpose: 'Preventive maintenance',
      );

      final phoneSync = syncFor(phone);
      expect(
        await phoneSync.ensureAccount(
          userId: remote.userId,
          clearLocalData: () async {},
        ),
        isNull,
      );
      final up = await phoneSync.syncNow();
      expect(up.errors, 0, reason: 'every change accepted by the server');
      expect(await phone.db.select(phone.db.syncOutbox).get(), isEmpty);

      // Website / new phone: empty, signs in to the same account.
      final web = TestEnv();
      final webSync = syncFor(web);
      expect(
        await webSync.ensureAccount(
          userId: remote.userId,
          clearLocalData: () async {},
        ),
        isNull,
      );
      final down = await webSync.syncNow();
      expect(down.pulled, greaterThan(10));

      final companies = await web.companies.watchList().first;
      expect(companies.single.company.name, 'Techno Circuit Systems');
      expect(companies.single.machineCount, 2);
      final visits = await web.db.select(web.db.serviceVisits).get();
      expect(visits, hasLength(2));
      final done = visits.firstWhere((v) => v.status == 'completed');
      expect(done.arrivalTime, '10:30');
      expect(done.nextServiceDate, '2027-01-16');
      expect(done.completedAt, isNotNull);
      final inv =
          (await web.billing.watchInvoices(const InvoiceFilter()).first).single;
      expect(inv.invoice.totalPaise, 236000);
      expect(inv.balance.outstanding, 186000);
      expect(await web.inventory.stockOf(relay), 8000);
      expect(await web.db.select(web.db.auditLog).get(), isNotEmpty);

      // Syncing again changes nothing and uploads nothing.
      final again = await webSync.syncNow();
      expect(again.pulled, 0);
      expect(again.pushed, 0);

      // An edit on the second device reaches the first.
      await web.companies.save(
        const CompaniesCompanion(city: Value('Nashik')),
        id: co,
      );
      await webSync.syncNow();
      await phoneSync.syncNow();
      expect((await phone.companies.get(co))!.city, 'Nashik');

      await phone.close();
      await web.close();
    },
    skip: PgRemote.available ? false : 'needs a local PostgreSQL server',
  );
}
