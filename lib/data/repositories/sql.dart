/// Shared SQL fragments so balance rules are defined in exactly one place.
abstract final class Sql {
  /// Active (non-void, non-deleted) allocations.
  static const activeAllocations = '''
    SELECT a.invoice_id, a.payment_id, a.amount_paise
    FROM payment_allocations a
    JOIN payments p ON p.id = a.payment_id
    WHERE a.deleted_at IS NULL AND p.voided_at IS NULL''';

  /// Paid amount per invoice: `invoice_id, paid`.
  static const paidByInvoice = '''
    SELECT invoice_id, SUM(amount_paise) AS paid
    FROM ($activeAllocations) GROUP BY invoice_id''';

  /// Allocated amount per payment: `payment_id, allocated`.
  static const allocatedByPayment = '''
    SELECT payment_id, SUM(amount_paise) AS allocated
    FROM ($activeAllocations) GROUP BY payment_id''';

  /// Current stock per part: `part_id, stock`.
  static const stockByPart = '''
    SELECT part_id, SUM(qty_milli) AS stock
    FROM stock_movements WHERE deleted_at IS NULL GROUP BY part_id''';
}
