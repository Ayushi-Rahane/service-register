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
import '../../core/widgets/form_fields.dart';
import '../../data/local/app_database.dart';
import '../../domain/billing.dart';
import '../../domain/drafts.dart';
import '../../domain/enums.dart';
import '../companies/company_picker.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  const InvoiceFormScreen({
    super.key,
    this.id,
    this.companyId,
    this.visitIds = const [],
  });
  final String? id;
  final String? companyId;
  final List<String> visitIds;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  final _form = GlobalKey<FormState>();
  final _discount = TextEditingController();
  final _taxRate = TextEditingController();
  final _notes = TextEditingController();
  late InvoiceDraft _d;
  List<ServiceVisit> _available = [];
  String? _invoiceNo;
  int _paid = 0;
  bool _taxOn = false, _loading = true, _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = ref.read(settingsProvider);
    final billing = ref.read(billingRepositoryProvider);
    try {
      if (widget.id != null) {
        final inv = (await billing.getInvoice(widget.id!))!;
        final items = await billing.items(widget.id!);
        final visits = await billing.watchInvoiceVisits(widget.id!).first;
        _invoiceNo = inv.invoice.invoiceNo;
        _paid = inv.balance.paid;
        _d = InvoiceDraft(
          id: inv.invoice.id,
          companyId: inv.invoice.companyId,
          invoiceDate: inv.invoice.invoiceDate,
          dueDate: inv.invoice.dueDate,
          discountPaise: inv.invoice.discountPaise,
          taxLabel: inv.invoice.taxLabel,
          taxRateBp: inv.invoice.taxRateBp,
          notes: inv.invoice.notes,
          lines: [
            for (final it in items)
              InvoiceLineDraft(
                id: it.id,
                kind: InvoiceItemKind.fromDb(it.kind),
                description: it.description,
                qtyMilli: it.qtyMilli,
                unitPricePaise: it.unitPricePaise,
                visitId: it.visitId,
              ),
          ],
          visitIds: visits.map((v) => v.id).toSet(),
        );
      } else if (widget.visitIds.isNotEmpty) {
        _d = await billing.draftFromVisits(widget.visitIds, settings);
      } else {
        final today = Dates.today();
        _d = InvoiceDraft(
          companyId: widget.companyId ?? '',
          invoiceDate: today,
          dueDate: Dates.addDays(today, settings.defaultDueDays),
          notes: settings.invoiceTerms,
          taxLabel: settings.taxLabel,
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, errorText(e), error: true);
      _d = InvoiceDraft(
        companyId: widget.companyId ?? '',
        invoiceDate: Dates.today(),
      );
    }
    _taxOn = _d.taxRateBp > 0;
    _discount.text = Money.editable(_d.discountPaise);
    _taxRate.text = Billing.rateLabel(
      _d.taxRateBp > 0 ? _d.taxRateBp : settings.defaultTaxRateBp,
    );
    _notes.text = _d.notes ?? '';
    await _loadAvailable();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadAvailable() async {
    if (_d.companyId.isEmpty) {
      _available = [];
      return;
    }
    final uninvoiced = await ref
        .read(visitRepositoryProvider)
        .uninvoicedVisits(_d.companyId);
    final linked = <ServiceVisit>[];
    for (final id in _d.visitIds) {
      final v = await ref.read(visitRepositoryProvider).get(id);
      if (v != null && !uninvoiced.any((u) => u.id == id)) linked.add(v);
    }
    _available = [...linked, ...uninvoiced]
      ..sort((a, b) => a.visitDate.compareTo(b.visitDate));
  }

  @override
  void dispose() {
    _discount.dispose();
    _taxRate.dispose();
    _notes.dispose();
    super.dispose();
  }

  /// Re-builds the visit-generated lines after the visit selection changed.
  Future<void> _toggleVisit(ServiceVisit v, bool selected) async {
    final settings = ref.read(settingsProvider);
    if (selected) {
      _d.visitIds.add(v.id);
    } else {
      _d.visitIds.remove(v.id);
    }
    _d.lines.removeWhere((l) => l.visitId != null);
    if (_d.visitIds.isNotEmpty) {
      final generated = await ref
          .read(billingRepositoryProvider)
          .draftFromVisits(_d.visitIds.toList(), settings);
      _d.lines.insertAll(0, generated.lines);
      _discount.text = Money.editable(generated.discountPaise);
      if (generated.taxRateBp > 0) {
        _taxOn = true;
        _taxRate.text = Billing.rateLabel(generated.taxRateBp);
      }
    }
    setState(() {});
  }

  void _collect() {
    _d
      ..discountPaise = Money.tryParse(_discount.text) ?? 0
      ..taxRateBp = _taxOn ? (Billing.parseRate(_taxRate.text) ?? 0) : 0
      ..taxLabel = _taxOn
          ? (_d.taxLabel ?? ref.read(settingsProvider).taxLabel)
          : null
      ..notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    _collect();
    if (_d.lines.isEmpty) {
      showMessage(context, 'Add at least one item', error: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final inv = await ref
          .read(billingRepositoryProvider)
          .saveInvoice(
            _d,
            invoicePrefix: ref.read(settingsProvider).invoicePrefix,
            actor: ref.read(actorProvider),
          );
      if (!mounted) return;
      showMessage(
        context,
        widget.id == null
            ? 'Invoice ${inv.invoiceNo} created'
            : 'Invoice updated',
      );
      if (widget.id == null) {
        context.pushReplacement('/invoice/${inv.id}');
      } else {
        context.pop();
      }
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
    _collect();
    final c = _d.charges;
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'New invoice' : 'Edit $_invoiceNo'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            label: Text('Save invoice • ${Money.format(c.total)}'),
          ),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(Gap.lg),
          children: [
            if (widget.id != null && _paid > 0) ...[
              NoticeBanner(
                message:
                    '${Money.format(_paid)} has already been paid. The total cannot go below that.',
              ),
              const SizedBox(height: Gap.md),
            ],
            CompanyField(
              companyId: _d.companyId.isEmpty ? null : _d.companyId,
              enabled: widget.id == null,
              onChanged: (id) async {
                _d
                  ..companyId = id
                  ..visitIds.clear()
                  ..lines.removeWhere((l) => l.visitId != null);
                await _loadAvailable();
                setState(() {});
              },
            ),
            Row(
              children: [
                Expanded(
                  child: DateField(
                    label: 'Invoice date',
                    required: true,
                    value: _d.invoiceDate,
                    onChanged: (v) =>
                        setState(() => _d.invoiceDate = v ?? _d.invoiceDate),
                  ),
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: DateField(
                    label: 'Due date',
                    value: _d.dueDate,
                    allowClear: true,
                    onChanged: (v) => setState(() => _d.dueDate = v),
                  ),
                ),
              ],
            ),
            if (_available.isNotEmpty) ...[
              const ListHeader('Completed visits to bill'),
              Card(
                child: Column(
                  children: [
                    for (final v in _available)
                      CheckboxListTile(
                        value: _d.visitIds.contains(v.id),
                        onChanged: (s) => _toggleVisit(v, s ?? false),
                        title: Text(
                          '${v.visitNo} • ${Dates.display(v.visitDate)}',
                        ),
                        subtitle: Text(
                          '${ServiceType.fromDb(v.serviceType).label} • ${Money.format(v.totalPaise)}',
                        ),
                      ),
                  ],
                ),
              ),
            ],
            ListHeader(
              'Items',
              trailing: TextButton.icon(
                onPressed: () async {
                  final line = await _editLine(
                    context,
                    InvoiceLineDraft(description: ''),
                    isNew: true,
                  );
                  if (line != null) setState(() => _d.lines.add(line));
                },
                icon: const Icon(Icons.add),
                label: const Text('Add item'),
              ),
            ),
            if (_d.lines.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: Gap.md),
                child: Text('No items yet. Select visits above or add items.'),
              ),
            for (var i = 0; i < _d.lines.length; i++)
              Card(
                margin: const EdgeInsets.only(bottom: Gap.sm),
                child: ListTile(
                  onTap: () async {
                    await _editLine(context, _d.lines[i]);
                    setState(() {});
                  },
                  title: Text(_d.lines[i].description),
                  subtitle: Text(
                    '${_d.lines[i].kind.label} • ${Qty.format(_d.lines[i].qtyMilli)} × ${Money.format(_d.lines[i].unitPricePaise)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Money.format(_d.lines[i].amount)),
                      IconButton(
                        tooltip: 'Remove',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() => _d.lines.removeAt(i)),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: Gap.md),
            MoneyField(
              controller: _discount,
              label: 'Discount',
              onChanged: (_) => setState(() {}),
              max: c.subtotal,
            ),
            if (settings.taxEnabled || _taxOn) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _taxOn,
                title: Text('Add ${_d.taxLabel ?? settings.taxLabel}'),
                subtitle: const Text(
                  'Turn off for customers billed without tax',
                ),
                onChanged: (v) => setState(() => _taxOn = v),
              ),
              if (_taxOn)
                AppTextField(
                  controller: _taxRate,
                  label: 'Tax rate (%)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (v) => Billing.parseRate(v) == null
                      ? 'Enter a rate between 0 and 100'
                      : null,
                ),
            ],
            SectionCard(
              child: Column(
                children: [
                  AmountLine('Subtotal', Money.format(c.subtotal)),
                  if (c.appliedDiscount > 0)
                    AmountLine(
                      'Discount',
                      '- ${Money.format(c.appliedDiscount)}',
                    ),
                  if (c.tax > 0)
                    AmountLine(
                      'Tax @ ${Billing.rateLabel(c.taxRateBp)}%',
                      Money.format(c.tax),
                    ),
                  AmountLine('Total', Money.format(c.total), bold: true),
                ],
              ),
            ),
            const SizedBox(height: Gap.md),
            AppTextField(
              controller: _notes,
              label: 'Notes / terms printed on invoice',
              maxLines: 3,
              minLines: 1,
            ),
            Text(
              'Check tax and invoice requirements with your accountant. This app does not certify legal compliance.',
              style: context.text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

Future<InvoiceLineDraft?> _editLine(
  BuildContext context,
  InvoiceLineDraft l, {
  bool isNew = false,
}) {
  final form = GlobalKey<FormState>();
  final desc = TextEditingController(text: l.description);
  final qty = TextEditingController(text: Qty.format(l.qtyMilli));
  final price = TextEditingController(text: Money.editable(l.unitPricePaise));
  var kind = l.kind;
  return showDialog<InvoiceLineDraft>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(isNew ? 'Add item' : 'Edit item'),
        scrollable: true,
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EnumDropdown<InvoiceItemKind>(
                label: 'Type',
                values: InvoiceItemKind.values,
                value: kind,
                onChanged: (v) => setState(() => kind = v ?? kind),
              ),
              AppTextField(
                controller: desc,
                label: 'Description',
                required: true,
                maxLines: 2,
                minLines: 1,
                autofocus: isNew,
              ),
              QtyField(controller: qty),
              MoneyField(controller: price, label: 'Rate'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!form.currentState!.validate()) return;
              l
                ..kind = kind
                ..description = desc.text.trim()
                ..qtyMilli = Qty.parse(qty.text)!
                ..unitPricePaise = Money.parse(price.text) ?? 0;
              Navigator.pop(ctx, l);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}
