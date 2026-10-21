import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/dates.dart';
import '../../domain/app_settings.dart';

/// Fonts embedded in every document (Noto Sans covers ₹).
class PdfFonts {
  const PdfFonts(this.regular, this.bold);
  final pw.Font regular;
  final pw.Font bold;

  static PdfFonts? _cache;

  static Future<PdfFonts> load() async => _cache ??= fromBytes(
    (await rootBundle.load('assets/fonts/NotoSans-Regular.ttf')),
    (await rootBundle.load('assets/fonts/NotoSans-Bold.ttf')),
  );

  static PdfFonts fromBytes(ByteData regular, ByteData bold) =>
      PdfFonts(pw.Font.ttf(regular), pw.Font.ttf(bold));
}

/// Shared look for generated documents.
class PdfKit {
  PdfKit(this.fonts, this.business);

  final PdfFonts fonts;
  final BusinessSettings business;

  static const primary = PdfColor.fromInt(0xFF1F5FAD);
  static const muted = PdfColor.fromInt(0xFF5B6573);
  static const line = PdfColor.fromInt(0xFFD5DAE1);
  static const shade = PdfColor.fromInt(0xFFF1F4F8);

  pw.ThemeData get theme =>
      pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold).copyWith(
        defaultTextStyle: pw.TextStyle(font: fonts.regular, fontSize: 9.5),
      );

  pw.Document document(String title) => pw.Document(
    title: title,
    author: business.displayBusinessName,
    creator: 'Service Register',
    theme: theme,
  );

  pw.PageTheme pageTheme({bool landscape = false}) => pw.PageTheme(
    pageFormat: landscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(32, 32, 32, 28),
    theme: theme,
  );

  pw.TextStyle get h1 =>
      pw.TextStyle(font: fonts.bold, fontSize: 18, color: primary);
  pw.TextStyle get h2 => pw.TextStyle(font: fonts.bold, fontSize: 11);
  pw.TextStyle get label => const pw.TextStyle(fontSize: 8.5, color: muted);
  pw.TextStyle get bold => pw.TextStyle(font: fonts.bold);

  /// Business details (left) and document title + meta (right).
  pw.Widget header({
    required String title,
    required List<(String, String)> meta,
  }) {
    final b = business;
    final contact = [
      if (b.phone.isNotEmpty) 'Ph: ${b.phone}',
      if (b.email.isNotEmpty) b.email,
    ].join('   ');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    b.displayBusinessName,
                    style: pw.TextStyle(font: fonts.bold, fontSize: 15),
                  ),
                  if (b.ownerName.isNotEmpty) pw.Text(b.ownerName),
                  if (b.address.isNotEmpty) pw.Text(b.address),
                  if (contact.isNotEmpty) pw.Text(contact),
                  if (b.gstin.isNotEmpty)
                    pw.Text('GSTIN: ${b.gstin}', style: bold),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(title, style: h1),
                pw.SizedBox(height: 4),
                for (final m in meta)
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text('${m.$1}: ', style: label),
                      pw.Text(m.$2, style: bold),
                    ],
                  ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: primary, thickness: 1.5),
        pw.SizedBox(height: 6),
      ],
    );
  }

  pw.Widget footer(pw.Context ctx, {String? note}) => pw.Column(
    children: [
      pw.Divider(color: line),
      pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              note ?? 'Generated on ${Dates.timestamp(DateTime.now().toUtc())}',
              style: label,
            ),
          ),
          pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}', style: label),
        ],
      ),
    ],
  );

  pw.Widget labelled(String l, String? v) => (v == null || v.trim().isEmpty)
      ? pw.SizedBox()
      : pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 5),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(l, style: label),
              pw.Text(v.trim()),
            ],
          ),
        );

  pw.Widget box({required String title, required List<pw.Widget> children}) =>
      pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: line),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(font: fonts.bold, fontSize: 8, color: muted),
            ),
            pw.SizedBox(height: 4),
            ...children,
          ],
        ),
      );

  /// Table with header shading and right-aligned numeric columns.
  pw.Widget table({
    required List<String> headers,
    required List<List<String>> rows,
    Set<int> numeric = const {},
    Map<int, pw.TableColumnWidth>? widths,
    List<String>? footer,
  }) {
    pw.Alignment align(int i) => numeric.contains(i)
        ? pw.Alignment.centerRight
        : pw.Alignment.centerLeft;
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: [...rows, ?footer],
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: line, width: 0.5),
        bottom: pw.BorderSide(color: line, width: 0.5),
      ),
      headerDecoration: const pw.BoxDecoration(color: shade),
      headerStyle: pw.TextStyle(font: fonts.bold, fontSize: 8.5),
      cellStyle: const pw.TextStyle(fontSize: 8.5),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      headerAlignments: {for (var i = 0; i < headers.length; i++) i: align(i)},
      cellAlignments: {for (var i = 0; i < headers.length; i++) i: align(i)},
      columnWidths: widths,
    );
  }

  pw.Widget totalLine(
    String l,
    String v, {
    bool strong = false,
    PdfColor? color,
  }) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Expanded(child: pw.Text(l, style: strong ? h2 : null)),
        pw.Text(
          v,
          style: (strong ? h2 : const pw.TextStyle()).copyWith(color: color),
        ),
      ],
    ),
  );

  static Future<Uint8List> save(pw.Document doc) => doc.save();
}
