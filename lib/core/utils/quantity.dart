/// Quantities are integer thousandths ("milli units"): 1 pcs = 1000.
abstract final class Qty {
  static const one = 1000;

  static String format(int milli) {
    final negative = milli < 0;
    final abs = milli.abs();
    final whole = abs ~/ 1000;
    final frac = abs % 1000;
    final fracStr = frac == 0
        ? ''
        : '.${frac.toString().padLeft(3, '0').replaceFirst(RegExp(r'0+$'), '')}';
    return '${negative ? '-' : ''}$whole$fracStr';
  }

  /// Parses "2", "1.5", "0.250" into milli units. Null for empty input.
  static int? parse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[,\s]'), '');
    if (cleaned.isEmpty) return null;
    final match = RegExp(
      r'^(-?)(\d{0,9})(?:\.(\d{0,3}))?$',
    ).firstMatch(cleaned);
    if (match == null ||
        (match.group(2)!.isEmpty && (match.group(3) ?? '').isEmpty)) {
      throw const FormatException('Enter a valid quantity, e.g. 2 or 1.5');
    }
    final whole = int.parse(match.group(2)!.isEmpty ? '0' : match.group(2)!);
    final frac = int.parse((match.group(3) ?? '').padRight(3, '0'));
    final value = whole * 1000 + frac;
    return match.group(1) == '-' ? -value : value;
  }

  static int? tryParse(String input) {
    try {
      return parse(input);
    } on FormatException {
      return null;
    }
  }
}
