import 'package:intl/intl.dart';

/// Money helpers. All amounts are integer paise (₹1 = 100 paise); no floating
/// point arithmetic is ever used for amounts.
abstract final class Money {
  static final _group = NumberFormat('#,##,##0', 'en_IN');

  /// Formats paise as Indian currency, e.g. 12345678 -> "₹1,23,456.78".
  static String format(int paise, {bool symbol = true, bool decimals = true}) {
    final negative = paise < 0;
    final abs = paise.abs();
    final rupees = abs ~/ 100;
    final rem = abs % 100;
    final buf = StringBuffer()
      ..write(negative ? '-' : '')
      ..write(symbol ? '₹' : '')
      ..write(_group.format(rupees));
    if (decimals) buf.write('.${rem.toString().padLeft(2, '0')}');
    return buf.toString();
  }

  /// Short form for dashboards: drops ".00" when the amount is whole rupees.
  static String short(int paise) => format(paise, decimals: paise % 100 != 0);

  /// Plain decimal string for CSV/forms, e.g. 150050 -> "1500.50".
  static String plain(int paise) {
    final negative = paise < 0;
    final abs = paise.abs();
    return '${negative ? '-' : ''}${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
  }

  /// Value for an editable text field: "" for zero, no trailing ".00".
  static String editable(int? paise) {
    if (paise == null || paise == 0) return '';
    final p = plain(paise);
    return p.endsWith('.00') ? p.substring(0, p.length - 3) : p;
  }

  /// Parses user input such as "1,500", "₹ 1500.5" or "1500.50" into paise.
  /// Returns null for empty input; throws [FormatException] for invalid input.
  static int? parse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[₹,\s]'), '');
    if (cleaned.isEmpty) return null;
    final match = RegExp(
      r'^(-?)(\d{0,11})(?:\.(\d{0,2}))?$',
    ).firstMatch(cleaned);
    if (match == null ||
        (match.group(2)!.isEmpty && (match.group(3) ?? '').isEmpty)) {
      throw const FormatException('Enter a valid amount, e.g. 1500 or 1500.50');
    }
    final rupees = int.parse(match.group(2)!.isEmpty ? '0' : match.group(2)!);
    final frac = (match.group(3) ?? '').padRight(2, '0');
    final value = rupees * 100 + int.parse(frac);
    return match.group(1) == '-' ? -value : value;
  }

  /// Like [parse] but returns null instead of throwing.
  static int? tryParse(String input) {
    try {
      return parse(input);
    } on FormatException {
      return null;
    }
  }
}
