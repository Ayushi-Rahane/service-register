import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../data/repositories/billing_repository.dart';
import '../../domain/drafts.dart';
import '../../domain/enums.dart';
import '../companies/company_picker.dart';

/// Records money received. It can be applied to one or more invoices
/// (instalments) and any remainder is kept as advance / credit.
class PaymentFormScreen extends ConsumerStatefulWidget {
  const PaymentFormScreen({super.key, this.companyId, this.invoiceId});
  final String? companyId;
  final String? invoiceId;

  @override
  ConsumerState<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends ConsumerState<PaymentFormScreen> {
  final _form = GlobalKey<FormState>();
  final _id = Ids.newId(); // fixed: a double tap cannot record two payments
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _notes = TextEditingController();
  final _alloc = <String, TextEditingController>{};
  String? _companyId;
  String _date = Dates.today();
  PaymentMethod _method = PaymentMethod.cash;
  List<InvoiceListItem> _open = [];
  bool _loading = true, _saving = false;

  @override
  void initState() {
    super.initState();
    _companyId = widget.companyId;
    _init();
  }

  Future<void> _init() async {
    if (widget.invoiceId != null) {
      final inv = await ref
          .read(billingRepositoryProvider)
          .getInvoice(widget.invoiceId!);
      _companyId ??= inv?.invoice.companyId;
    }
    await _loadOpen();
    if (widget.invoiceId != null) {
      final inv = _open
          .where((i) => i.invoice.id == widget.invoiceId)
          .firstOrNull;
      if (inv != null) {
        _amount.text = Money.editable(inv.balance.outstanding);
        _alloc[inv.invoice.id]!.text = Money.editable(inv.balance.outstanding);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadOpen() async {
    for (final c in _alloc.values) {
      c.dispose();
    }
    _alloc.clear();
    _open = _companyId == null
        ? []
        : await ref.read(billingRepositoryProvider).openInvoices(_companyId!);
    for (final i in _open) {
      _alloc[i.invoice.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in [_amount, _reference, _notes, ..._alloc.values]) {
      c.dispose();
    }
    super.dispose();
  }

  int get _amountPaise => Money.tryParse(_amount.text) ?? 0;
  int get _applied =>
      _alloc.values.fold(0, (s, c) => s + (Money.tryParse(c.text) ?? 0));

  /// Applies the amount to the oldest invoices first.
  void _autoApply() {
    var left = _amountPaise;
    for (final i in _open) {
      final a = left < i.balance.outstanding ? left : i.balance.outstanding;
      _alloc[i.invoice.id]!.text = Money.editable(a > 0 ? a : 0);
      left -= a > 0 ? a : 0;
    }
    setState(() {});
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    final amount = _amountPaise;
    final applied = _applied;
    if (applied > amount) {
      showMessage(
        context,
        'Applied amounts (${Money.format(applied)}) are more than the amount received',
        error: true,
      );
      return;
    }
    if (applied < amount) {
      final ok = await confirmDialog(
        context,
        title: 'Keep ${Money.format(amount - applied)} as advance?',
        message:
            'This part is not applied to any invoice. It will be kept as credit for this company and can be applied later.',
        confirmLabel: 'Yes, save',
      );
      if (!ok) return;
    }
    setState(() => _saving = true);
    try {
      final p = await ref
          .read(billingRepositoryProvider)
          .recordPayment(
            PaymentDraft(
              id: _id,
              companyId: _companyId!,
              paidOn: _date,
              amountPaise: amount,
              method: _method,
              reference: _reference.text,
              notes: _notes.text,
              allocations: {
                for (final e in _alloc.entries)
                  if ((Money.tryParse(e.value.text) ?? 0) > 0)
                    e.key: Money.tryParse(e.value.text)!,
              },
            ),
            receiptPrefix: ref.read(settingsProvider).receiptPrefix,
            actor: ref.read(actorProvider),
          );
      if (!mounted) return;
      showMessage(context, 'Payment ${p.receiptNo} recorded');
      context.pushReplacement('/payment/${p.id}');
    } catch (e) {
      if (mounted) {
        showMessage(context, errorText(e), error: true);
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(), body: const LoadingView());
    final amount = _amountPaise, applied = _applied;
    return Scaffold(
      appBar: AppBar(title: const Text('Record payment')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            label: Text(
              'Save payment${amount > 0 ? ' • ${Money.format(amount)}' : ''}',
            ),
          ),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(Gap.lg),
          children: [
            CompanyField(
              companyId: _companyId,
              enabled: widget.companyId == null && widget.invoiceId == null,
              onChanged: (id) async {
                _companyId = id;
                await _loadOpen();
                setState(() {});
              },
            ),
            MoneyField(
              controller: _amount,
              label: 'Amount received',
              required: true,
              allowZero: false,
              autofocus: widget.invoiceId == null,
              onChanged: (_) => setState(() {}),
            ),
            DateField(
              label: 'Payment date',
              required: true,
              value: _date,
              lastDate: DateTime.now().add(const Duration(days: 1)),
              onChanged: (v) => setState(() => _date = v ?? _date),
            ),
            Text('Payment method', style: context.text.labelLarge),
            const SizedBox(height: Gap.sm),
            ChoiceChips<PaymentMethod>(
              options: PaymentMethod.values,
              selected: _method,
              labelOf: (m) => m.label,
              onSelected: (m) => setState(() => _method = m),
            ),
            const SizedBox(height: Gap.lg),
            AppTextField(
              controller: _reference,
              label: switch (_method) {
                PaymentMethod.upi => 'UPI transaction ID (optional)',
                PaymentMethod.cheque => 'Cheque number (optional)',
                PaymentMethod.bankTransfer => 'UTR / reference (optional)',
                _ => 'Reference (optional)',
              },
              capitalization: TextCapitalization.characters,
            ),
            AppTextField(
              controller: _notes,
              label: 'Notes (optional)',
              maxLines: 2,
              minLines: 1,
            ),
            if (_companyId != null) ...[
              ListHeader(
                'Apply to invoices',
                trailing: _open.isEmpty || amount == 0
                    ? null
                    : TextButton(
                        onPressed: _autoApply,
                        child: const Text('Auto-apply'),
                      ),
              ),
              if (_open.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: Gap.md),
                  child: Text(
                    'No unpaid invoices. The payment will be kept as advance / credit.',
                  ),
                ),
              for (final i in _open)
                Card(
                  margin: const EdgeInsets.only(bottom: Gap.sm),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Gap.md,
                      Gap.md,
                      Gap.md,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                i.invoice.invoiceNo,
                                style: context.text.titleSmall,
                              ),
                            ),
                            Text(
                              'Balance ${Money.format(i.balance.outstanding)}',
                            ),
                          ],
                        ),
                        Text(
                          '${Dates.display(i.invoice.invoiceDate)} • Total ${Money.format(i.invoice.totalPaise)}'
                          '${i.balance.isOverdue ? ' • overdue' : ''}',
                          style: context.text.bodySmall,
                        ),
                        const SizedBox(height: Gap.sm),
                        MoneyField(
                          controller: _alloc[i.invoice.id]!,
                          label: 'Amount for this invoice',
                          max: i.balance.outstanding,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ),
              SectionCard(
                child: Column(
                  children: [
                    AmountLine('Amount received', Money.format(amount)),
                    AmountLine('Applied to invoices', Money.format(applied)),
                    AmountLine(
                      applied > amount
                          ? 'Over-applied'
                          : 'Kept as advance / credit',
                      Money.format((amount - applied).abs()),
                      bold: true,
                      color: applied > amount ? context.colors.error : null,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
