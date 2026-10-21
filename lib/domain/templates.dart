import '../core/utils/dates.dart';
import '../core/utils/money.dart';

/// Fills the editable payment-reminder template. Unknown placeholders are left
/// as they are so a typo is visible rather than silently dropped.
abstract final class MessageTemplates {
  static const placeholders = {
    '{contact}': 'Contact person or company name',
    '{company}': 'Company name',
    '{invoice_no}': 'Invoice number',
    '{invoice_date}': 'Invoice date',
    '{amount}': 'Invoice total',
    '{balance}': 'Balance due',
    '{due_date}': 'Due date',
    '{due_text}': '", due on <date>" or ", overdue since <date>"',
    '{business}': 'Your business name',
    '{upi}': 'Your UPI ID',
  };

  static String paymentReminder({
    required String template,
    required String companyName,
    String? contactPerson,
    required String invoiceNo,
    required String invoiceDate,
    required int totalPaise,
    required int balancePaise,
    String? dueDate,
    required String today,
    required String businessName,
    String upiId = '',
  }) {
    final dueText = dueDate == null
        ? ''
        : (dueDate.compareTo(today) < 0
              ? ', overdue since ${Dates.display(dueDate)}'
              : ', due on ${Dates.display(dueDate)}');
    final values = {
      '{contact}': (contactPerson?.trim().isNotEmpty ?? false)
          ? contactPerson!.trim()
          : companyName,
      '{company}': companyName,
      '{invoice_no}': invoiceNo,
      '{invoice_date}': Dates.display(invoiceDate),
      '{amount}': Money.format(totalPaise),
      '{balance}': Money.format(balancePaise),
      '{due_date}': dueDate == null ? '' : Dates.display(dueDate),
      '{due_text}': dueText,
      '{business}': businessName,
      '{upi}': upiId,
    };
    var out = template;
    values.forEach((k, v) => out = out.replaceAll(k, v));
    if (upiId.isNotEmpty && !template.contains('{upi}')) {
      out = '$out\n\nUPI: $upiId';
    }
    return out;
  }
}
