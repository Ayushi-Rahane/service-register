/// Amount in words using the Indian numbering system (lakh, crore).
/// e.g. 23605050 -> "Rupees Two Lakh Thirty-Six Thousand Fifty and Fifty Paise Only"
abstract final class AmountWords {
  static const _ones = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
  ];
  static const _tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety',
  ];

  static String _belowHundred(int n) {
    if (n < 20) return _ones[n];
    final t = _tens[n ~/ 10];
    return n % 10 == 0 ? t : '$t-${_ones[n % 10]}';
  }

  static String _belowThousand(int n) {
    final h = n ~/ 100, r = n % 100;
    final parts = <String>[
      if (h > 0) '${_ones[h]} Hundred',
      if (r > 0) _belowHundred(r),
    ];
    return parts.join(' ');
  }

  static String number(int n) {
    if (n == 0) return 'Zero';
    final parts = <String>[];
    final crore = n ~/ 10000000;
    n %= 10000000;
    final lakh = n ~/ 100000;
    n %= 100000;
    final thousand = n ~/ 1000;
    n %= 1000;
    if (crore > 0) parts.add('${number(crore)} Crore');
    if (lakh > 0) parts.add('${_belowHundred(lakh)} Lakh');
    if (thousand > 0) parts.add('${_belowHundred(thousand)} Thousand');
    if (n > 0) parts.add(_belowThousand(n));
    return parts.join(' ');
  }

  static String rupees(int paise) {
    final r = paise.abs() ~/ 100, p = paise.abs() % 100;
    final b = StringBuffer('Rupees ${number(r)}');
    if (p > 0) b.write(' and ${_belowHundred(p)} Paise');
    b.write(' Only');
    return b.toString();
  }
}
