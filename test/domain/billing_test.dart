import 'package:flutter_test/flutter_test.dart';
import 'package:service_register/core/utils/money.dart';
import 'package:service_register/core/utils/quantity.dart';
import 'package:service_register/domain/billing.dart';
import 'package:service_register/domain/duplicates.dart';
import 'package:service_register/domain/enums.dart';
import 'package:service_register/domain/numbering.dart';

void main() {
  group('Money', () {
    test('formats with Indian grouping and ₹', () {
      expect(Money.format(12345678), '₹1,23,456.78');
      expect(Money.format(0), '₹0.00');
      expect(Money.format(-150050), '-₹1,500.50');
      expect(Money.format(1000000000), '₹1,00,00,000.00');
      expect(Money.short(150000), '₹1,500');
    });

    test('parses user input without floating point', () {
      expect(Money.parse('1,500'), 150000);
      expect(Money.parse('₹ 1500.5'), 150050);
      expect(Money.parse('0.1'), 10);
      expect(Money.parse('.75'), 75);
      expect(Money.parse(''), isNull);
      expect(() => Money.parse('12.345'), throwsFormatException);
      expect(() => Money.parse('abc'), throwsFormatException);
      // 0.1 + 0.2 style errors cannot happen with integer paise.
      expect(Money.parse('0.1')! + Money.parse('0.2')!, Money.parse('0.3'));
    });
  });

  group('Qty', () {
    test('parses and formats thousandths', () {
      expect(Qty.parse('2'), 2000);
      expect(Qty.parse('1.5'), 1500);
      expect(Qty.parse('0.125'), 125);
      expect(Qty.format(1500), '1.5');
      expect(Qty.format(2000), '2');
      expect(Qty.format(125), '0.125');
      expect(() => Qty.parse('1.2345'), throwsFormatException);
    });
  });

  group('Invoice totals', () {
    test('line totals round half-up to the paisa', () {
      expect(Billing.lineTotal(1000, 12345), 12345);
      expect(Billing.lineTotal(1500, 1001), 1502); // 1501.5 -> 1502
      expect(Billing.lineTotal(333, 100), 33);
    });

    test('labour + parts + travel - discount + tax', () {
      final c = ChargeBreakdown.fromLines(
        [
          (kind: InvoiceItemKind.labour, amount: 150000),
          (kind: InvoiceItemKind.part, amount: 45000),
          (kind: InvoiceItemKind.part, amount: 5000),
          (kind: InvoiceItemKind.travel, amount: 20000),
        ],
        discount: 20000,
        taxRateBp: 1800,
      );
      expect(c.subtotal, 220000);
      expect(c.taxable, 200000);
      expect(c.tax, 36000);
      expect(c.total, 236000);
      expect(c.validate(), isNull);
    });

    test('tax is optional and discount cannot exceed charges', () {
      const c = ChargeBreakdown(
        labour: 100000,
        parts: 0,
        travel: 0,
        other: 0,
        discount: 0,
        taxRateBp: 0,
      );
      expect(c.total, 100000);
      const bad = ChargeBreakdown(
        labour: 100,
        parts: 0,
        travel: 0,
        other: 0,
        discount: 200,
        taxRateBp: 0,
      );
      expect(bad.validate(), isNotNull);
      expect(bad.total, 0);
    });

    test('rate parsing', () {
      expect(Billing.parseRate('18'), 1800);
      expect(Billing.parseRate('12.5'), 1250);
      expect(Billing.parseRate('abc'), isNull);
      expect(Billing.rateLabel(1250), '12.5');
      expect(Billing.rateLabel(1800), '18');
    });
  });

  group('Payment status', () {
    InvoiceBalance b(
      int paid, {
      String? due = '2026-10-20',
      String today = '2026-10-16',
    }) => InvoiceBalance(total: 100000, paid: paid, dueDate: due, today: today);

    test('unpaid, partial, paid', () {
      expect(b(0).status, PaymentStatus.unpaid);
      expect(b(40000).status, PaymentStatus.partiallyPaid);
      expect(b(40000).outstanding, 60000);
      expect(b(100000).status, PaymentStatus.paid);
    });

    test('a partial payment is never treated as paid', () {
      expect(b(99999).status, isNot(PaymentStatus.paid));
      expect(b(99999).outstanding, 1);
    });

    test('overdue is derived from due date and balance', () {
      expect(b(0, today: '2026-10-21').status, PaymentStatus.overdue);
      expect(b(50000, today: '2026-10-21').status, PaymentStatus.overdue);
      expect(b(0, today: '2026-10-20').status, PaymentStatus.unpaid);
      expect(b(100000, today: '2026-12-01').status, PaymentStatus.paid);
      expect(b(0, due: null, today: '2027-01-01').status, PaymentStatus.unpaid);
      expect(b(0, today: '2026-10-25').daysOverdue(), 5);
    });

    test('cancelled invoices have no balance', () {
      const c = InvoiceBalance(
        total: 100,
        paid: 0,
        dueDate: null,
        today: '2026-01-01',
        cancelled: true,
      );
      expect(c.status, PaymentStatus.cancelled);
      expect(c.outstanding, 0);
    });

    test('allocation limits', () {
      expect(
        Allocation.maxAllocatable(
          invoiceOutstanding: 500,
          paymentUnallocated: 800,
        ),
        500,
      );
      expect(
        Allocation.validate(
          amount: 600,
          invoiceOutstanding: 500,
          paymentUnallocated: 800,
        ),
        isNotNull,
      );
      expect(
        Allocation.validate(
          amount: 0,
          invoiceOutstanding: 500,
          paymentUnallocated: 800,
        ),
        isNotNull,
      );
      expect(
        Allocation.validate(
          amount: 500,
          invoiceOutstanding: 500,
          paymentUnallocated: 800,
        ),
        isNull,
      );
    });
  });

  group('Numbering', () {
    test('continues from the highest existing number in the series', () {
      final d = DateTime(2026, 10, 16);
      expect(DocNumbers.next('INV', d, []), 'INV-2627-0001');
      expect(
        DocNumbers.next('INV', d, [
          'INV-2627-0007',
          'INV-2627-0003',
          'INV-2526-0099',
        ]),
        'INV-2627-0008',
      );
      expect(
        DocNumbers.next('inv', DateTime(2027, 3, 31), ['INV-2627-0008']),
        'INV-2627-0009',
      );
      expect(
        DocNumbers.next('INV', DateTime(2027, 4, 1), ['INV-2627-0008']),
        'INV-2728-0001',
      );
      expect(DocNumbers.nextCompanyCode(['C-0002', null, 'X']), 'C-0003');
    });
  });

  group('Duplicate detection', () {
    test('similar names and same phones', () {
      expect(
        Duplicates.similarName(
          'Shree Electronics Pvt. Ltd.',
          'shree electronics',
        ),
        isTrue,
      );
      expect(
        Duplicates.similarName('Shree Electronic', 'Shree Electronics'),
        isTrue,
      );
      expect(
        Duplicates.similarName('Alpha Circuits', 'Beta Plastics'),
        isFalse,
      );
      expect(Duplicates.samePhone('+91 98220 12345', '09822012345'), isTrue);
      expect(Duplicates.samePhone('98220 12345', '98220 12346'), isFalse);
    });
  });
}
