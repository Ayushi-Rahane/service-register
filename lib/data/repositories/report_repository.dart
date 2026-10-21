import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../domain/billing.dart';
import '../../domain/enums.dart';
import '../../domain/report_table.dart';
import '../local/app_database.dart';
import 'sql.dart';

enum ReportType {
  businessSummary(
    'Business summary',
    'Visits, billing and collections for a period',
  ),
  companyHistory(
    'Company service history',
    'All completed visits, company-wise',
  ),
  machineHistory(
    'Machine maintenance history',
    'Visits and parts for one machine',
  ),
  monthlyBilling(
    'Monthly billing & collections',
    'Billed vs. received, month by month',
  ),
  outstanding('Outstanding invoices', 'Unpaid balances as of today'),
  payments('Payments received', 'Every payment in a period'),
  partsUsed('Parts used', 'Spare parts used on visits in a period'),
  stockSummary(
    'Inventory stock summary',
    'Current stock and value of each part',
  );

  const ReportType(this.title, this.description);
  final String title;
  final String description;

  bool get usesDates => this != outstanding && this != stockSummary;
  bool get usesCompany =>
      this == businessSummary ||
      this == companyHistory ||
      this == outstanding ||
      this == payments;
  bool get needsMachine => this == machineHistory;
  bool get usesCategoryAndType =>
      this == businessSummary || this == companyHistory;
}

class ReportRequest {
  const ReportRequest({
    required this.type,
    required this.from,
    required this.to,
    this.companyId,
    this.machineId,
    this.category,
    this.serviceType,
  });
  final ReportType type;
  final String from;
  final String to;
  final String? companyId;
  final String? machineId;
  final MachineCategory? category;
  final ServiceType? serviceType;
}

class ReportRepository {
  ReportRepository(this.db);
  final AppDatabase db;

  Future<ReportTable> build(ReportRequest r) => switch (r.type) {
    ReportType.businessSummary => _summary(r),
    ReportType.companyHistory => _companyHistory(r),
    ReportType.machineHistory => _machineHistory(r),
    ReportType.monthlyBilling => _monthly(r),
    ReportType.outstanding => _outstanding(r),
    ReportType.payments => _payments(r),
    ReportType.partsUsed => _partsUsed(r),
    ReportType.stockSummary => _stock(),
  };

  String _period(ReportRequest r) =>
      '${Dates.display(r.from)} to ${Dates.display(r.to)}';

