import 'enums.dart';

/// Pure billing rules. Integer paise everywhere; rounding is half-up to the
/// nearest paisa and happens exactly once per line / tax computation.
abstract final class Billing {
  /// Amount for [qtyMilli] (thousandths) at [unitPricePaise].
  static int lineTotal(int qtyMilli, int unitPricePaise) {
    final raw = qtyMilli * unitPricePaise;
    // Half-up rounding that is symmetric for negatives.
    return raw >= 0 ? (raw + 500) ~/ 1000 : -((-raw + 500) ~/ 1000);
  }

  /// Tax at [rateBp] basis points (1800 = 18%) on [taxablePaise].
  static int tax(int taxablePaise, int rateBp) {
    if (rateBp <= 0 || taxablePaise <= 0) return 0;
    return (taxablePaise * rateBp + 5000) ~/ 10000;
  }

  /// Formats basis points as a percentage, e.g. 1800 -> "18", 1250 -> "12.5".
  static String rateLabel(int rateBp) {
    final whole = rateBp ~/ 100;
    final frac = rateBp % 100;
    if (frac == 0) return '$whole';
    return '$whole.${frac.toString().padLeft(2, '0').replaceFirst(RegExp(r'0$'), '')}';
  }

  /// Parses "18" / "12.5" into basis points; null when invalid.
  static int? parseRate(String input) {
    final m = RegExp(
      r'^\s*(\d{1,2})(?:\.(\d{1,2}))?\s*%?\s*$',
    ).firstMatch(input);
    if (m == null) return null;
    final frac = (m.group(2) ?? '').padRight(2, '0');
    final bp = int.parse(m.group(1)!) * 100 + int.parse(frac);
    return bp <= 10000 ? bp : null;
  }
}

/// Breakdown of the charges for a service visit or invoice.
class ChargeBreakdown {
  const ChargeBreakdown({
    required this.labour,
    required this.parts,
    required this.travel,
    required this.other,
    required this.discount,
    required this.taxRateBp,
  });

  /// Builds the breakdown from typed line items.
  factory ChargeBreakdown.fromLines(
    Iterable<({InvoiceItemKind kind, int amount})> lines, {
    int discount = 0,
    int taxRateBp = 0,
  }) {
    var labour = 0, parts = 0, travel = 0, other = 0;
    for (final l in lines) {
      switch (l.kind) {
        case InvoiceItemKind.labour:
          labour += l.amount;
        case InvoiceItemKind.part:
          parts += l.amount;
        case InvoiceItemKind.travel:
          travel += l.amount;
        case InvoiceItemKind.other:
          other += l.amount;
      }
    }
    return ChargeBreakdown(
      labour: labour,
      parts: parts,
      travel: travel,
      other: other,
      discount: discount,
      taxRateBp: taxRateBp,
    );
  }

  final int labour;
  final int parts;
  final int travel;
  final int other;
  final int discount;
  final int taxRateBp;

  int get subtotal => labour + parts + travel + other;

  /// Discount actually applied (never more than the subtotal, never negative).
  int get appliedDiscount => discount.clamp(0, subtotal < 0 ? 0 : subtotal);
  int get taxable => subtotal - appliedDiscount;
  int get tax => Billing.tax(taxable, taxRateBp);
  int get total => taxable + tax;

  /// Validation message, or null when the inputs are consistent.
  String? validate() {
    if (labour < 0 || parts < 0 || travel < 0 || other < 0) {
      return 'Charges cannot be negative';
    }
    if (discount < 0) return 'Discount cannot be negative';
    if (discount > subtotal) return 'Discount cannot be more than the charges';
    if (taxRateBp < 0 || taxRateBp > 10000) return 'Tax rate must be 0–100%';
    return null;
  }
}

/// Derived payment position of an invoice. Status is always computed from the
/// amounts and due date, never stored.
class InvoiceBalance {
  const InvoiceBalance({
    required this.total,
    required this.paid,
    required this.dueDate,
    required this.today,
    this.cancelled = false,
  });

  final int total;
  final int paid;

  /// ISO yyyy-MM-dd or null.
  final String? dueDate;

  /// ISO yyyy-MM-dd.
  final String today;
  final bool cancelled;

  int get outstanding => cancelled ? 0 : (total - paid).clamp(0, total);

  /// Amount paid beyond the total (should not normally happen because
  /// allocations are capped, but reported rather than hidden).
  int get excess => paid > total ? paid - total : 0;

  bool get isOverdue =>
      !cancelled &&
      outstanding > 0 &&
      dueDate != null &&
      dueDate!.compareTo(today) < 0;

  int daysOverdue() {
    if (!isOverdue) return 0;
    final due = DateTime.parse(dueDate!);
    final now = DateTime.parse(today);
    return now.difference(due).inDays;
  }

  PaymentStatus get status {
    if (cancelled) return PaymentStatus.cancelled;
    if (outstanding <= 0) return PaymentStatus.paid;
    if (isOverdue) return PaymentStatus.overdue;
    if (paid > 0) return PaymentStatus.partiallyPaid;
    return PaymentStatus.unpaid;
  }
}

/// Rules for applying a payment to an invoice.
abstract final class Allocation {
  /// Maximum that can be allocated from a payment to an invoice.
  static int maxAllocatable({
    required int invoiceOutstanding,
    required int paymentUnallocated,
  }) {
    final m = invoiceOutstanding < paymentUnallocated
        ? invoiceOutstanding
        : paymentUnallocated;
    return m < 0 ? 0 : m;
  }

  /// Returns an error message when [amount] cannot be allocated.
  static String? validate({
    required int amount,
    required int invoiceOutstanding,
    required int paymentUnallocated,
  }) {
    if (amount <= 0) return 'Amount must be more than zero';
    if (amount > invoiceOutstanding) {
      return 'Amount is more than the invoice balance';
    }
    if (amount > paymentUnallocated) {
      return 'Amount is more than the unused part of this payment';
    }
    return null;
  }
}
