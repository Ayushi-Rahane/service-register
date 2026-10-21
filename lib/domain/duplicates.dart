/// Helpers for warning about likely duplicate companies. Nothing is ever merged
/// automatically – these only drive a warning the user can dismiss.
abstract final class Duplicates {
  static const _suffixes = {
    'pvt',
    'private',
    'ltd',
    'limited',
    'llp',
    'co',
    'company',
    'and',
    'the',
    'inc',
    'corp',
    'corporation',
    'm/s',
    'ms',
  };

  static String normalizeName(String name) {
    final words = name
        .toLowerCase()
        .replaceAll('&', ' and ')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty && !_suffixes.contains(w));
    return words.join(' ');
  }

  /// Last 10 digits of a phone number (drops +91 / leading 0).
  static String normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
  }

  static bool samePhone(String? a, String? b) {
    if (a == null || b == null) return false;
    final na = normalizePhone(a), nb = normalizePhone(b);
    return na.length >= 6 && na == nb;
  }

  static bool similarName(String a, String b) {
    final na = normalizeName(a), nb = normalizeName(b);
    if (na.isEmpty || nb.isEmpty) return false;
    if (na == nb) return true;
    final compactA = na.replaceAll(' ', ''), compactB = nb.replaceAll(' ', '');
    if (compactA == compactB) return true;
    if (compactA.length >= 5 &&
        compactB.length >= 5 &&
        (compactA.contains(compactB) || compactB.contains(compactA))) {
      return true;
    }
    final longest = compactA.length > compactB.length
        ? compactA.length
        : compactB.length;
    return longest >= 6 && _levenshtein(compactA, compactB) <= 2;
  }

  static int _levenshtein(String a, String b) {
    var prev = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 1; i <= a.length; i++) {
      final cur = List<int>.filled(b.length + 1, 0)..[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        cur[j] = [
          prev[j] + 1,
          cur[j - 1] + 1,
          prev[j - 1] + cost,
        ].reduce((x, y) => x < y ? x : y);
      }
      prev = cur;
    }
    return prev[b.length];
  }
}
