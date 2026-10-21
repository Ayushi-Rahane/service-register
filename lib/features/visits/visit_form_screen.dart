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
import '../../data/local/app_database.dart';
import '../../data/repositories/visit_repository.dart';
import '../../domain/billing.dart';
import '../../domain/drafts.dart';
import '../../domain/enums.dart';
import '../attachments/attachments_section.dart';
import '../companies/company_picker.dart';
import 'visit_parts_editor.dart';

class VisitFormScreen extends ConsumerStatefulWidget {
  const VisitFormScreen({super.key, this.id, this.companyId, this.machineId});
  final String? id;
  final String? companyId;
  final String? machineId;

  @override
  ConsumerState<VisitFormScreen> createState() => _VisitFormScreenState();
}

class _VisitFormScreenState extends ConsumerState<VisitFormScreen> {
  final _form = GlobalKey<FormState>();
  late VisitDraft _d;
  ServiceVisit? _existing;
  ServiceVisit? _lastMachineVisit;
  String? _invoiceNo;
  bool _loading = true, _saving = false, _dirty = false, _taxOn = false;

  final _t = <String, TextEditingController>{
    for (final k in [
      'technician',
      'reported',
      'symptoms',
      'diagnosis',
      'rootCause',
      'workDone',
      'actions',
      'tests',
      'recommendations',
      'labour',
      'travel',
      'discount',
      'taxRate',
      'onsite',
      'feedback',
      'signedBy',
      'internal',
    ])
      k: TextEditingController(),
  };

