import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/core/utils/csv.dart';
import 'package:service_register/core/utils/dates.dart';
import 'package:service_register/data/repositories/billing_repository.dart';
import 'package:service_register/data/repositories/report_repository.dart';
import 'package:service_register/domain/amount_words.dart';
import 'package:service_register/domain/drafts.dart';
import 'package:service_register/domain/enums.dart';
import 'package:service_register/services/backup_service.dart';
import 'package:service_register/services/pdf/pdf_kit.dart';
import 'package:service_register/services/pdf/report_pdfs.dart';

import '../support/test_db.dart';

void main() {
  late TestEnv env;
  late ReportRepository reports;
  late String shree, alpha;

  setUp(() async {
    fixToday('2026-10-16');
    env = TestEnv();
    reports = ReportRepository(env.db);
    shree = await env.addCompany('Shree Electronics');
    alpha = await env.addCompany('Alpha Circuits');
    final m = await env.addMachine(shree, 'PCB Line 1');
    final relay = await env.addPart(
      'Relay',
      stockMilli: 10000,
      sellingPaise: 25000,
    );

    // Shree: two completed visits (Oct), one paid partly.
    final v1 = VisitDraft(
      companyId: shree,
      machineId: m,
      visitDate: '2026-10-05',
      serviceType: ServiceType.breakdownRepair,
      reportedProblem: 'Not starting',
      labourPaise: 100000,
      parts: [
        VisitPartDraft(
          partId: relay,
          partName: 'Relay',
          qtyMilli: 2000,
          unitPricePaise: 25000,
        ),
      ],
      onsitePaymentPaise: 50000,
    );
    await env.billing.completeVisit(
      v1,
      settings: env.settings,
      createInvoice: true,
    );
    final v2 = VisitDraft(
      companyId: shree,
      machineId: m,
      visitDate: '2026-10-12',
      labourPaise: 80000,
    );
    await env.billing.completeVisit(
      v2,
      settings: env.settings,
      createInvoice: true,
    );
    // Alpha: one visit in September, fully paid in October.
    fixToday('2026-09-20');
    final v3 = VisitDraft(
      companyId: alpha,
      visitDate: '2026-09-20',
      labourPaise: 60000,
    );
    final r3 = await env.billing.completeVisit(
      v3,
      settings: env.settings,
      createInvoice: true,
    );
    fixToday('2026-10-16');
    await env.billing.recordPayment(
      PaymentDraft(
        companyId: alpha,
        paidOn: '2026-10-02',
        amountPaise: 60000,
        allocations: {r3.invoice!.id: 60000},
      ),
      receiptPrefix: 'RCPT',
    );
  });
  tearDown(() => env.close());

  test('monthly billing vs collections are reported separately', () async {
    final t = await reports.build(
      const ReportRequest(
        type: ReportType.monthlyBilling,
        from: '2026-04-01',
        to: '2027-03-31',
      ),
    );
    expect(t.rows.map((r) => r[0]), ['September 2026', 'October 2026']);
    // September: billed 600, collected 0.
    expect(t.rows[0].sublist(1), [1, 60000, 0, 0]);
    // October: billed 1500 + 800 = 2300; collected 500 (on site) + 600 = 1100.
    expect(t.rows[1].sublist(1), [2, 230000, 2, 110000]);
    expect(t.total(2), 290000);
    expect(t.total(4), 110000);
  });

  test('outstanding invoices with correct balances and totals', () async {
    final t = await reports.build(
      ReportRequest(type: ReportType.outstanding, from: '', to: Dates.today()),
    );
    expect(t.rows, hasLength(2)); // Alpha fully paid -> excluded
    expect(t.rows.map((r) => r[6]), [100000, 80000]);
    expect(t.total(6), 180000);
    expect(t.total(4), 230000);
    expect(t.total(5), 50000);
  });

  test('company history respects company filter', () async {
    final t = await reports.build(
      ReportRequest(
        type: ReportType.companyHistory,
        from: '2026-01-01',
        to: '2026-12-31',
        companyId: shree,
      ),
    );
    expect(t.rows, hasLength(2));
    expect(t.rows.every((r) => r[2] == 'Shree Electronics'), isTrue);
    expect(t.total(7), 230000);
    final all = await reports.build(
      const ReportRequest(
        type: ReportType.companyHistory,
        from: '2026-01-01',
        to: '2026-12-31',
      ),
    );
    expect(all.rows, hasLength(3));
  });

  test('business summary filters by service type', () async {
    final t = await reports.build(
      const ReportRequest(
        type: ReportType.businessSummary,
        from: '2026-10-01',
        to: '2026-10-31',
        serviceType: ServiceType.breakdownRepair,
      ),
    );
    expect(t.rows.single[0], 'Breakdown repair');
    expect(t.rows.single[1], 1);
  });

  test('parts used and stock summary', () async {
    final used = await reports.build(
      const ReportRequest(
        type: ReportType.partsUsed,
        from: '2026-10-01',
        to: '2026-10-31',
      ),
    );
    expect(used.rows.single[0], 'Relay');
    expect(used.rows.single[2], 2000);
    expect(used.rows.single[4], 50000);
    final stock = await reports.build(
      const ReportRequest(type: ReportType.stockSummary, from: '', to: ''),
    );
    expect(stock.rows.single[4], 8000);
  });

  test('CSV export: BOM, header, escaped cells, totals row', () async {
    final t = await reports.build(
      ReportRequest(type: ReportType.outstanding, from: '', to: Dates.today()),
    );
    final csv = Csv.fromReport(t);
    expect(csv.startsWith('﻿'), isTrue);
    final lines = csv.substring(1).split('\r\n')..removeLast();
    expect(
      lines.first,
      startsWith('Invoice no.,Date,Due date,Company,Total,Paid,Balance'),
    );
    expect(lines, hasLength(1 + 2 + 1));
    expect(lines.last, startsWith('Total,,,,2300.00,500.00,1800.00'));
    expect(Csv.escape('a,b'), '"a,b"');
    expect(Csv.escape('say "hi"'), '"say ""hi"""');
    expect(Csv.escape('=HYPERLINK()'), "'=HYPERLINK()");
    expect(Csv.escape('-150.00'), '-150.00');
  });

  test('report PDF renders (fonts with ₹)', () async {
    final fonts = PdfFonts.fromBytes(
      ByteData.sublistView(
        File('assets/fonts/NotoSans-Regular.ttf').readAsBytesSync(),
      ),
      ByteData.sublistView(
        File('assets/fonts/NotoSans-Bold.ttf').readAsBytesSync(),
      ),
    );
    final t = await reports.build(
      const ReportRequest(
        type: ReportType.monthlyBilling,
        from: '2026-04-01',
        to: '2027-03-31',
      ),
    );
    final pdf = await buildReportPdf(t, env.settings, fonts);
    expect(utf8.decode(pdf.sublist(0, 5)), '%PDF-');
    expect(pdf.length, greaterThan(2000));
  });

  test('backup round-trip restores every record and keeps balances', () async {
    final dir = Directory.systemTemp.createTempSync('backup');
    final backup = BackupService(env.db, () async => dir);
    final doc = await backup.exportBackup();
    final zip = ZipDecoder().decodeBytes(doc.bytes);
    expect(zip.findFile('data.json'), isNotNull);

    final other = TestEnv();
    final restored = await BackupService(
      other.db,
      () async => dir,
    ).restore(doc.bytes);
    expect(restored.counts['invoices'], 3);
    final invoices = await other.billing
        .watchInvoices(const InvoiceFilter())
        .first;
    expect(invoices.fold<int>(0, (s, i) => s + i.balance.outstanding), 180000);
    expect(
      await other.inventory.stockOf(
        (await other.inventory.activeParts()).single.id,
      ),
      8000,
    );
    await other.close();

    expect(
      () => backup.inspect(Uint8List.fromList([1, 2, 3])),
      throwsFormatException,
    );
    dir.deleteSync(recursive: true);
  });

  test('CSV zip export lists amounts in rupees', () async {
    final dir = Directory.systemTemp.createTempSync('csv');
    final doc = await BackupService(env.db, () async => dir).exportCsvZip();
    final zip = ZipDecoder().decodeBytes(doc.bytes);
    final invoices = utf8.decode(
      zip.findFile('Invoices.csv')!.content as List<int>,
    );
    expect(invoices, contains('total_rupees'));
    expect(invoices, contains('1500.00'));
    dir.deleteSync(recursive: true);
  });

  test('amount in words uses lakh / crore', () {
    expect(
      AmountWords.rupees(23605050),
      'Rupees Two Lakh Thirty-Six Thousand Fifty and Fifty Paise Only',
    );
    expect(AmountWords.rupees(150000), 'Rupees One Thousand Five Hundred Only');
    expect(
      AmountWords.number(12345678),
      'One Crore Twenty-Three Lakh Forty-Five Thousand Six Hundred Seventy-Eight',
    );
  });
}
