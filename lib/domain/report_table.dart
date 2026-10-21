import '../core/utils/money.dart';
import '../core/utils/quantity.dart';

enum CellType { text, money, qty, count }

class ReportColumn {
  const ReportColumn(this.label, [this.type = CellType.text]);
  final String label;
  final CellType type;
  bool get numeric => type != CellType.text;
}

/// A tabular report. Cell values: String/null for text, int paise for money,
/// int milli-units for qty, int for count.
class ReportTable {
  ReportTable({
    required this.title,
    required this.columns,
    required this.rows,
    this.subtitle = '',
    this.summary = const [],
    this.totalLabel = 'Total',
    Set<int>? totalColumns,
  }) : totalColumns = totalColumns ?? {};

  final String title;
  final String subtitle;
  final List<ReportColumn> columns;
  final List<List<Object?>> rows;

  /// Extra lines shown above the table, e.g. ("Billed", "₹1,000").
  final List<(String, String)> summary;

  /// Indexes of columns that get a total row.
  final Set<int> totalColumns;
  final String totalLabel;

  bool get hasTotals => totalColumns.isNotEmpty && rows.isNotEmpty;

  int total(int column) =>
      rows.fold(0, (s, r) => s + ((r[column] as int?) ?? 0));

  List<Object?> get totalsRow => [
    for (var i = 0; i < columns.length; i++)
      if (i == 0)
        totalLabel
      else if (totalColumns.contains(i))
        total(i)
      else
        null,
  ];

  /// Human-readable cell text.
  String display(int column, Object? value) {
    if (value == null) return '';
    return switch (columns[column].type) {
      CellType.money => Money.format(value as int),
      CellType.qty => Qty.format(value as int),
      CellType.count => '$value',
      CellType.text => '$value',
    };
  }

  /// Spreadsheet-friendly cell text (plain numbers, no currency symbol).
  String raw(int column, Object? value) {
    if (value == null) return '';
    return switch (columns[column].type) {
      CellType.money => Money.plain(value as int),
      CellType.qty => Qty.format(value as int),
      CellType.count => '$value',
      CellType.text => '$value',
    };
  }
}
