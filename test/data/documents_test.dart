import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/core/utils/dates.dart';
import 'package:service_register/domain/drafts.dart';
import 'package:service_register/services/pdf/billing_pdfs.dart';
import 'package:service_register/services/pdf/pdf_kit.dart';
import 'package:service_register/services/pdf/report_pdfs.dart';

import '../support/test_db.dart';

void main() {
  final fonts = PdfFonts.fromBytes(
    ByteData.sublistView(
      File('assets/fonts/NotoSans-Regular.ttf').readAsBytesSync(),
    ),
    ByteData.sublistView(
      File('assets/fonts/NotoSans-Bold.ttf').readAsBytesSync(),
    ),
  );

  test('invoice, receipt and service report PDFs are generated', () async {
    fixToday('2026-10-16');
    final env = TestEnv();
    env.settings = env.settings.copyWith(
      businessName: 'Rahane Machine Services',
      gstin: '27ABCDE1234F1Z5',
      upiId: 'x@upi',
    );
    final co = await env.addCompany('Shree Electronics');
    final m = await env.addMachine(co, 'PCB Line 1');
    final d = VisitDraft(
      companyId: co,
      machineId: m,
      visitDate: Dates.today(),
      reportedProblem: 'Motor overheating',
      workDone: 'Replaced relay and cleaned contacts',
      labourPaise: 150000,
      taxRateBp: 1800,
      onsitePaymentPaise: 100000,
      parts: [
        VisitPartDraft(
          partName: 'Relay 24V',
          qtyMilli: 2000,
          unitPricePaise: 25000,
        ),
      ],
    );
    final r = await env.billing.completeVisit(
      d,
      settings: env.settings,
      createInvoice: true,
    );
    final inv = (await env.billing.getInvoice(r.invoice!.id))!;
    final allocs = await env.billing
        .watchInvoiceAllocations(inv.invoice.id)
        .first;

    final invoicePdf = await buildInvoicePdf(
      InvoicePdfData(
        invoice: inv.invoice,
        items: await env.billing.items(inv.invoice.id),
        visits: [r.visit],
        balance: inv.balance,
        payments: [
          for (final a in allocs)
            (a.payment.receiptNo, a.payment.paidOn, a.allocation.amountPaise),
        ],
      ),
      env.settings,
      fonts,
    );
    final receiptPdf = await buildReceiptPdf(
      ReceiptPdfData(
        payment: r.payment!,
        companyName: 'Shree Electronics',
        companyAddress: null,
        allocations: [(inv.invoice.invoiceNo, 100000)],
      ),
      env.settings,
      fonts,
    );
    final company = (await env.companies.get(co))!;
    final reportPdf = await buildVisitReportPdf(
      VisitReportData(
        visit: r.visit,
        company: company,
        machine: await env.machines.get(m),
        parts: await env.visits.parts(r.visit.id),
      ),
      env.settings,
      fonts,
    );
    for (final pdf in [invoicePdf, receiptPdf, reportPdf]) {
      expect(utf8.decode(pdf.sublist(0, 5)), '%PDF-');
      expect(pdf.length, greaterThan(3000));
    }
    await env.close();
  });
}
