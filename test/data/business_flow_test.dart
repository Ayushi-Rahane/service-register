import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/core/utils/dates.dart';
import 'package:service_register/data/local/app_database.dart';
import 'package:service_register/data/repositories/base_repository.dart';
import 'package:service_register/data/repositories/billing_repository.dart';
import 'package:service_register/data/repositories/visit_repository.dart';
import 'package:service_register/domain/drafts.dart';
import 'package:service_register/domain/enums.dart';

import '../support/test_db.dart';

void main() {
  late TestEnv env;

  setUp(() {
    fixToday('2026-10-16');
    env = TestEnv();
  });
  tearDown(() => env.close());

  group('Companies', () {
    test('create, edit, search and archive', () async {
      final id = await env.addCompany(
        'Shree Electronics',
        phone: '98220 12345',
      );
      final c = await env.companies.get(id);
      expect(c!.code, 'C-0001');

      await env.companies.save(
        const CompaniesCompanion(
          city: Value('Pune'),
          contactPerson: Value('Mr. Patil'),
        ),
        id: id,
      );
      expect((await env.companies.get(id))!.city, 'Pune');

      await env.addCompany('Alpha Circuits');
      expect(
        (await env.companies.watchList(query: 'shree').first).single.company.id,
        id,
      );
      expect(
        (await env.companies.watchList(query: '9822012345').first)
            .single
            .company
            .id,
        id,
      );
      expect(
        (await env.companies.watchList(query: 'C-0001').first)
            .single
            .company
            .id,
        id,
      );
      expect(
        (await env.companies.watchList(query: 'patil').first),
        hasLength(1),
      );

      await env.companies.setArchived(id, true);
      final active = await env.companies.watchList().first;
      expect(active.map((e) => e.company.name), ['Alpha Circuits']);
      final archived = await env.companies.watchList(archived: true).first;
      expect(archived.single.company.id, id);
    });

    test('warns about duplicates but does not merge', () async {
      await env.addCompany('Shree Electronics Pvt Ltd', phone: '9822012345');
      final byName = await env.companies.findPossibleDuplicates(
        name: 'shree electronics',
      );
      expect(byName, hasLength(1));
      final byPhone = await env.companies.findPossibleDuplicates(
        name: 'Totally Different',
        phone: '+91 98220-12345',
      );
      expect(byPhone.single.reason, 'Same phone number');
      // Saving anyway is allowed: still two records.
      await env.addCompany('Shree Electronics');
      expect(await env.companies.watchList().first, hasLength(2));
    });

    test('rejects empty names', () async {
      expect(
        () => env.companies.save(const CompaniesCompanion(name: Value('  '))),
        throwsA(isA<BusinessRuleException>()),
      );
    });
  });

  group('Machines and visits', () {
    test('multiple machines belong to one company', () async {
      final co = await env.addCompany('Shree');
      await env.addMachine(co, 'PCB Line 1');
      await env.addMachine(co, 'CBC Unit', category: 'cbc');
      final other = await env.addCompany('Other');
      await env.addMachine(other, 'Elsewhere');
      final list = await env.machines.watchForCompany(co).first;
      expect(list.map((m) => m.machine.name), ['CBC Unit', 'PCB Line 1']);
    });

    test(
      'visit is recorded against the correct machine with multiple parts',
      () async {
        final co = await env.addCompany('Shree');
        final m1 = await env.addMachine(co, 'M1');
        final m2 = await env.addMachine(co, 'M2');
        final draft = VisitDraft(
          companyId: co,
          machineId: m2,
          visitDate: Dates.today(),
          reportedProblem: 'Not starting',
          labourPaise: 150000,
          parts: [
            VisitPartDraft(
              partName: 'Relay',
              qtyMilli: 2000,
              unitPricePaise: 25000,
            ),
            VisitPartDraft(
              partName: 'Fuse',
              qtyMilli: 3000,
              unitPricePaise: 1000,
            ),
          ],
        );
        final v = await env.visits.save(
          draft,
          visitPrefix: 'SV',
          inventoryEnabled: true,
        );
        expect(v.visitNo, 'SV-2627-0001');
        expect(v.machineId, m2);
        expect(v.partsTotalPaise, 53000);
        expect(v.totalPaise, 203000);
        expect(await env.visits.parts(v.id), hasLength(2));
        final m1Visits = await env.visits
            .watchList(VisitFilter(machineId: m1))
            .first;
        expect(m1Visits, isEmpty);
      },
    );

    test('machine must belong to the selected company', () async {
      final a = await env.addCompany('A');
      final b = await env.addCompany('B');
      final mb = await env.addMachine(b, 'MB');
      expect(
        () => env.visits.save(
          VisitDraft(companyId: a, machineId: mb, visitDate: Dates.today()),
          visitPrefix: 'SV',
          inventoryEnabled: true,
        ),
        throwsA(isA<BusinessRuleException>()),
      );
    });

    test('a quick draft needs only company and date', () async {
      final co = await env.addCompany('Shree');
      final v = await env.visits.save(
        VisitDraft(companyId: co, visitDate: Dates.today()),
        visitPrefix: 'SV',
        inventoryEnabled: true,
      );
      expect(v.status, VisitStatus.inProgress.db);
      expect(v.totalPaise, 0);
    });
  });

  group('Inventory', () {
    test('stock is deducted once when a visit is completed', () async {
      final co = await env.addCompany('Shree');
      final relay = await env.addPart('Relay', stockMilli: 10000);
      final draft = VisitDraft(
        companyId: co,
        visitDate: Dates.today(),
        parts: [
          VisitPartDraft(partId: relay, partName: 'Relay', qtyMilli: 3000),
        ],
      );
      // Draft: no deduction yet.
      await env.visits.save(draft, visitPrefix: 'SV', inventoryEnabled: true);
      expect(await env.inventory.stockOf(relay), 10000);

      await env.billing.completeVisit(
        draft,
        settings: env.settings,
        createInvoice: false,
      );
      expect(await env.inventory.stockOf(relay), 7000);

      // Saving / completing again (e.g. double tap, retry) does not deduct again.
      await env.billing.completeVisit(
        draft,
        settings: env.settings,
        createInvoice: false,
      );
      await env.visits.save(draft, visitPrefix: 'SV', inventoryEnabled: true);
      await env.inventory.syncVisitStock(draft.id, inventoryEnabled: true);
      expect(await env.inventory.stockOf(relay), 7000);
    });

    test(
      'editing a completed visit adjusts stock by the difference only',
      () async {
        final co = await env.addCompany('Shree');
        final relay = await env.addPart('Relay', stockMilli: 10000);
        final fuse = await env.addPart('Fuse', stockMilli: 5000);
        final draft = VisitDraft(
          companyId: co,
          visitDate: Dates.today(),
          parts: [
            VisitPartDraft(partId: relay, partName: 'Relay', qtyMilli: 3000),
          ],
        );
        await env.billing.completeVisit(
          draft,
          settings: env.settings,
          createInvoice: false,
        );
        expect(await env.inventory.stockOf(relay), 7000);

        final v = (await env.visits.get(draft.id))!;
        final edit = await _reload(env, v.id);
        edit.parts.single.qtyMilli = 1000;
        edit.parts.add(
          VisitPartDraft(partId: fuse, partName: 'Fuse', qtyMilli: 2000),
        );
        await env.visits.save(edit, visitPrefix: 'SV', inventoryEnabled: true);
        expect(await env.inventory.stockOf(relay), 9000);
        expect(await env.inventory.stockOf(fuse), 3000);

        final edit2 = await _reload(env, v.id);
        edit2.parts.removeWhere((p) => p.partId == fuse);
        await env.visits.save(edit2, visitPrefix: 'SV', inventoryEnabled: true);
        expect(await env.inventory.stockOf(fuse), 5000);

        // The edit of a completed visit is in the audit history.
        final history = await env.visits.watchHistory('visit', v.id).first;
        expect(
          history.where((h) => h.action == 'edit_completed'),
          hasLength(2),
        );
      },
    );

    test('inventory can be disabled; parts are still recorded', () async {
      final co = await env.addCompany('Shree');
      final relay = await env.addPart('Relay', stockMilli: 10000);
      final draft = VisitDraft(
        companyId: co,
        visitDate: Dates.today(),
        parts: [
          VisitPartDraft(partId: relay, partName: 'Relay', qtyMilli: 3000),
          VisitPartDraft(
            partName: 'Local cable',
            qtyMilli: 1500,
            unitPricePaise: 4000,
          ),
        ],
      );
      await env.billing.completeVisit(
        draft,
        settings: env.settings.copyWith(inventoryEnabled: false),
        createInvoice: false,
      );
      expect(await env.inventory.stockOf(relay), 10000);
      expect(await env.visits.parts(draft.id), hasLength(2));
    });

    test('unlisted part can be added to the catalogue from a visit', () async {
      final co = await env.addCompany('Shree');
      final draft = VisitDraft(
        companyId: co,
        visitDate: Dates.today(),
        parts: [
          VisitPartDraft(
            partName: 'Sensor X',
            qtyMilli: 1000,
            unitPricePaise: 90000,
            addToCatalogue: true,
          ),
        ],
      );
      await env.billing.completeVisit(
        draft,
        settings: env.settings,
        createInvoice: false,
      );
      final parts = await env.inventory.activeParts();
      expect(parts.single.name, 'Sensor X');
      expect(await env.inventory.stockOf(parts.single.id), -1000);
    });

    test(
      'purchases and adjustments; retried purchase is not doubled',
      () async {
        final p = await env.addPart('Relay');
        await env.inventory.recordMovement(
          id: 'purchase-1',
          partId: p,
          kind: StockMovementKind.purchase,
          qtyMilli: 5000,
          unitCostPaise: 12000,
        );
        await env.inventory.recordMovement(
          id: 'purchase-1',
          partId: p,
          kind: StockMovementKind.purchase,
          qtyMilli: 5000,
          unitCostPaise: 12000,
        );
        await env.inventory.recordMovement(
          partId: p,
          kind: StockMovementKind.adjustment,
          qtyMilli: -1000,
        );
        expect(await env.inventory.stockOf(p), 4000);
        expect((await env.inventory.getPart(p))!.purchasePaise, 12000);
      },
    );
  });

  group('Invoices and payments', () {
    Future<(String, Invoice)> invoiceFor(int labour, {int taxBp = 0}) async {
      final co = await env.addCompany('Shree');
      final draft = VisitDraft(
        companyId: co,
        visitDate: Dates.today(),
        labourPaise: labour,
        taxRateBp: taxBp,
        parts: [
          VisitPartDraft(
            partName: 'Relay',
            qtyMilli: 2000,
            unitPricePaise: 25000,
          ),
        ],
      );
      final r = await env.billing.completeVisit(
        draft,
        settings: env.settings,
        createInvoice: true,
      );
      return (co, r.invoice!);
    }

    test('invoice from visit has correct items and totals', () async {
      final (_, inv) = await invoiceFor(150000, taxBp: 1800);
      expect(inv.invoiceNo, 'INV-2627-0001');
      expect(inv.subtotalPaise, 200000);
      expect(inv.taxPaise, 36000);
      expect(inv.totalPaise, 236000);
      final items = await env.billing.items(inv.id);
      expect(items.map((i) => i.kind), ['labour', 'part']);
      expect(inv.dueDate, '2026-10-31');
      final visit =
          (await env.visits.watchList(const VisitFilter()).first).single.visit;
      expect(visit.invoiceId, inv.id);
    });

    test(
      'partial payment leaves correct balance; instalments settle it',
      () async {
        final (co, inv) = await invoiceFor(150000);
        expect(inv.totalPaise, 200000);

        await env.billing.recordPayment(
          PaymentDraft(
            companyId: co,
            paidOn: Dates.today(),
            amountPaise: 50000,
            allocations: {inv.id: 50000},
          ),
          receiptPrefix: 'RCPT',
        );
        var cur = (await env.billing.getInvoice(inv.id))!;
        expect(cur.balance.outstanding, 150000);
        expect(cur.status, PaymentStatus.partiallyPaid);

        await env.billing.recordPayment(
          PaymentDraft(
            companyId: co,
            paidOn: Dates.today(),
            amountPaise: 100000,
            method: PaymentMethod.upi,
            allocations: {inv.id: 100000},
          ),
          receiptPrefix: 'RCPT',
        );
        cur = (await env.billing.getInvoice(inv.id))!;
        expect(cur.balance.outstanding, 50000);
        expect(cur.status, PaymentStatus.partiallyPaid);

        final last = await env.billing.recordPayment(
          PaymentDraft(
            companyId: co,
            paidOn: Dates.today(),
            amountPaise: 50000,
            allocations: {inv.id: 50000},
          ),
          receiptPrefix: 'RCPT',
        );
        expect(last.receiptNo, 'RCPT-2627-0003');
        cur = (await env.billing.getInvoice(inv.id))!;
        expect(cur.balance.outstanding, 0);
        expect(cur.status, PaymentStatus.paid);

        // Over-paying an invoice is rejected.
        expect(
          () => env.billing.recordPayment(
            PaymentDraft(
              companyId: co,
              paidOn: Dates.today(),
              amountPaise: 100,
              allocations: {inv.id: 100},
            ),
            receiptPrefix: 'RCPT',
          ),
          throwsA(isA<BusinessRuleException>()),
        );
      },
    );

    test('overdue derived from due date', () async {
      final (_, inv) = await invoiceFor(100000);
      fixToday('2026-11-01');
      final cur = (await env.billing.getInvoice(inv.id))!;
      expect(cur.status, PaymentStatus.overdue);
      final overdue = await env.billing
          .watchInvoices(const InvoiceFilter(statuses: {PaymentStatus.overdue}))
          .first;
      expect(overdue, hasLength(1));
    });

    test(
      'on-site payment at completion is applied to the new invoice',
      () async {
        final co = await env.addCompany('Shree');
        final draft = VisitDraft(
          companyId: co,
          visitDate: Dates.today(),
          labourPaise: 100000,
          onsitePaymentPaise: 40000,
          onsitePaymentMethod: PaymentMethod.upi,
        );
        final r = await env.billing.completeVisit(
          draft,
          settings: env.settings,
          createInvoice: true,
        );
        expect(r.payment!.amountPaise, 40000);
        final cur = (await env.billing.getInvoice(r.invoice!.id))!;
        expect(cur.balance.outstanding, 60000);

        // Completing again does not create a second invoice or payment.
        await env.billing.completeVisit(
          draft,
          settings: env.settings,
          createInvoice: true,
        );
        expect(
          await env.billing.watchInvoices(const InvoiceFilter()).first,
          hasLength(1),
        );
        expect(
          await env.billing.watchPayments(const PaymentFilter()).first,
          hasLength(1),
        );
      },
    );

    test(
      'advance payment is kept as credit and can be applied later',
      () async {
        final co = await env.addCompany('Shree');
        final adv = await env.billing.recordPayment(
          PaymentDraft(
            companyId: co,
            paidOn: Dates.today(),
            amountPaise: 30000,
          ),
          receiptPrefix: 'RCPT',
        );
        var summary = await env.companies.watchSummary(co).first;
        expect(summary.credit, 30000);
        expect(summary.outstanding, 0);

        final draft = VisitDraft(
          companyId: co,
          visitDate: Dates.today(),
          labourPaise: 100000,
        );
        final r = await env.billing.completeVisit(
          draft,
          settings: env.settings,
          createInvoice: true,
        );
        await env.billing.applyCredit(
          paymentId: adv.id,
          invoiceId: r.invoice!.id,
          amount: 30000,
        );
        summary = await env.companies.watchSummary(co).first;
        expect(summary.credit, 0);
        expect(summary.outstanding, 70000);
        expect(summary.billed, 100000);
        expect(summary.received, 30000);
      },
    );

    test(
      'voiding a payment restores the balance; cancel needs no payments',
      () async {
        final (co, inv) = await invoiceFor(150000);
        final p = await env.billing.recordPayment(
          PaymentDraft(
            companyId: co,
            paidOn: Dates.today(),
            amountPaise: 50000,
            allocations: {inv.id: 50000},
          ),
          receiptPrefix: 'RCPT',
        );
        expect(
          () => env.billing.cancelInvoice(inv.id, 'mistake'),
          throwsA(isA<BusinessRuleException>()),
        );
        await env.billing.voidPayment(p.id, 'Cheque bounced');
        expect(
          (await env.billing.getInvoice(inv.id))!.balance.outstanding,
          200000,
        );
        await env.billing.cancelInvoice(inv.id, 'mistake');
        expect(
          (await env.billing.getInvoice(inv.id))!.status,
          PaymentStatus.cancelled,
        );
        // Its visit can be invoiced again.
        expect(await env.visits.uninvoicedVisits(co), hasLength(1));
      },
    );

    test('invoice total cannot be reduced below the amount paid', () async {
      final (co, inv) = await invoiceFor(150000);
      await env.billing.recordPayment(
        PaymentDraft(
          companyId: co,
          paidOn: Dates.today(),
          amountPaise: 150000,
          allocations: {inv.id: 150000},
        ),
        receiptPrefix: 'RCPT',
      );
      final items = await env.billing.items(inv.id);
      final draft = InvoiceDraft(
        id: inv.id,
        companyId: co,
        invoiceDate: inv.invoiceDate,
        dueDate: inv.dueDate,
        lines: [
          InvoiceLineDraft(
            id: items.first.id,
            description: 'Labour',
            unitPricePaise: 100000,
          ),
        ],
      );
      expect(
        () => env.billing.saveInvoice(draft, invoicePrefix: 'INV'),
        throwsA(isA<BusinessRuleException>()),
      );
    });
  });
}

Future<VisitDraft> _reload(TestEnv env, String id) async {
  final v = (await env.visits.get(id))!;
  return VisitRepository.toDraft(v, await env.visits.parts(id));
}
