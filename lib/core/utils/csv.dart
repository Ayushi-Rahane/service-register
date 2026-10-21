import '../../domain/report_table.dart';

/// RFC 4180 CSV writer. Output starts with a UTF-8 byte-order mark so Excel
/// shows non-ASCII text (₹, Devanagari) correctly, and uses CRLF line endings.
abstract final class Csv {
  static const bom = '﻿';

  static String escape(String value) {
    var v = value;
    // Prevent spreadsheet formula injection from user-entered text.
    if (v.isNotEmpty && '=+-@'.contains(v[0]) && double.tryParse(v) == null) {
      v = "'$v";
    }
    if (v.contains(RegExp('[",\r\n]'))) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }

  static String encode(List<List<String>> rows) {
    final b = StringBuffer(bom);
    for (final r in rows) {
      b
        ..write(r.map(escape).join(','))
        ..write('\r\n');
    }
    return b.toString();
  }

  static String fromReport(ReportTable t) => encode([
    [for (final c in t.columns) c.label],
    for (final r in t.rows) [for (var i = 0; i < r.length; i++) t.raw(i, r[i])],
    if (t.hasTotals)
      [for (var i = 0; i < t.columns.length; i++) t.raw(i, t.totalsRow[i])],
  ]);
}