  Future<String> _companyName(String? id) async {
    if (id == null) return 'All companies';
    final c = await (db.select(
      db.companies,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return c?.name ?? 'Unknown company';
  }

  /// Shared WHERE for completed visits in range with optional filters.
  (String, List<Variable<Object>>) _visitWhere(ReportRequest r) {
    final where = <String>[
      "v.status = 'completed'",
      'v.archived_at IS NULL',
      'v.visit_date BETWEEN ? AND ?',
    ];
    final vars = <Variable<Object>>[
      Variable.withString(r.from),
      Variable.withString(r.to),
    ];
    if (r.companyId != null) {
      where.add('v.company_id = ?');
      vars.add(Variable.withString(r.companyId!));
    }
    if (r.category != null) {
      where.add('m.category = ?');
      vars.add(Variable.withString(r.category!.db));
    }
    if (r.serviceType != null) {
      where.add('v.service_type = ?');
      vars.add(Variable.withString(r.serviceType!.db));
    }
    return (where.join(' AND '), vars);
  }

  Future<ReportTable> _summary(ReportRequest r) async {
    final (where, vars) = _visitWhere(r);
    final byType = await db
        .customSelect(
          'SELECT v.service_type AS t, COUNT(*) AS n, COALESCE(SUM(v.total_paise), 0) AS amt '
          'FROM service_visits v LEFT JOIN machines m ON m.id = v.machine_id '
          'WHERE $where GROUP BY v.service_type ORDER BY n DESC',
          variables: vars,
        )
        .get();
    final companyFilter = r.companyId == null ? '' : ' AND company_id = ?';
    final cVars = [
      Variable.withString(r.from),
      Variable.withString(r.to),
      if (r.companyId != null) Variable.withString(r.companyId!),
    ];
    final billed = await db
        .customSelect(
          'SELECT COALESCE(SUM(total_paise), 0) AS s, COUNT(*) AS n FROM invoices '
          'WHERE cancelled_at IS NULL AND invoice_date BETWEEN ? AND ?$companyFilter',
          variables: cVars,
        )
        .getSingle();
    final collected = await db
        .customSelect(
          'SELECT COALESCE(SUM(amount_paise), 0) AS s, COUNT(*) AS n FROM payments '
          'WHERE voided_at IS NULL AND paid_on BETWEEN ? AND ?$companyFilter',
          variables: cVars,
        )
        .getSingle();
    final rows = [
      for (final row in byType)
        [
          ServiceType.fromDb(row.read<String>('t')).label,
          row.read<int>('n'),
          row.read<int>('amt'),
        ],
    ];
    final filters = [
      _period(r),
      await _companyName(r.companyId),
      if (r.category != null) r.category!.label,
      if (r.serviceType != null) r.serviceType!.label,
    ].join('  •  ');
    return ReportTable(
      title: 'Business summary',
      subtitle: filters,
      summary: [
        (
          'Completed visits',
          '${rows.fold<int>(0, (s, x) => s + (x[1] as int))}',
        ),
        (
          'Revenue billed (${billed.read<int>('n')} invoices)',
          Money.format(billed.read<int>('s')),
        ),
        (
          'Money collected (${collected.read<int>('n')} payments)',
          Money.format(collected.read<int>('s')),
        ),
        (
          'Note',
          'Billed is the value of invoices raised; collected is cash actually received.',
        ),
      ],
      columns: const [
        ReportColumn('Service type'),
        ReportColumn('Visits', CellType.count),
        ReportColumn('Visit value', CellType.money),
      ],
      rows: rows,
      totalColumns: {1, 2},
    );
  }

  Future<ReportTable> _companyHistory(ReportRequest r) async {
    final (where, vars) = _visitWhere(r);
    final rows = await db
        .customSelect(
          'SELECT v.*, c.name AS company_name, m.name AS machine_name '
          'FROM service_visits v JOIN companies c ON c.id = v.company_id '
          'LEFT JOIN machines m ON m.id = v.machine_id WHERE $where '
          'ORDER BY c.name COLLATE NOCASE, v.visit_date',
          variables: vars,
        )
        .get();
    return ReportTable(
      title: 'Company service history',
      subtitle: '${await _companyName(r.companyId)}  •  ${_period(r)}',
      columns: const [
        ReportColumn('Date'),
        ReportColumn('Visit no.'),
        ReportColumn('Company'),
        ReportColumn('Machine'),
        ReportColumn('Service type'),
        ReportColumn('Problem'),
        ReportColumn('Work done'),
        ReportColumn('Amount', CellType.money),
      ],
      rows: [
        for (final x in rows)
          [
            Dates.display(x.read<String>('visit_date')),
            x.read<String>('visit_no'),
            x.read<String>('company_name'),
            x.readNullable<String>('machine_name') ?? '',
            ServiceType.fromDb(x.read<String>('service_type')).label,
            x.readNullable<String>('reported_problem') ?? '',
            x.readNullable<String>('work_done') ?? '',
            x.read<int>('total_paise'),
          ],
      ],
      totalColumns: {7},
    );
  }

  Future<ReportTable> _machineHistory(ReportRequest r) async {
    if (r.machineId == null) {
      throw ArgumentError('Select a machine');
    }
    final machine = await (db.select(
      db.machines,
    )..where((t) => t.id.equals(r.machineId!))).getSingle();
    final rows = await db
        .customSelect(
          "SELECT v.* FROM service_visits v WHERE v.machine_id = ? AND v.status = 'completed' "
          'AND v.archived_at IS NULL AND v.visit_date BETWEEN ? AND ? ORDER BY v.visit_date',
          variables: [
            Variable.withString(r.machineId!),
            Variable.withString(r.from),
            Variable.withString(r.to),
          ],
        )
        .get();
    final parts = <String, List<String>>{};
    for (final p
        in await (db.select(db.visitParts)..where(
              (t) =>
                  t.visitId.isIn(rows.map((x) => x.read<String>('id'))) &
                  t.deletedAt.isNull(),
            ))
            .get()) {
      parts
          .putIfAbsent(p.visitId, () => [])
          .add('${p.partName} x${Qty.format(p.qtyMilli)}');
    }
    return ReportTable(
      title: 'Machine maintenance history',
      subtitle:
          '${machine.name}${machine.serialNumber == null ? '' : ' (S/N ${machine.serialNumber})'}'
          '  •  ${await _companyName(machine.companyId)}  •  ${_period(r)}',
      columns: const [
        ReportColumn('Date'),
        ReportColumn('Visit no.'),
        ReportColumn('Service type'),
        ReportColumn('Problem'),
        ReportColumn('Diagnosis'),
        ReportColumn('Work done'),
        ReportColumn('Parts'),
        ReportColumn('Amount', CellType.money),
      ],
      rows: [
        for (final x in rows)
          [
            Dates.display(x.read<String>('visit_date')),
            x.read<String>('visit_no'),
            ServiceType.fromDb(x.read<String>('service_type')).label,
            x.readNullable<String>('reported_problem') ?? '',
            x.readNullable<String>('diagnosis') ?? '',
            x.readNullable<String>('work_done') ?? '',
            (parts[x.read<String>('id')] ?? const []).join(', '),
            x.read<int>('total_paise'),
          ],
      ],
      totalColumns: {7},
    );
  }

  Future<ReportTable> _monthly(ReportRequest r) async {
    final billed = await db
        .customSelect(
          'SELECT substr(invoice_date, 1, 7) AS m, COUNT(*) AS n, SUM(total_paise) AS s '
          'FROM invoices WHERE cancelled_at IS NULL AND invoice_date BETWEEN ? AND ? GROUP BY m',
          variables: [Variable.withString(r.from), Variable.withString(r.to)],
        )
        .get();
    final collected = await db
        .customSelect(
          'SELECT substr(paid_on, 1, 7) AS m, COUNT(*) AS n, SUM(amount_paise) AS s '
          'FROM payments WHERE voided_at IS NULL AND paid_on BETWEEN ? AND ? GROUP BY m',
          variables: [Variable.withString(r.from), Variable.withString(r.to)],
        )
        .get();
    final months = <String, List<int>>{};
    for (final b in billed) {
      months.putIfAbsent(b.read<String>('m'), () => [0, 0, 0, 0])
        ..[0] = b.read<int>('n')
        ..[1] = b.read<int>('s');
    }
    for (final c in collected) {
      months.putIfAbsent(c.read<String>('m'), () => [0, 0, 0, 0])
        ..[2] = c.read<int>('n')
        ..[3] = c.read<int>('s');
    }
    final keys = months.keys.toList()..sort();
    return ReportTable(
      title: 'Monthly billing & collections',
      subtitle: _period(r),
      summary: const [
        (
          'Note',
          'Billed = invoices raised in the month. Collected = money received in the month (may be for older invoices).',
        ),
      ],
      columns: const [
        ReportColumn('Month'),
        ReportColumn('Invoices', CellType.count),
        ReportColumn('Billed', CellType.money),
        ReportColumn('Payments', CellType.count),
        ReportColumn('Collected', CellType.money),
      ],
      rows: [
        for (final k in keys)
          [
            Dates.monthName(DateTime.parse('$k-01')),
            months[k]![0],
            months[k]![1],
            months[k]![2],
            months[k]![3],
          ],
      ],
      totalColumns: {1, 2, 3, 4},
    );
  }

  Future<ReportTable> _outstanding(ReportRequest r) async {
    final today = Dates.today();
    final rows = await db
        .customSelect(
          'SELECT i.*, c.name AS company_name, COALESCE(pb.paid, 0) AS paid '
          'FROM invoices i JOIN companies c ON c.id = i.company_id '
          'LEFT JOIN (${Sql.paidByInvoice}) pb ON pb.invoice_id = i.id '
          'WHERE i.cancelled_at IS NULL AND i.total_paise > COALESCE(pb.paid, 0)'
          '${r.companyId == null ? '' : ' AND i.company_id = ?'} '
          'ORDER BY i.due_date IS NULL, i.due_date, i.invoice_date',
          variables: [
            if (r.companyId != null) Variable.withString(r.companyId!),
          ],
        )
        .get();
    return ReportTable(
      title: 'Outstanding invoices',
      subtitle:
          '${await _companyName(r.companyId)}  •  as of ${Dates.display(today)}',
      columns: const [
        ReportColumn('Invoice no.'),
        ReportColumn('Date'),
        ReportColumn('Due date'),
        ReportColumn('Company'),
        ReportColumn('Total', CellType.money),
        ReportColumn('Paid', CellType.money),
        ReportColumn('Balance', CellType.money),
        ReportColumn('Days overdue', CellType.count),
        ReportColumn('Status'),
      ],
      rows: [
        for (final x in rows)
          () {
            final bal = InvoiceBalance(
              total: x.read<int>('total_paise'),
              paid: x.read<int>('paid'),
              dueDate: x.readNullable<String>('due_date'),
              today: today,
            );
            return <Object?>[
              x.read<String>('invoice_no'),
              Dates.display(x.read<String>('invoice_date')),
              Dates.display(x.readNullable<String>('due_date')),
              x.read<String>('company_name'),
              bal.total,
              bal.paid,
              bal.outstanding,
              bal.daysOverdue(),
              bal.status.label,
            ];
          }(),
      ],
      totalColumns: {4, 5, 6},
    );
  }

  Future<ReportTable> _payments(ReportRequest r) async {
    final rows = await db
        .customSelect(
          'SELECT p.*, c.name AS company_name, '
          "(SELECT GROUP_CONCAT(i.invoice_no, ', ') FROM payment_allocations a "
          'JOIN invoices i ON i.id = a.invoice_id WHERE a.payment_id = p.id '
          'AND a.deleted_at IS NULL) AS invoice_nos '
          'FROM payments p JOIN companies c ON c.id = p.company_id '
          'WHERE p.voided_at IS NULL AND p.paid_on BETWEEN ? AND ?'
          '${r.companyId == null ? '' : ' AND p.company_id = ?'} ORDER BY p.paid_on',
          variables: [
            Variable.withString(r.from),
            Variable.withString(r.to),
            if (r.companyId != null) Variable.withString(r.companyId!),
          ],
        )
        .get();
    return ReportTable(
      title: 'Payments received',
      subtitle: '${await _companyName(r.companyId)}  •  ${_period(r)}',
      columns: const [
        ReportColumn('Date'),
        ReportColumn('Receipt no.'),
        ReportColumn('Company'),
        ReportColumn('Method'),
        ReportColumn('Reference'),
        ReportColumn('Invoices'),
        ReportColumn('Amount', CellType.money),
      ],
      rows: [
        for (final x in rows)
          [
            Dates.display(x.read<String>('paid_on')),
            x.read<String>('receipt_no'),
            x.read<String>('company_name'),
            PaymentMethod.fromDb(x.read<String>('method')).label,
            x.readNullable<String>('reference') ?? '',
            x.readNullable<String>('invoice_nos') ?? 'Advance / credit',
            x.read<int>('amount_paise'),
          ],
      ],
      totalColumns: {6},
    );
  }

  Future<ReportTable> _partsUsed(ReportRequest r) async {
    final rows = await db
        .customSelect(
          'SELECT p.part_name, MAX(p.part_number) AS part_number, SUM(p.qty_milli) AS qty, '
          'COUNT(DISTINCT p.visit_id) AS visits, '
          'SUM((p.qty_milli * p.unit_price_paise + 500) / 1000) AS sales, '
          'SUM(CASE WHEN p.unit_cost_paise IS NULL THEN 0 ELSE '
          '(p.qty_milli * p.unit_cost_paise + 500) / 1000 END) AS cost '
          'FROM visit_parts p JOIN service_visits v ON v.id = p.visit_id '
          "WHERE p.deleted_at IS NULL AND v.status = 'completed' AND v.archived_at IS NULL "
          'AND v.visit_date BETWEEN ? AND ? '
          'GROUP BY COALESCE(p.part_id, LOWER(p.part_name)) ORDER BY qty DESC',
          variables: [Variable.withString(r.from), Variable.withString(r.to)],
        )
        .get();
    return ReportTable(
      title: 'Parts used',
      subtitle: _period(r),
      columns: const [
        ReportColumn('Part'),
        ReportColumn('Part no.'),
        ReportColumn('Qty used', CellType.qty),
        ReportColumn('Visits', CellType.count),
        ReportColumn('Charged to customers', CellType.money),
        ReportColumn('Cost (if known)', CellType.money),
      ],
      rows: [
        for (final x in rows)
          [
            x.read<String>('part_name'),
            x.readNullable<String>('part_number') ?? '',
            x.read<int>('qty'),
            x.read<int>('visits'),
            x.read<int>('sales'),
            x.read<int>('cost'),
          ],
      ],
      totalColumns: {4, 5},
    );
  }

  Future<ReportTable> _stock() async {
    final rows = await db
        .customSelect(
          'SELECT p.*, COALESCE(s.stock, 0) AS stock FROM parts p '
          'LEFT JOIN (${Sql.stockByPart}) s ON s.part_id = p.id '
          'WHERE p.archived_at IS NULL ORDER BY p.name COLLATE NOCASE',
        )
        .get();
    return ReportTable(
      title: 'Inventory stock summary',
      subtitle: 'As of ${Dates.display(Dates.today())}',
      columns: const [
        ReportColumn('Part'),
        ReportColumn('Part no.'),
        ReportColumn('Category'),
        ReportColumn('Unit'),
        ReportColumn('In stock', CellType.qty),
        ReportColumn('Minimum', CellType.qty),
        ReportColumn('Purchase price', CellType.money),
        ReportColumn('Stock value', CellType.money),
        ReportColumn('Status'),
      ],
      rows: [
        for (final x in rows)
          () {
            final stock = x.read<int>('stock');
            final min = x.read<int>('min_stock_milli');
            final price = x.readNullable<int>('purchase_paise');
            return <Object?>[
              x.read<String>('name'),
              x.readNullable<String>('part_number') ?? '',
              x.readNullable<String>('category') ?? '',
              x.read<String>('unit'),
              stock,
              min,
              price,
              price == null || stock <= 0 ? 0 : Billing.lineTotal(stock, price),
              stock < 0
                  ? 'Below zero'
                  : (min > 0 && stock <= min ? 'Low stock' : 'OK'),
            ];
          }(),
      ],
      totalColumns: {7},
    );
  }
}