  bool get _completed => _existing?.status == VisitStatus.completed.db;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = ref.read(settingsProvider);
    final repo = ref.read(visitRepositoryProvider);
    if (widget.id != null) {
      final v = await repo.get(widget.id!);
      if (v != null) {
        _existing = v;
        _d = VisitRepository.toDraft(v, await repo.parts(v.id));
        if (v.invoiceId != null) {
          _invoiceNo =
              (await ref
                      .read(billingRepositoryProvider)
                      .getInvoice(v.invoiceId!))
                  ?.invoice
                  .invoiceNo;
        }
      }
    }
    if (_existing == null) {
      _d = VisitDraft(
        companyId: widget.companyId ?? '',
        machineId: widget.machineId,
        visitDate: Dates.today(),
        technicianName: settings.technicianName,
        taxRateBp: 0,
      );
    } else if (_d.status == VisitStatus.scheduled &&
        _d.visitDate.compareTo(Dates.today()) <= 0) {
      // Opening a scheduled visit to fill it in means the work has started.
      _d.status = VisitStatus.inProgress;
    }
    _taxOn = _d.taxRateBp > 0;
    _t['technician']!.text = _d.technicianName ?? '';
    _t['reported']!.text = _d.reportedProblem ?? '';
    _t['symptoms']!.text = _d.symptoms ?? '';
    _t['diagnosis']!.text = _d.diagnosis ?? '';
    _t['rootCause']!.text = _d.rootCause ?? '';
    _t['workDone']!.text = _d.workDone ?? '';
    _t['actions']!.text = _d.actionsTaken ?? '';
    _t['tests']!.text = _d.testsPerformed ?? '';
    _t['recommendations']!.text = _d.recommendations ?? '';
    _t['labour']!.text = Money.editable(_d.labourPaise);
    _t['travel']!.text = Money.editable(_d.travelPaise);
    _t['discount']!.text = Money.editable(_d.discountPaise);
    _t['taxRate']!.text = Billing.rateLabel(
      _d.taxRateBp > 0 ? _d.taxRateBp : settings.defaultTaxRateBp,
    );
    _t['onsite']!.text = Money.editable(_d.onsitePaymentPaise);
    _t['feedback']!.text = _d.customerFeedback ?? '';
    _t['signedBy']!.text = _d.signedBy ?? '';
    _t['internal']!.text = _d.internalNotes ?? '';
    for (final c in _t.values) {
      c.addListener(_markDirty);
    }
    await _loadMachineHistory();
    if (mounted) setState(() => _loading = false);
  }

  void _markDirty() {
    if (!_dirty && !_loading) setState(() => _dirty = true);
  }

  Future<void> _loadMachineHistory() async {
    final id = _d.machineId;
    final last = id == null
        ? null
        : await ref.read(visitRepositoryProvider).lastVisitForMachine(id);
    if (mounted) {
      setState(() => _lastMachineVisit = last?.id == _d.id ? null : last);
    }
  }

  @override
  void dispose() {
    for (final c in _t.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? _s(String k) =>
      _t[k]!.text.trim().isEmpty ? null : _t[k]!.text.trim();
  int _m(String k) => Money.tryParse(_t[k]!.text) ?? 0;

  void _collect() {
    _d
      ..technicianName = _s('technician')
      ..reportedProblem = _s('reported')
      ..symptoms = _s('symptoms')
      ..diagnosis = _s('diagnosis')
      ..rootCause = _s('rootCause')
      ..workDone = _s('workDone')
      ..actionsTaken = _s('actions')
      ..testsPerformed = _s('tests')
      ..recommendations = _s('recommendations')
      ..labourPaise = _m('labour')
      ..travelPaise = _m('travel')
      ..discountPaise = _m('discount')
      ..taxRateBp = _taxOn ? (Billing.parseRate(_t['taxRate']!.text) ?? 0) : 0
      ..onsitePaymentPaise = _m('onsite')
      ..customerFeedback = _s('feedback')
      ..signedBy = _s('signedBy')
      ..internalNotes = _s('internal');
  }

  Future<ServiceVisit?> _persist() async {
    _collect();
    final s = ref.read(settingsProvider);
    final saved = await ref
        .read(visitRepositoryProvider)
        .save(
          _d,
          visitPrefix: s.visitPrefix,
          inventoryEnabled: s.inventoryEnabled,
          actor: ref.read(actorProvider),
        );
    _existing = saved;
    _dirty = false;
    return saved;
  }

  Future<bool> _confirmCompletedEdit() async {
    if (!_completed) return true;
    return confirmDialog(
      context,
      title: 'Change a completed visit?',
      message:
          'The changes will be saved and recorded in this visit\'s change history.'
          '${_invoiceNo == null ? '' : '\n\nInvoice $_invoiceNo will NOT change automatically. Edit the invoice separately if needed.'}',
      confirmLabel: 'Save changes',
    );
  }

  Future<void> _saveDraft() async {
    if (_saving || !_form.currentState!.validate()) return;
    if (!await _confirmCompletedEdit()) return;
    setState(() => _saving = true);
    try {
      final v = await _persist();
      if (!mounted) return;
      showMessage(context, _completed ? 'Changes saved' : 'Saved as draft');
      if (widget.id == null) {
        context.pushReplacement('/visit/${v!.id}');
      } else {
        context.pop();
      }
    } catch (e) {
      if (mounted) showMessage(context, errorText(e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Used by attachments: a new visit is saved as a draft first.
  Future<bool> _ensureSaved() async {
    if (_existing != null) return true;
    if (_d.companyId.isEmpty) {
      showMessage(context, 'Select the company first', error: true);
      return false;
    }
    try {
      await _persist();
      if (mounted) setState(() {});
      return true;
    } catch (e) {
      if (mounted) showMessage(context, errorText(e), error: true);
      return false;
    }
  }

  Future<void> _complete() async {
    if (_saving || !_form.currentState!.validate()) return;
    _collect();
    final charges = _d.charges;
    var createInvoice = charges.total > 0;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Complete this visit?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AmountLine(
                'Visit total',
                Money.format(charges.total),
                bold: true,
              ),
              if (_d.onsitePaymentPaise > 0)
                AmountLine('Received now', Money.format(_d.onsitePaymentPaise)),
              if (_d.onsitePaymentPaise > 0 && charges.total > 0)
                AmountLine(
                  'Balance',
                  Money.format(
                    (charges.total - _d.onsitePaymentPaise).clamp(
                      0,
                      charges.total,
                    ),
                  ),
                ),
              const SizedBox(height: Gap.sm),
              if (charges.total > 0)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: createInvoice,
                  onChanged: (v) => setState(() => createInvoice = v ?? false),
                  title: const Text('Create invoice now'),
                  subtitle: const Text(
                    'You can also create it later, e.g. one invoice for several visits',
                  ),
                ),
              if (ref.read(settingsProvider).inventoryEnabled &&
                  _d.parts.any((p) => p.partId != null || p.addToCatalogue))
                const Text(
                  'Spare parts from the catalogue will be deducted from stock.',
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Not yet'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _saving = true);
    try {
      final r = await ref
          .read(billingRepositoryProvider)
          .completeVisit(
            _d,
            settings: ref.read(settingsProvider),
            createInvoice: createInvoice,
            actor: ref.read(actorProvider),
          );
      _dirty = false;
      if (!mounted) return;
      showMessage(
        context,
        r.invoice == null
            ? 'Visit completed'
            : 'Visit completed • Invoice ${r.invoice!.invoiceNo} created',
      );
      if (widget.id == null) {
        context.pushReplacement('/visit/${r.visit.id}?completed=1');
      } else {
        context.pop(true);
      }
    } catch (e) {
      if (mounted) showMessage(context, errorText(e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(), body: const LoadingView());
    final settings = ref.watch(settingsProvider);
    final title = _existing == null
        ? 'New service visit'
        : (_completed ? 'Edit completed visit' : 'Visit ${_existing!.visitNo}');
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await confirmDialog(
          context,
          title: 'Discard changes?',
          message: 'You have unsaved changes. Leave without saving?',
          confirmLabel: 'Discard',
          destructive: true,
        );
        if (leave && context.mounted) {
          _dirty = false;
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        bottomNavigationBar: _BottomBar(
          saving: _saving,
          completed: _completed,
          onDraft: _saveDraft,
          onComplete: _complete,
        ),
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, Gap.xxl),
            children: [
              if (_completed) ...[
                NoticeBanner(
                  message:
                      'This visit is completed. Changes are recorded in its history.'
                      '${_invoiceNo == null ? '' : ' Invoice $_invoiceNo will not change automatically.'}',
                ),
                const SizedBox(height: Gap.md),
              ],
              _sectionA(settings.technicianName),
              _sectionB(),
              _sectionC(),
              _Section(
                letter: 'D',
                title: 'Spare parts',
                subtitle: _d.parts.isEmpty
                    ? 'None'
                    : '${_d.parts.length} item(s) • ${Money.format(_d.partsTotal)}',
                initiallyExpanded: _d.parts.isNotEmpty,
                child: VisitPartsEditor(
                  parts: _d.parts,
                  onChanged: () => setState(() => _dirty = true),
                ),
              ),
              _sectionE(settings.taxEnabled, settings.taxLabel),
              _sectionF(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionA(String defaultTech) => _Section(
    letter: 'A',
    title: 'Visit details',
    initiallyExpanded: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_existing != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.md),
            child: Text(
              'Visit no. ${_existing!.visitNo}',
              style: context.text.labelLarge,
            ),
          ),
        CompanyField(
          companyId: _d.companyId.isEmpty ? null : _d.companyId,
          enabled: !_completed,
          onChanged: (id) => setState(() {
            if (id != _d.companyId) _d.machineId = null;
            _d.companyId = id;
            _dirty = true;
            _lastMachineVisit = null;
          }),
        ),
        MachineField(
          companyId: _d.companyId.isEmpty ? null : _d.companyId,
          machineId: _d.machineId,
          onChanged: (id) {
            setState(() {
              _d.machineId = id;
              _dirty = true;
            });
            _loadMachineHistory();
          },
        ),
        if (_lastMachineVisit != null)
          _LastVisitCard(visit: _lastMachineVisit!),
        DateField(
          label: 'Visit date',
          required: true,
          value: _d.visitDate,
          onChanged: (v) => setState(() {
            _d.visitDate = v ?? _d.visitDate;
            _dirty = true;
          }),
        ),
        Row(
          children: [
            Expanded(
              child: TimeField(
                label: 'Arrived',
                value: _d.arrivalTime,
                onChanged: (v) => setState(() {
                  _d.arrivalTime = v;
                  _dirty = true;
                }),
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: TimeField(
                label: 'Left',
                value: _d.departureTime,
                onChanged: (v) => setState(() {
                  _d.departureTime = v;
                  _dirty = true;
                }),
              ),
            ),
          ],
        ),
        Text('Service type', style: context.text.labelLarge),
        const SizedBox(height: Gap.sm),
        ChoiceChips<ServiceType>(
          options: ServiceType.values,
          selected: _d.serviceType,
          labelOf: (t) => t.label,
          onSelected: (t) => setState(() {
            _d.serviceType = t;
            _dirty = true;
          }),
        ),
        const SizedBox(height: Gap.lg),
        if (!_completed) ...[
          Text('Status', style: context.text.labelLarge),
          const SizedBox(height: Gap.sm),
          SegmentedButton<VisitStatus>(
            segments: const [
              ButtonSegment(
                value: VisitStatus.scheduled,
                label: Text('Scheduled'),
                icon: Icon(Icons.event),
              ),
              ButtonSegment(
                value: VisitStatus.inProgress,
                label: Text('In progress'),
                icon: Icon(Icons.engineering),
              ),
            ],
            selected: {
              _d.status == VisitStatus.scheduled
                  ? VisitStatus.scheduled
                  : VisitStatus.inProgress,
            },
            onSelectionChanged: (s) => setState(() {
              _d.status = s.first;
              _dirty = true;
            }),
          ),
          const SizedBox(height: Gap.lg),
        ],
        AppTextField(
          controller: _t['technician']!,
          label: 'Technician',
          capitalization: TextCapitalization.words,
        ),
        AppTextField(
          controller: _t['reported']!,
          label: 'Customer\'s complaint',
          hint: 'What did the customer report?',
          maxLines: 3,
          minLines: 1,
        ),
      ],
    ),
  );

  Widget _sectionB() => _Section(
    letter: 'B',
    title: 'Problem & diagnosis',
    initiallyExpanded: _d.symptoms != null || _d.diagnosis != null,
    child: Column(
      children: [
        AppTextField(
          controller: _t['symptoms']!,
          label: 'Symptoms observed',
          maxLines: 3,
          minLines: 1,
        ),
        AppTextField(
          controller: _t['diagnosis']!,
          label: 'Fault diagnosis',
          maxLines: 3,
          minLines: 1,
        ),
        AppTextField(
          controller: _t['rootCause']!,
          label: 'Root cause (if known)',
          maxLines: 2,
          minLines: 1,
        ),
      ],
    ),
  );

  Widget _sectionC() => _Section(
    letter: 'C',
    title: 'Work performed',
    initiallyExpanded: _d.workDone != null,
    child: Column(
      children: [
        AppTextField(
          controller: _t['workDone']!,
          label: 'Work carried out',
          maxLines: 4,
          minLines: 2,
        ),
        AppTextField(
          controller: _t['actions']!,
          label: 'Actions taken',
          maxLines: 3,
          minLines: 1,
        ),
        AppTextField(
          controller: _t['tests']!,
          label: 'Tests after repair',
          maxLines: 2,
          minLines: 1,
        ),
        EnumDropdown<MachineStatus>(
          label: 'Machine status after visit',
          values: MachineStatus.values,
          value: _d.machineStatusAfter,
          allowNone: true,
          onChanged: (v) => setState(() {
            _d.machineStatusAfter = v;
            _dirty = true;
          }),
        ),
        AppTextField(
          controller: _t['recommendations']!,
          label: 'Recommendations',
          maxLines: 3,
          minLines: 1,
        ),
        DateField(
          label: 'Next recommended service',
          value: _d.nextServiceDate,
          allowClear: true,
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          onChanged: (v) => setState(() {
            _d.nextServiceDate = v;
            _dirty = true;
          }),
        ),
      ],
    ),
  );

  Widget _sectionE(bool taxEnabled, String taxLabel) {
    _collect();
    final c = _d.charges;
    return _Section(
      letter: 'E',
      title: 'Charges & payment',
      subtitle: 'Total ${Money.format(c.total)}',
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MoneyField(
            controller: _t['labour']!,
            label: 'Labour / service charges',
            onChanged: (_) => setState(() {}),
          ),
          MoneyField(
            controller: _t['travel']!,
            label: 'Travel / other charges',
            onChanged: (_) => setState(() {}),
          ),
          MoneyField(
            controller: _t['discount']!,
            label: 'Discount',
            onChanged: (_) => setState(() {}),
            max: c.subtotal,
          ),
          if (taxEnabled || _taxOn) ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _taxOn,
              title: Text('Add $taxLabel'),
              subtitle: const Text('Only if this customer is billed with tax'),
              onChanged: (v) => setState(() {
                _taxOn = v;
                _dirty = true;
              }),
            ),
            if (_taxOn)
              AppTextField(
                controller: _t['taxRate']!,
                label: '$taxLabel rate (%)',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
                validator: (v) => Billing.parseRate(v) == null
                    ? 'Enter a rate between 0 and 100'
                    : null,
              ),
          ],
          const Divider(height: Gap.xl),
          AmountLine('Labour', Money.format(c.labour)),
          AmountLine('Spare parts', Money.format(c.parts)),
          if (c.travel > 0)
            AmountLine('Travel / other', Money.format(c.travel)),
          if (c.appliedDiscount > 0)
            AmountLine('Discount', '- ${Money.format(c.appliedDiscount)}'),
          if (c.tax > 0)
            AmountLine(
              '$taxLabel @ ${Billing.rateLabel(c.taxRateBp)}%',
              Money.format(c.tax),
            ),
          AmountLine('Final amount', Money.format(c.total), bold: true),
          const SizedBox(height: Gap.md),
          if (!_completed) ...[
            MoneyField(
              controller: _t['onsite']!,
              label: 'Amount received at site (optional)',
              helper: 'Recorded as a payment when you complete the visit',
              onChanged: (_) => setState(() {}),
            ),
            if (_d.onsitePaymentPaise > 0) ...[
              EnumDropdown<PaymentMethod>(
                label: 'Received by',
                values: PaymentMethod.values,
                value: _d.onsitePaymentMethod,
                onChanged: (v) => setState(() {
                  _d.onsitePaymentMethod = v ?? PaymentMethod.cash;
                  _dirty = true;
                }),
              ),
              AmountLine(
                'Remaining balance',
                Money.format(
                  (c.total - _d.onsitePaymentPaise).clamp(0, c.total),
                ),
                bold: true,
              ),
              if (_d.onsitePaymentPaise > c.total && c.total > 0)
                const NoticeBanner(
                  message:
                      'More than the visit total. The extra will be kept as advance / credit.',
                ),
            ],
          ] else if (_existing!.onsitePaymentPaise > 0)
            Text(
              'Received at site: ${Money.format(_existing!.onsitePaymentPaise)} (recorded as a payment)',
            ),
        ],
      ),
    );
  }

  Widget _sectionF() => _Section(
    letter: 'F',
    title: 'Photos, signature & notes',
    initiallyExpanded: _d.customerFeedback != null || _d.internalNotes != null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AttachmentsSection(
          entityType: 'visit',
          entityId: _d.id,
          ensureSaved: _ensureSaved,
          allowSignature: true,
        ),
        const SizedBox(height: Gap.lg),
        AppTextField(
          controller: _t['signedBy']!,
          label: 'Signed by (name)',
          capitalization: TextCapitalization.words,
        ),
        AppTextField(
          controller: _t['feedback']!,
          label: 'Customer feedback',
          maxLines: 3,
          minLines: 1,
        ),
        AppTextField(
          controller: _t['internal']!,
          label: 'Internal notes',
          helper: 'Only for you; not printed on reports',
          maxLines: 3,
          minLines: 1,
        ),
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.letter,
    required this.title,
    required this.child,
    this.subtitle,
    this.initiallyExpanded = false,
  });
  final String letter;
  final String title;
  final String? subtitle;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.md),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        maintainState: true,
        shape: const Border(),
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: context.colors.primary,
          child: Text(
            letter,
            style: TextStyle(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(title, style: context.text.titleMedium),
        subtitle: subtitle == null ? null : Text(subtitle!),
        // Top gap keeps the first field's floating label from being clipped.
        childrenPadding: const EdgeInsets.fromLTRB(
          Gap.lg,
          Gap.sm,
          Gap.lg,
          Gap.lg,
        ),
        children: [child],
      ),
    ),
  );
}

class _LastVisitCard extends StatelessWidget {
  const _LastVisitCard({required this.visit});
  final ServiceVisit visit;

  String? get note =>
      visit.diagnosis ?? visit.reportedProblem ?? visit.workDone;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.md),
    child: Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: context.status.info,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history, color: context.status.onInfo),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: Text(
              'Last serviced ${Dates.display(visit.visitDate)} '
              '(${Dates.daysBetween(visit.visitDate, Dates.today())} days ago)'
              '${note == null ? '' : '\n$note'}',
              style: TextStyle(color: context.status.onInfo),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/visit/${visit.id}'),
            child: const Text('View'),
          ),
        ],
      ),
    ),
  );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.saving,
    required this.completed,
    required this.onDraft,
    required this.onComplete,
  });
  final bool saving;
  final bool completed;
  final VoidCallback onDraft;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 8,
    color: context.colors.surface,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
        child: completed
            ? FilledButton.icon(
                onPressed: saving ? null : onDraft,
                icon: const Icon(Icons.check),
                label: const Text('Save changes'),
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: saving ? null : onDraft,
                      child: const Text('Save as draft'),
                    ),
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: saving ? null : onComplete,
                      icon: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.task_alt),
                      label: const Text('Complete visit'),
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}
