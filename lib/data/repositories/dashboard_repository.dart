import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../local/app_database.dart';
import 'sql.dart';

class DashboardStats {
  const DashboardStats({
    required this.completedToday,
    required this.completedWeek,
    required this.completedMonth,
    required this.inProgress,
    required this.billedMonth,
    required this.collectedMonth,
    required this.outstanding,
    required this.overdueAmount,
    required this.overdueCount,
    required this.pendingCount,
    required this.lowStockCount,
  });

  final int completedToday;
  final int completedWeek;
  final int completedMonth;
  final int inProgress;

  /// Invoices raised this month (not the same as money received).
  final int billedMonth;

  /// Money actually received this month.
  final int collectedMonth;

  /// Unpaid balance of all invoices.
  final int outstanding;
  final int overdueAmount;
  final int overdueCount;

  /// Invoices with any balance.
  final int pendingCount;
  final int lowStockCount;
}

class CompanyBalance {
  const CompanyBalance(this.companyId, this.name, this.outstanding);
  final String companyId;
  final String name;
  final int outstanding;
}

/// Real-time figures for the home screen, computed from stored records.
class DashboardRepository {
  DashboardRepository(this.db);
  final AppDatabase db;

  Set<ResultSetImplementation<dynamic, dynamic>> get _reads => {
    db.serviceVisits,
    db.invoices,
    db.payments,
    db.paymentAllocations,
    db.parts,
    db.stockMovements,
  };

  static const _balances =
      '''
    SELECT i.id, i.company_id, i.due_date,
      i.total_paise - COALESCE(pb.paid, 0) AS balance
    FROM invoices i LEFT JOIN (${Sql.paidByInvoice}) pb ON pb.invoice_id = i.id
    WHERE i.cancelled_at IS NULL''';

  Stream<DashboardStats> watchStats() {
    final now = Dates.now();
    final today = Dates.iso(now);
    final week = Dates.weekStart(now);
    final month = Dates.monthStart(now);
    final monthEnd = Dates.monthEnd(now);
    return db
        .customSelect(
          '''
      SELECT
        (SELECT COUNT(*) FROM service_visits WHERE status = 'completed'
           AND archived_at IS NULL AND visit_date = ?1) AS done_today,
        (SELECT COUNT(*) FROM service_visits WHERE status = 'completed'
           AND archived_at IS NULL AND visit_date BETWEEN ?2 AND ?1) AS done_week,
        (SELECT COUNT(*) FROM service_visits WHERE status = 'completed'
           AND archived_at IS NULL AND visit_date BETWEEN ?3 AND ?4) AS done_month,
        (SELECT COUNT(*) FROM service_visits WHERE status = 'in_progress'
           AND archived_at IS NULL) AS in_progress,
        (SELECT COALESCE(SUM(total_paise), 0) FROM invoices
           WHERE cancelled_at IS NULL AND invoice_date BETWEEN ?3 AND ?4) AS billed,
        (SELECT COALESCE(SUM(amount_paise), 0) FROM payments
           WHERE voided_at IS NULL AND paid_on BETWEEN ?3 AND ?4) AS collected,
        (SELECT COALESCE(SUM(balance), 0) FROM ($_balances) WHERE balance > 0) AS outstanding,
        (SELECT COALESCE(SUM(balance), 0) FROM ($_balances)
           WHERE balance > 0 AND due_date < ?1) AS overdue_amount,
        (SELECT COUNT(*) FROM ($_balances)
           WHERE balance > 0 AND due_date < ?1) AS overdue_count,
        (SELECT COUNT(*) FROM ($_balances) WHERE balance > 0) AS pending_count,
        (SELECT COUNT(*) FROM parts p LEFT JOIN (${Sql.stockByPart}) s
           ON s.part_id = p.id WHERE p.archived_at IS NULL AND
           (COALESCE(s.stock, 0) < 0 OR (p.min_stock_milli > 0
            AND COALESCE(s.stock, 0) <= p.min_stock_milli))) AS low_stock
      ''',
          variables: [
            Variable.withString(today),
            Variable.withString(week),
            Variable.withString(month),
            Variable.withString(monthEnd),
          ],
          readsFrom: _reads,
        )
        .watchSingle()
        .map(
          (r) => DashboardStats(
            completedToday: r.read<int>('done_today'),
            completedWeek: r.read<int>('done_week'),
            completedMonth: r.read<int>('done_month'),
            inProgress: r.read<int>('in_progress'),
            billedMonth: r.read<int>('billed'),
            collectedMonth: r.read<int>('collected'),
            outstanding: r.read<int>('outstanding'),
            overdueAmount: r.read<int>('overdue_amount'),
            overdueCount: r.read<int>('overdue_count'),
            pendingCount: r.read<int>('pending_count'),
            lowStockCount: r.read<int>('low_stock'),
          ),
        );
  }

  /// Companies with the largest unpaid balances.
  Stream<List<CompanyBalance>> watchTopBalances({int limit = 5}) => db
      .customSelect(
        'SELECT c.id, c.name, SUM(b.balance) AS outstanding '
        'FROM ($_balances) b JOIN companies c ON c.id = b.company_id '
        'WHERE b.balance > 0 GROUP BY c.id, c.name '
        'ORDER BY outstanding DESC LIMIT $limit',
        readsFrom: {..._reads, db.companies},
      )
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            CompanyBalance(
              r.read<String>('id'),
              r.read<String>('name'),
              r.read<int>('outstanding'),
            ),
        ],
      );
}
