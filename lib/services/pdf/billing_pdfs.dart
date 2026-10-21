import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../data/local/app_database.dart';
import '../../domain/amount_words.dart';
import '../../domain/app_settings.dart';
import '../../domain/billing.dart';
import '../../domain/enums.dart';
import 'pdf_kit.dart';

class InvoicePdfData {
  const InvoicePdfData({
    required this.invoice,
    required this.items,
    required this.visits,
    required this.balance,
    required this.payments,
  });
  final Invoice invoice;
  final List<InvoiceItem> items;
  final List<ServiceVisit> visits;
  final InvoiceBalance balance;

  /// (receipt no, date, amount applied)
  final List<(String, String, int)> payments;
}

Future<Uint8List> buildInvoicePdf(
  InvoicePdfData d,
  BusinessSettings business,
  PdfFonts fonts,
) {
  final kit = PdfKit(fonts, business);
  final inv = d.invoice;
  final doc = kit.document('Invoice ${inv.invoiceNo}');
  final discountApplied = inv.discountPaise.clamp(0, inv.subtotalPaise);
  final paymentDetails = [
    if (business.upiId.isNotEmpty) 'UPI: ${business.upiId}',
    if (business.bankDetails.isNotEmpty) business.bankDetails,
  ];

  doc.addPage(
    pw.MultiPage(
      pageTheme: kit.pageTheme(),
      header: (ctx) => ctx.pageNumber == 1
          ? pw.SizedBox()
          : pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                '${business.displayBusinessName} • Invoice ${inv.invoiceNo}',
                style: kit.label,
              ),
            ),
      footer: (ctx) =>
          kit.footer(ctx, note: 'This is a computer-generated invoice.'),
      build: (ctx) => [
        kit.header(
          title: inv.cancelledAt != null ? 'INVOICE (CANCELLED)' : 'INVOICE',
          meta: [
            ('Invoice no.', inv.invoiceNo),
            ('Date', Dates.display(inv.invoiceDate)),
            if (inv.dueDate != null) ('Due date', Dates.display(inv.dueDate)),
          ],
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: kit.box(
                title: 'Bill to',
                children: [
                  pw.Text(inv.billToName, style: kit.h2),
                  if (inv.billToAddress != null) pw.Text(inv.billToAddress!),
                  if (inv.billToPhone != null)
                    pw.Text('Ph: ${inv.billToPhone}'),
                  if (inv.billToGstin != null)
                    pw.Text('GSTIN: ${inv.billToGstin}', style: kit.bold),
                ],
              ),
            ),
            if (d.visits.isNotEmpty) ...[
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: kit.box(
                  title: 'Service visits',
                  children: [
                    for (final v in d.visits)
                      pw.Text('${v.visitNo} – ${Dates.display(v.visitDate)}'),
                  ],
                ),
              ),
            ],
          ],
        ),
        pw.SizedBox(height: 12),
        kit.table(
          headers: ['#', 'Description', 'Qty', 'Rate', 'Amount'],
          rows: [
            for (var i = 0; i < d.items.length; i++)
              [
                '${i + 1}',
                d.items[i].description,
                Qty.format(d.items[i].qtyMilli),
                Money.format(d.items[i].unitPricePaise),
                Money.format(d.items[i].amountPaise),
              ],
          ],
          numeric: {2, 3, 4},
          widths: {
            0: const pw.FixedColumnWidth(22),
            1: const pw.FlexColumnWidth(5),
            2: const pw.FixedColumnWidth(40),
            3: const pw.FixedColumnWidth(72),
            4: const pw.FixedColumnWidth(80),
          },
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 5,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Amount in words', style: kit.label),
                  pw.Text(AmountWords.rupees(inv.totalPaise), style: kit.bold),
                  pw.SizedBox(height: 8),
                  if (paymentDetails.isNotEmpty) ...[
                    pw.Text('Payment details', style: kit.label),
                    for (final l in paymentDetails) pw.Text(l),
                    pw.SizedBox(height: 8),
                  ],
                  if (inv.notes != null) ...[
                    pw.Text('Notes', style: kit.label),
                    pw.Text(inv.notes!),
                  ],
                  if (inv.cancelledAt != null)
                    pw.Text(
                      'Cancelled${inv.cancelReason == null ? '' : ': ${inv.cancelReason}'}',
                      style: kit.bold.copyWith(color: PdfColors.red800),
                    ),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              flex: 4,
              child: pw.Column(
                children: [
                  kit.totalLine('Subtotal', Money.format(inv.subtotalPaise)),
                  if (discountApplied > 0)
                    kit.totalLine(
                      'Discount',
                      '- ${Money.format(discountApplied)}',
                    ),
                  if (inv.taxRateBp > 0) ...[
                    kit.totalLine(
                      'Taxable value',
                      Money.format(inv.subtotalPaise - discountApplied),
                    ),
                    kit.totalLine(
                      '${inv.taxLabel ?? 'Tax'} @ ${Billing.rateLabel(inv.taxRateBp)}%',
                      Money.format(inv.taxPaise),
                    ),
                  ],
                  pw.Divider(color: PdfKit.line),
                  kit.totalLine(
                    'Total',
                    Money.format(inv.totalPaise),
                    strong: true,
                  ),
                  if (d.balance.paid > 0)
                    kit.totalLine('Paid', Money.format(d.balance.paid)),
                  kit.totalLine(
                    'Balance due',
                    Money.format(d.balance.outstanding),
                    strong: true,
                    color: d.balance.outstanding > 0 ? PdfKit.primary : null,
                  ),
                  pw.SizedBox(height: 4),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Status: ${d.balance.status.label}',
                      style: kit.label,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (d.payments.isNotEmpty) ...[
          pw.SizedBox(height: 14),
          pw.Text('Payments received', style: kit.h2),
          pw.SizedBox(height: 4),
          kit.table(
            headers: ['Receipt', 'Date', 'Amount'],
            rows: [
              for (final p in d.payments)
                [p.$1, Dates.display(p.$2), Money.format(p.$3)],
            ],
            numeric: {2},
          ),
        ],
        pw.SizedBox(height: 30),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Column(
            children: [
              pw.Text('For ${business.displayBusinessName}'),
              pw.SizedBox(height: 26),
              pw.Text('Authorised signatory', style: kit.label),
            ],
          ),
        ),
        if (business.invoiceTerms.isNotEmpty &&
            inv.notes != business.invoiceTerms) ...[
          pw.SizedBox(height: 10),
          pw.Text(business.invoiceTerms, style: kit.label),
        ],
      ],
    ),
  );
  return doc.save();
}

