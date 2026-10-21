import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/repositories/billing_repository.dart';
import '../../domain/billing.dart';
import '../../domain/enums.dart';
import '../../services/document_service.dart';
import '../providers.dart';

class PaymentDetailScreen extends ConsumerWidget {
  const PaymentDetailScreen({super.key, required this.id});
  final String id;

  Future<void> _receipt(
    BuildContext context,
    WidgetRef ref, {
    bool share = false,
  }) async {
    try {
      final doc = await ref
          .read(documentServiceProvider)
          .receipt(id, ref.read(settingsProvider));
      if (!context.mounted) return;
      share
          ? await DocumentService.share(doc)
          : await context.push('/pdf', extra: doc);
    } catch (e) {
      if (context.mounted) showMessage(context, errorText(e), error: true);
    }
  }

  Future<void> _apply(
    BuildContext context,
    WidgetRef ref,
    PaymentListItem p,
  ) async {
    final billing = ref.read(billingRepositoryProvider);
    final open = await billing.openInvoices(p.payment.companyId);
    if (!context.mounted) return;
    if (open.isEmpty) {
      showMessage(context, 'No unpaid invoices for this company');
      return;
    }
    final inv = await showActionSheet<InvoiceListItem>(
      context,
      title: 'Apply ${Money.format(p.unallocated)} to',
      actions: [
        for (final i in open)
          (
            icon: Icons.receipt_long,
            label:
                '${i.invoice.invoiceNo} • balance ${Money.format(i.balance.outstanding)}',
            value: i,
          ),
      ],
    );
    if (inv == null || !context.mounted) return;
    await runGuarded(
      context,
      () => billing.applyCredit(
        paymentId: id,
        invoiceId: inv.invoice.id,
        amount: Allocation.maxAllocatable(
          invoiceOutstanding: inv.balance.outstanding,
          paymentUnallocated: p.unallocated,
        ),
        actor: ref.read(actorProvider),
      ),
      success: 'Applied to ${inv.invoice.invoiceNo}',
    );
  }

  Future<void> _editDetails(
    BuildContext context,
    WidgetRef ref,
    PaymentListItem p,
  ) async {
    final reference = TextEditingController(text: p.payment.reference ?? '');
    final notes = TextEditingController(text: p.payment.notes ?? '');
    var method = PaymentMethod.fromDb(p.payment.method);
    var date = p.payment.paidOn;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Edit payment details'),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'The amount cannot be changed. To correct it, void this payment and record a new one.',
              ),
              const SizedBox(height: Gap.md),
              DateField(
                label: 'Payment date',
                value: date,
                onChanged: (v) => setState(() => date = v ?? date),
              ),
              EnumDropdown<PaymentMethod>(
                label: 'Method',
                values: PaymentMethod.values,
                value: method,
                onChanged: (v) => setState(() => method = v ?? method),
              ),
              AppTextField(controller: reference, label: 'Reference'),
              AppTextField(
                controller: notes,
                label: 'Notes',
                maxLines: 2,
                minLines: 1,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (ok == true && context.mounted) {
      await runGuarded(
        context,
        () => ref
            .read(billingRepositoryProvider)
            .updatePaymentDetails(
              id,
              paidOn: date,
              method: method,
              reference: reference.text,
              notes: notes.text,
              actor: ref.read(actorProvider),
            ),
        success: 'Saved',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(paymentProvider(id)),
    builder: (p) {
      if (p == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const EmptyState(
            icon: Icons.search_off,
            title: 'Payment not found',
          ),
        );
      }
      final pay = p.payment;
      final voided = pay.voidedAt != null;
      final allocs =
          ref.watch(paymentAllocationsProvider(id)).value ??
          const <AllocationRow>[];
      return Scaffold(
        appBar: AppBar(
          title: Text(pay.receiptNo),
          actions: [
            IconButton(
              tooltip: 'Receipt PDF',
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () => _receipt(context, ref),
            ),
            if (!voided)
              PopupMenuButton<String>(
                onSelected: (a) async {
                  if (a == 'edit') await _editDetails(context, ref, p);
                  if (a == 'void' && context.mounted) {
                    final reason = await promptText(
                      context,
                      title: 'Void this payment?',
                      message:
                          'Use this if the payment was entered by mistake or a cheque bounced. '
                          'The invoices it was applied to become unpaid again. The record is kept.',
                      confirmLabel: 'Void payment',
                      destructive: true,
                      required: true,
                    );
                    if (reason != null && context.mounted) {
                      await runGuarded(
                        context,
                        () => ref
                            .read(billingRepositoryProvider)
                            .voidPayment(
                              id,
                              reason,
                              actor: ref.read(actorProvider),
                            ),
                        success: 'Payment voided',
                      );
                    }
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit details')),
                  PopupMenuItem(value: 'void', child: Text('Void payment')),
                ],
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
            child: FilledButton.icon(
              onPressed: () => _receipt(context, ref, share: true),
              icon: const Icon(Icons.share),
              label: const Text('Share receipt'),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(Gap.lg),
          children: [
            SectionCard(
              title: p.companyName,
              icon: Icons.apartment,
              trailing: voided
                  ? const StatusChip('Void', Tone.neutral)
                  : const StatusChip('Received', Tone.success),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Money.format(pay.amountPaise),
                    style: context.text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      decoration: voided ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  InfoRow('Date', Dates.display(pay.paidOn)),
                  InfoRow('Method', PaymentMethod.fromDb(pay.method).label),
                  InfoRow('Reference', pay.reference),
                  InfoRow('Notes', pay.notes),
                  if (voided)
                    NoticeBanner(
                      message:
                          'Voided${pay.voidReason == null ? '' : ': ${pay.voidReason}'}',
                      danger: true,
                    ),
                  TextButton.icon(
                    onPressed: () => context.push('/company/${pay.companyId}'),
                    icon: const Icon(Icons.apartment, size: 18),
                    label: const Text('Open company'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Gap.md),
            SectionCard(
              title: 'Applied to invoices',
              icon: Icons.receipt_long,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (allocs.isEmpty) const Text('Not applied to any invoice'),
                  for (final a in allocs)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(a.invoiceNo),
                      trailing: Text(Money.format(a.allocation.amountPaise)),
                      onTap: () =>
                          context.push('/invoice/${a.allocation.invoiceId}'),
                    ),
                  if (!voided && p.unallocated > 0) ...[
                    const Divider(),
                    AmountLine(
                      'Unused advance / credit',
                      Money.format(p.unallocated),
                      bold: true,
                    ),
                    const SizedBox(height: Gap.sm),
                    OutlinedButton.icon(
                      onPressed: () => _apply(context, ref, p),
                      icon: const Icon(Icons.call_split),
                      label: const Text('Apply to an invoice'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
