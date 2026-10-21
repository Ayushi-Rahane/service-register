import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../data/local/app_database.dart';
import '../../domain/app_settings.dart';
import '../../domain/billing.dart';
import '../../domain/enums.dart';
import '../../domain/report_table.dart';
import 'pdf_kit.dart';

class VisitReportData {
  const VisitReportData({
    required this.visit,
    required this.company,
    required this.machine,
    required this.parts,
    this.photos = const [],
    this.signature,
    this.includeCharges = true,
  });
  final ServiceVisit visit;
  final Company company;
  final Machine? machine;
  final List<VisitPart> parts;

  /// (caption, image bytes)
  final List<(String, Uint8List)> photos;
  final Uint8List? signature;
  final bool includeCharges;
}

Future<Uint8List> buildVisitReportPdf(
  VisitReportData d,
  BusinessSettings business,
  PdfFonts fonts,
) {
  final kit = PdfKit(fonts, business);
  final v = d.visit;
  final m = d.machine;
  final doc = kit.document('Service report ${v.visitNo}');
  final times = [
    if (v.arrivalTime != null) 'Arrived ${Dates.displayTime(v.arrivalTime)}',
    if (v.departureTime != null) 'Left ${Dates.displayTime(v.departureTime)}',
  ].join('  •  ');

  pw.Widget section(String title, List<(String, String?)> fields) {
    final present = fields
        .where((f) => f.$2 != null && f.$2!.trim().isNotEmpty)
        .toList();
    if (present.isEmpty) return pw.SizedBox();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: kit.box(
        title: title,
        children: [for (final f in present) kit.labelled(f.$1, f.$2)],
      ),
    );
  }

  final charges = ChargeBreakdown(
    labour: v.labourPaise,
    parts: v.partsTotalPaise,
    travel: v.travelPaise,
    other: 0,
    discount: v.discountPaise,
    taxRateBp: v.taxRateBp,
  );

  doc.addPage(
    pw.MultiPage(
      pageTheme: kit.pageTheme(),
      footer: (ctx) => kit.footer(ctx),
      build: (ctx) => [
        kit.header(
          title: 'SERVICE REPORT',
          meta: [
            ('Visit no.', v.visitNo),
            ('Date', Dates.display(v.visitDate)),
            ('Status', VisitStatus.fromDb(v.status).label),
          ],
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: kit.box(
                title: 'Customer',
                children: [
                  pw.Text(d.company.name, style: kit.h2),
                  if (d.company.contactPerson != null)
                    pw.Text(d.company.contactPerson!),
                  if (d.company.address != null) pw.Text(d.company.address!),
                  if (d.company.phone != null)
                    pw.Text('Ph: ${d.company.phone}'),
                ],
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: kit.box(
                title: 'Machine',
                children: m == null
                    ? [pw.Text('Not specified')]
                    : [
                        pw.Text(m.name, style: kit.h2),
                        pw.Text(MachineCategory.fromDb(m.category).label),
                        if (m.manufacturer != null || m.model != null)
                          pw.Text(
                            [
                              m.manufacturer,
                              m.model,
                            ].whereType<String>().join(' '),
                          ),
                        if (m.serialNumber != null)
                          pw.Text('S/N: ${m.serialNumber}'),
                        if (m.location != null)
                          pw.Text('Location: ${m.location}'),
                      ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        section('Visit', [
          ('Service type', ServiceType.fromDb(v.serviceType).label),
          ('Technician', v.technicianName),
          ('Time', times),
        ]),
        section('Problem & diagnosis', [
          ('Reported problem', v.reportedProblem),
          ('Symptoms observed', v.symptoms),
          ('Diagnosis', v.diagnosis),
          ('Root cause', v.rootCause),
        ]),
        section('Work performed', [
          ('Work carried out', v.workDone),
          ('Actions taken', v.actionsTaken),
          ('Tests after repair', v.testsPerformed),
          (
            'Machine status after visit',
            v.machineStatusAfter == null
                ? null
                : MachineStatus.fromDb(v.machineStatusAfter).label,
          ),
          ('Recommendations', v.recommendations),
          (
            'Next recommended service',
            v.nextServiceDate == null ? null : Dates.display(v.nextServiceDate),
          ),
        ]),
        if (d.parts.isNotEmpty) ...[
          pw.Text('Spare parts used', style: kit.h2),
          pw.SizedBox(height: 4),
          kit.table(
            headers: d.includeCharges
                ? ['Part', 'Part no.', 'Qty', 'Rate', 'Amount']
                : ['Part', 'Part no.', 'Qty'],
            rows: [
              for (final p in d.parts)
                [
                  p.partName,
                  p.partNumber ?? '',
                  Qty.format(p.qtyMilli),
                  if (d.includeCharges) Money.format(p.unitPricePaise),
                  if (d.includeCharges)
                    Money.format(
                      Billing.lineTotal(p.qtyMilli, p.unitPricePaise),
                    ),
                ],
            ],
            numeric: {2, 3, 4},
          ),
          pw.SizedBox(height: 10),
        ],
        if (d.includeCharges && charges.subtotal > 0)
          pw.Row(
            children: [
              pw.Spacer(flex: 5),
              pw.Expanded(
                flex: 4,
                child: pw.Column(
                  children: [
                    if (charges.labour > 0)
                      kit.totalLine('Labour', Money.format(charges.labour)),
                    if (charges.parts > 0)
                      kit.totalLine('Spare parts', Money.format(charges.parts)),
                    if (charges.travel > 0)
                      kit.totalLine(
                        'Travel / other',
                        Money.format(charges.travel),
                      ),
                    if (charges.appliedDiscount > 0)
                      kit.totalLine(
                        'Discount',
                        '- ${Money.format(charges.appliedDiscount)}',
                      ),
                    if (charges.tax > 0)
                      kit.totalLine(
                        'Tax @ ${Billing.rateLabel(v.taxRateBp)}%',
                        Money.format(charges.tax),
                      ),
                    pw.Divider(color: PdfKit.line),
                    kit.totalLine(
                      'Total',
                      Money.format(charges.total),
                      strong: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (d.photos.isNotEmpty) ...[
          pw.SizedBox(height: 10),
          pw.Text('Photos', style: kit.h2),
          pw.SizedBox(height: 4),
          pw.Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in d.photos.take(6))
                pw.Column(
                  children: [
                    pw.Container(
                      width: 160,
                      height: 120,
                      child: pw.Image(
                        pw.MemoryImage(p.$2),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                    pw.Text(p.$1, style: kit.label),
                  ],
                ),
            ],
          ),
        ],
        if (v.customerFeedback != null) ...[
          pw.SizedBox(height: 10),
          kit.labelled('Customer feedback', v.customerFeedback),
        ],
        pw.SizedBox(height: 16),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (d.signature != null)
                    pw.Container(
                      height: 50,
                      width: 150,
                      child: pw.Image(pw.MemoryImage(d.signature!)),
                    ),
                  pw.Container(width: 160, height: 0.5, color: PdfKit.muted),
                  pw.Text(
                    'Customer signature${v.signedBy == null ? '' : ' – ${v.signedBy}'}',
                    style: kit.label,
                  ),
                ],
              ),
            ),
            pw.Column(
              children: [
                pw.Container(width: 160, height: 0.5, color: PdfKit.muted),
                pw.Text(
                  'Technician${v.technicianName == null ? '' : ' – ${v.technicianName}'}',
                  style: kit.label,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
  return doc.save();
}

/// Generic report document for any [ReportTable].
Future<Uint8List> buildReportPdf(
  ReportTable t,
  BusinessSettings business,
  PdfFonts fonts,
) {
  final kit = PdfKit(fonts, business);
  final doc = kit.document(t.title);
  final numeric = {
    for (var i = 0; i < t.columns.length; i++)
      if (t.columns[i].numeric) i,
  };
  doc.addPage(
    pw.MultiPage(
      pageTheme: kit.pageTheme(landscape: t.columns.length > 6),
      footer: (ctx) => kit.footer(ctx),
      build: (ctx) => [
        kit.header(
          title: t.title.toUpperCase(),
          meta: [('Period', t.subtitle)],
        ),
        for (final s in t.summary) kit.totalLine(s.$1, s.$2),
        if (t.summary.isNotEmpty) pw.SizedBox(height: 8),
        if (t.rows.isEmpty)
          pw.Text('No records for the selected filters.')
        else
          kit.table(
            headers: [for (final c in t.columns) c.label],
            rows: [
              for (final r in t.rows)
                [for (var i = 0; i < r.length; i++) t.display(i, r[i])],
            ],
            numeric: numeric,
            footer: t.hasTotals
                ? [
                    for (var i = 0; i < t.columns.length; i++)
                      t.display(i, t.totalsRow[i]),
                  ]
                : null,
          ),
      ],
    ),
  );
  return doc.save();
}