class ReceiptPdfData {
  const ReceiptPdfData({
    required this.payment,
    required this.companyName,
    required this.companyAddress,
    required this.allocations,
  });
  final Payment payment;
  final String companyName;
  final String? companyAddress;

  /// (invoice no, amount applied)
  final List<(String, int)> allocations;
}

Future<Uint8List> buildReceiptPdf(
  ReceiptPdfData d,
  BusinessSettings business,
  PdfFonts fonts,
) {
  final kit = PdfKit(fonts, business);
  final p = d.payment;
  final applied = d.allocations.fold(0, (s, a) => s + a.$2);
  final doc = kit.document('Receipt ${p.receiptNo}');
  doc.addPage(
    pw.Page(
      pageTheme: kit.pageTheme(),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          kit.header(
            title: p.voidedAt != null ? 'RECEIPT (VOID)' : 'PAYMENT RECEIPT',
            meta: [
              ('Receipt no.', p.receiptNo),
              ('Date', Dates.display(p.paidOn)),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Text('Received with thanks from', style: kit.label),
          pw.Text(d.companyName, style: kit.h2),
          if (d.companyAddress != null) pw.Text(d.companyAddress!),
          pw.SizedBox(height: 14),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            color: PdfKit.shade,
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Amount received', style: kit.label),
                      pw.Text(
                        Money.format(p.amountPaise),
                        style: pw.TextStyle(
                          font: fonts.bold,
                          fontSize: 20,
                          color: PdfKit.primary,
                        ),
                      ),
                      pw.Text(AmountWords.rupees(p.amountPaise)),
                    ],
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Payment method', style: kit.label),
                    pw.Text(
                      PaymentMethod.fromDb(p.method).label,
                      style: kit.bold,
                    ),
                    if (p.reference != null) ...[
                      pw.SizedBox(height: 4),
                      pw.Text('Reference', style: kit.label),
                      pw.Text(p.reference!),
                    ],
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          if (d.allocations.isNotEmpty) ...[
            pw.Text('Applied to', style: kit.h2),
            pw.SizedBox(height: 4),
            kit.table(
              headers: ['Invoice', 'Amount'],
              rows: [
                for (final a in d.allocations) [a.$1, Money.format(a.$2)],
              ],
              numeric: {1},
            ),
          ],
          if (p.amountPaise - applied > 0 && p.voidedAt == null) ...[
            pw.SizedBox(height: 6),
            pw.Text(
              'Advance / credit kept on account: ${Money.format(p.amountPaise - applied)}',
            ),
          ],
          if (p.notes != null) ...[
            pw.SizedBox(height: 8),
            kit.labelled('Notes', p.notes),
          ],
          pw.Spacer(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              children: [
                pw.Text('For ${business.displayBusinessName}'),
                pw.SizedBox(height: 26),
                pw.Text('Authorised signatory', style: kit.label),
              ],
            ),
          ),
          kit.footer(ctx, note: 'This is a computer-generated receipt.'),
        ],
      ),
    ),
  );
  return doc.save();
}
