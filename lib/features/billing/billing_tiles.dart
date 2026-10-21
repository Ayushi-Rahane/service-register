import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/repositories/billing_repository.dart';
import '../../domain/enums.dart';

class InvoiceTile extends StatelessWidget {
  const InvoiceTile(this.item, {super.key, this.showCompany = true});
  final InvoiceListItem item;
  final bool showCompany;

  @override
  Widget build(BuildContext context) {
    final i = item.invoice;
    final b = item.balance;
    final due = i.dueDate == null ? '' : ' • due ${Dates.display(i.dueDate)}';
    return ListTile(
      onTap: () => context.push('/invoice/${i.id}'),
      title: Text(
        showCompany ? item.companyName : i.invoiceNo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${showCompany ? '${i.invoiceNo} • ' : ''}${Dates.display(i.invoiceDate)}$due',
        maxLines: 2,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(Money.short(i.totalPaise), style: context.text.titleSmall),
          const SizedBox(height: 2),
          if (b.status == PaymentStatus.partiallyPaid ||
              (b.status == PaymentStatus.overdue && b.paid > 0))
            Text(
              'Due ${Money.short(b.outstanding)}',
              style: context.text.labelSmall,
            )
          else
            StatusChip.payment(b.status),
          if (b.status == PaymentStatus.partiallyPaid ||
              (b.status == PaymentStatus.overdue && b.paid > 0))
            StatusChip.payment(b.status),
        ],
      ),
    );
  }
}

class PaymentTile extends StatelessWidget {
  const PaymentTile(this.item, {super.key, this.showCompany = true});
  final PaymentListItem item;
  final bool showCompany;

  @override
  Widget build(BuildContext context) {
    final p = item.payment;
    final voided = p.voidedAt != null;
    final applied = item.invoiceNos ?? 'Advance / credit';
    return ListTile(
      onTap: () => context.push('/payment/${p.id}'),
      leading: CircleAvatar(
        backgroundColor: voided
            ? context.status.neutral
            : context.status.success,
        child: Icon(
          _icon(PaymentMethod.fromDb(p.method)),
          color: voided ? context.status.onNeutral : context.status.onSuccess,
        ),
      ),
      title: Text(
        showCompany ? item.companyName : p.receiptNo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${Dates.display(p.paidOn)} • ${PaymentMethod.fromDb(p.method).label}\n'
        '${showCompany ? '${p.receiptNo} • ' : ''}$applied',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Money.short(p.amountPaise),
            style: context.text.titleSmall?.copyWith(
              decoration: voided ? TextDecoration.lineThrough : null,
              color: voided
                  ? context.colors.onSurfaceVariant
                  : context.status.onSuccess,
            ),
          ),
          if (voided) const StatusChip('Void', Tone.neutral),
          if (!voided && item.unallocated > 0)
            Text(
              'Credit ${Money.short(item.unallocated)}',
              style: context.text.labelSmall,
            ),
        ],
      ),
    );
  }

  static IconData _icon(PaymentMethod m) => switch (m) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.upi => Icons.qr_code_2,
    PaymentMethod.bankTransfer => Icons.account_balance_outlined,
    PaymentMethod.cheque => Icons.edit_note,
    PaymentMethod.other => Icons.currency_rupee,
  };
}
