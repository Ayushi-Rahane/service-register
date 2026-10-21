import 'package:intl/intl.dart';

/// Calendar-date helpers. Dates are stored as ISO "yyyy-MM-dd" strings so they
/// never shift with time zones.
abstract final class Dates {
  static final _iso = DateFormat('yyyy-MM-dd');
  static final _display = DateFormat('dd MMM yyyy');
  static final _short = DateFormat('dd MMM');
  static final _dayName = DateFormat('EEE, dd MMM');
  static final _month = DateFormat('MMMM yyyy');
  static final _dateTime = DateFormat('dd MMM yyyy, hh:mm a');

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Overridable clock for tests.
  static DateTime Function() clock = DateTime.now;

  static DateTime now() => clock();
  static DateTime todayDate() => dateOnly(clock());
  static String today() => iso(clock());

  static String iso(DateTime d) => _iso.format(d);
  static DateTime parse(String iso) => _iso.parseStrict(iso);
  static DateTime? tryParse(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    try {
      return _iso.parseStrict(iso);
    } on FormatException {
      return null;
    }
  }

  /// "16 Oct 2026"
  static String display(String? iso) {
    final d = tryParse(iso);
    return d == null ? '-' : _display.format(d);
  }

  static String displayDate(DateTime d) => _display.format(d);
  static String shortDisplay(String iso) => _short.format(parse(iso));
  static String dayName(String iso) => _dayName.format(parse(iso));
  static String monthName(DateTime d) => _month.format(d);
  static String timestamp(DateTime utc) => _dateTime.format(utc.toLocal());

  /// "Today", "Tomorrow", "Yesterday", or "Mon, 16 Oct".
  static String relative(String iso) {
    final d = parse(iso);
    final diff = d.difference(todayDate()).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return d.year == todayDate().year ? _dayName.format(d) : _display.format(d);
  }

  static String addDays(String iso, int days) =>
      Dates.iso(parse(iso).add(Duration(days: days)));

  static int daysBetween(String fromIso, String toIso) =>
      parse(toIso).difference(parse(fromIso)).inDays;

  static String monthStart(DateTime d) => iso(DateTime(d.year, d.month, 1));
  static String monthEnd(DateTime d) => iso(DateTime(d.year, d.month + 1, 0));

  /// Monday of the week containing [d].
  static String weekStart(DateTime d) =>
      iso(dateOnly(d).subtract(Duration(days: d.weekday - 1)));

  /// Indian financial year (April–March) code, e.g. Oct 2026 -> "2627".
  static String financialYearCode(DateTime d) {
    final start = d.month >= 4 ? d.year : d.year - 1;
    final a = (start % 100).toString().padLeft(2, '0');
    final b = ((start + 1) % 100).toString().padLeft(2, '0');
    return '$a$b';
  }

  /// "HH:mm" -> "02:30 PM"
  static String displayTime(String? hhmm) {
    if (hhmm == null || hhmm.isEmpty) return '';
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final dt = DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
    return DateFormat('hh:mm a').format(dt);
  }
}
