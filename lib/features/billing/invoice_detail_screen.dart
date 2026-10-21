import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/repositories/billing_repository.dart';
import '../../domain/billing.dart';
import '../../domain/enums.dart';
import '../../services/document_service.dart';
import '../providers.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({super.key, required this.id});
  final String id;

  Future<void> _pdf(
    BuildContext context,
    WidgetRef ref, {
    bool share = false,
  }) async {
    try {
      final doc = await ref
          .read(documentServiceProvider)
          .invoice(id, ref.read(settingsProvider));
      if (!context.mounted) return;
      if (share) {
        await DocumentService.share(doc);
      } else {
        await context.push('/pdf', extra: doc);
      }
    } catch (e) {
      if (context.mounted) showMessage(context, errorText(e), error: true);
    }
  }

  Future<void> _applyCredit(
    BuildContext context,
    WidgetRef ref,
    InvoiceListItem inv,
  ) async {
    final billing = ref.read(billingRepositoryProvider);
    final credits = await billing.creditPayments(inv.invoice.companyId);
    if (!context.mounted) return;
    if (credits.isEmpty) {
      showMessage(context, 'This company has no unused advance or credit');
      return;
    }
    final payment = await showActionSheet<PaymentListItem>(
      context,
      title: 'Use advance / credit from',
      actions: [
        for (final c in credits)
          (
            icon: Icons.savings_outlined,
            label:
                '${c.payment.receiptNo} • ${Dates.display(c.payment.paidOn)} • ${Money.format(c.unallocated)} unused',
            value: c,
          ),
      ],
    );
    if (payment == null || !context.mounted) return;
    final amount = Allocation.maxAllocatable(
      invoiceOutstanding: inv.balance.outstanding,
      paymentUnallocated: payment.unallocated,
    );
    final ok = await confirmDialog(
      context,
      title: 'Apply ${Money.format(amount)}?',
      message: 'From ${payment.payment.receiptNo} to ${inv.invoice.invoiceNo}.',
      confirmLabel: 'Apply',
    );
    if (ok && context.mounted) {
      await runGuarded(
        context,
        () => billing.applyCredit(
          paymentId: payment.payment.id,
          invoiceId: id,
          amount: amount,
          actor: ref.read(actorProvider),
        ),
        success: 'Credit applied',
      );
    }
  }

  Future<void> _menu(
    BuildContext context,
    WidgetRef ref,
    String a,
    InvoiceListItem inv,
  ) async {
    switch (a) {
      case 'edit':
        await context.push('/invoice/$id/edit');
      case 'credit':
        await _applyCredit(context, ref, inv);
      case 'reminder':
        await context.push(
          '/reminder/new?companyId=${inv.invoice.companyId}&invoiceId=$id&kind=payment',
        );
      case 'cancel':
        final reason = await promptText(
          context,
          title: 'Cancel invoice?',
          message:
              'The invoice number stays used and the invoice is kept as cancelled. Its visits can be invoiced again.',
          confirmLabel: 'Cancel invoice',
          destructive: true,
          required: true,
        );
        if (reason != null && context.mounted) {
          await runGuarded(
            context,
            () => ref
                .read(billingRepositoryProvider)
                .cancelInvoice(id, reason, actor: ref.read(actorProvider)),
            success: 'Invoice cancelled',
          );
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(invoiceProvider(id)),
    builder: (inv) {
      if (inv == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const EmptyState(
            icon: Icons.search_off,
            title: 'Invoice not found',
          ),
        );
      }
      final i = inv.invoice;
      final b = inv.balance;
      final items = ref.watch(invoiceItemsProvider(id)).value ?? const [];
      final allocs =
          ref.watch(invoiceAllocationsProvider(id)).value ?? const [];
      final visits = ref.watch(invoiceVisitsProvider(id)).value ?? const [];
      final cancelled = i.cancelledAt != null;
      final discount = i.discountPaise.clamp(0, i.subtotalPaise);
      return Scaffold(
        appBar: AppBar(
          title: Text(i.invoiceNo),
          actions: [
            IconButton(
              tooltip: 'Preview / print',
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () => _pdf(context, ref),
            ),
            PopupMenuButton<String>(
              onSelected: (a) => _menu(context, ref, a, inv),
              itemBuilder: (_) => [
                if (!cancelled)
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit invoice'),
                  ),
                if (!cancelled && b.outstanding > 0)
                  const PopupMenuItem(
                    value: 'credit',
                    child: Text('Use advance / credit'),
                  ),
                if (!cancelled && b.outstanding > 0)
                  const PopupMenuItem(
                    value: 'reminder',
                    child: Text('Add follow-up reminder'),
                  ),
                if (!cancelled && b.paid == 0)
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Cancel invoice'),
                  ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: cancelled
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.lg,
                    Gap.sm,
                    Gap.lg,
                    Gap.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pdf(context, ref, share: true),
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                      ),
                      if (b.outstanding > 0) ...[
                        const SizedBox(width: Gap.md),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => context.push(
                              '/payment/new?companyId=${i.companyId}&invoiceId=$id',
                            ),
                            icon: const Icon(Icons.currency_rupee),
                            label: const Text('Record payment'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
        body: ListView(
          padding: const EdgeInsets.all(Gap.lg),
          children: [
            SectionCard(
              title: inv.companyName,
              icon: Icons.apartment,
              trailing: StatusChip.payment(b.status),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InfoRow(
                          'Invoice date',
                          Dates.display(i.invoiceDate),
                        ),
                      ),
                      Expanded(
                        child: InfoRow(
                          'Due date',
                          i.dueDate == null
                              ? 'Not set'
                              : Dates.display(i.dueDate),
                          showEmpty: true,
                        ),
                      ),
                    ],
                  ),
                  if (cancelled)
                    NoticeBanner(
                      message:
                          'Cancelled${i.cancelReason == null ? '' : ': ${i.cancelReason}'}',
                      danger: true,
                    ),
                  if (b.isOverdue)
                    NoticeBanner(
                      message:
                          'Overdue by ${b.daysOverdue()} day${b.daysOverdue() == 1 ? '' : 's'}',
                      danger: true,
                    ),
                  const Divider(height: Gap.xl),
                  AmountLine(
                    'Invoice total',
                    Money.format(i.totalPaise),
                    bold: true,
                  ),
                  AmountLine(
                    'Paid so far',
                    Money.format(b.paid),
                    color: context.status.onSuccess,
                  ),
                  AmountLine(
                    'Balance due',
                    Money.format(b.outstanding),
                    bold: true,
                    color: b.outstanding > 0 ? context.status.onWarning : null,
                  ),
                  if (!cancelled && b.outstanding > 0) ...[
                    const SizedBox(height: Gap.sm),
                    OutlinedButton.icon(
                      onPressed: () => context.push('/invoice/$id/reminder'),
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text('Send payment reminder'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Gap.md),
            SectionCard(
              title: 'Items',
              icon: Icons.list_alt,
              child: Column(
                children: [
                  for (final it in items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Gap.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(it.description),
                                Text(
                                  '${InvoiceItemKind.fromDb(it.kind).label} • ${Qty.format(it.qtyMilli)} × ${Money.format(it.unitPricePaise)}',
                                  style: context.text.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(Money.format(it.amountPaise)),
                        ],
                      ),
                    ),
                  const Divider(height: Gap.lg),
                  AmountLine('Subtotal', Money.format(i.subtotalPaise)),
                  if (discount > 0)
                    AmountLine('Discount', '- ${Money.format(discount)}'),
                  if (i.taxRateBp > 0)
                    AmountLine(
                      '${i.taxLabel ?? 'Tax'} @ ${Billing.rateLabel(i.taxRateBp)}%',
                      Money.format(i.taxPaise),
                    ),
                  AmountLine('Total', Money.format(i.totalPaise), bold: true),
                ],
              ),
            ),
            if (visits.isNotEmpty) ...[
              const SizedBox(height: Gap.md),
              SectionCard(
                title: 'Service visits',
                icon: Icons.build_outlined,
                child: Column(
                  children: [
                    for (final v in visits)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(v.visitNo),
                        subtitle: Text(Dates.display(v.visitDate)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/visit/${v.id}'),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: Gap.md),
            SectionCard(
              title: 'Payments',
              icon: Icons.payments_outlined,
              child: allocs.isEmpty
                  ? const Text('No payments received yet')
                  : Column(
                      children: [
                        for (final a in allocs)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              '${a.payment.receiptNo} • ${PaymentMethod.fromDb(a.payment.method).label}',
                            ),
                            subtitle: Text(Dates.display(a.payment.paidOn)),
                            trailing: Text(
                              Money.format(a.allocation.amountPaise),
                            ),
                            onTap: () =>
                                context.push('/payment/${a.payment.id}'),
                          ),
                      ],
                    ),
            ),
            if (i.notes != null) ...[
              const SizedBox(height: Gap.md),
              SectionCard(
                title: 'Notes',
                icon: Icons.notes,
                child: Text(i.notes!),
              ),
            ],
          ],
        ),
      );
    },
  );
}
