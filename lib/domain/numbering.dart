import '../core/utils/dates.dart';

/// Document numbers look like `INV-2627-0042`: prefix, Indian financial year,
/// sequence. The next sequence is derived from the numbers already stored (not
/// from a separate counter that could be reset), inside the same database
/// transaction as the insert, and the column is unique locally and on the
/// server.
abstract final class DocNumbers {
  static String seriesPrefix(String prefix, DateTime date) =>
      '${prefix.trim().toUpperCase()}-${Dates.financialYearCode(date)}-';

  /// Given existing numbers in the series, returns the next number.
  static String next(String prefix, DateTime date, Iterable<String> existing) {
    final series = seriesPrefix(prefix, date);
    var max = 0;
    for (final n in existing) {
      if (!n.startsWith(series)) continue;
      final seq = int.tryParse(n.substring(series.length));
      if (seq != null && seq > max) max = seq;
    }
    return '$series${(max + 1).toString().padLeft(4, '0')}';
  }

  /// Company codes: `C-0001`, `C-0002`, ...
  static String nextCompanyCode(Iterable<String?> existing) {
    var max = 0;
    for (final c in existing) {
      if (c == null || !c.startsWith('C-')) continue;
      final seq = int.tryParse(c.substring(2));
      if (seq != null && seq > max) max = seq;
    }
    return 'C-${(max + 1).toString().padLeft(4, '0')}';
  }
}
