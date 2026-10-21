import 'dart:convert';

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
import '../../data/local/app_database.dart';
import '../../domain/billing.dart';
import '../../domain/enums.dart';
import '../attachments/attachments_section.dart';
import '../providers.dart';

class VisitDetailScreen extends ConsumerStatefulWidget {
  const VisitDetailScreen({
    super.key,
    required this.id,
    this.justCompleted = false,
  });
  final String id;
  final bool justCompleted;

  @override
  ConsumerState<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends ConsumerState<VisitDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.justCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _afterCompletion());
    }
  }

  Future<void> _afterCompletion() async {
    final v = await ref.read(visitRepositoryProvider).get(widget.id);
    if (v == null || !mounted) return;
    final action = await showActionSheet<String>(
      context,
      title: 'Visit completed. What next?',
      actions: [
        (
          icon: Icons.picture_as_pdf_outlined,
          label: 'Service report (PDF)',
          value: 'report',
        ),
        if (v.invoiceId != null)
          (
            icon: Icons.receipt_long,
            label: 'View / share invoice',
            value: 'invoice',
          )
        else if (v.totalPaise > 0)
          (
            icon: Icons.receipt_long,
            label: 'Create invoice',
            value: 'new-invoice',
          ),
        (
          icon: Icons.currency_rupee,
          label: 'Record a payment',
          value: 'payment',
        ),
        (
          icon: Icons.event_repeat,
          label: 'Schedule next visit',
          value: 'schedule',
        ),
      ],
    );
    if (action != null && mounted) await _run(action, v);
  }

  Future<void> _run(String action, ServiceVisit v) async {
    final settings = ref.read(settingsProvider);
    switch (action) {
      case 'edit':
        await context.push('/visit/${v.id}/edit');
      case 'report':
        try {
          final doc = await ref
              .read(documentServiceProvider)
              .visitReport(v.id, settings);
          if (mounted) await context.push('/pdf', extra: doc);
        } catch (e) {
          if (mounted) showMessage(context, errorText(e), error: true);
        }
      case 'invoice':
        await context.push('/invoice/${v.invoiceId}');
      case 'new-invoice':
        await context.push(
          '/invoice/new?companyId=${v.companyId}&visitIds=${v.id}',
        );
      case 'payment':
        await context.push(
          '/payment/new?companyId=${v.companyId}${v.invoiceId == null ? '' : '&invoiceId=${v.invoiceId}'}',
        );
      case 'schedule':
        final machine = v.machineId == null
            ? null
            : await ref.read(machineRepositoryProvider).get(v.machineId!);
        final date = v.nextServiceDate ?? machine?.nextServiceDue;
        if (mounted) {
          await context.push(
            '/visit/schedule?companyId=${v.companyId}'
            '${v.machineId == null ? '' : '&machineId=${v.machineId}'}'
            '${date == null ? '' : '&date=$date'}',
          );
        }
      case 'start':
        await runGuarded(
          context,
          () => ref.read(visitRepositoryProvider).start(v.id),
        );
        if (mounted) await context.push('/visit/${v.id}/edit');
      case 'reschedule':
        final picked = await showDatePicker(
          context: context,
          initialDate: Dates.tryParse(v.visitDate) ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime(2100),
          helpText: 'New visit date',
        );
        if (picked != null && mounted) {
          await runGuarded(
            context,
            () => ref
                .read(visitRepositoryProvider)
                .reschedule(v.id, Dates.iso(picked), v.arrivalTime),
            success: 'Rescheduled to ${Dates.displayDate(picked)}',
          );
        }
      case 'cancel':
        final reason = await promptText(
          context,
          title: 'Cancel visit?',
          message: 'The visit stays in history as cancelled.',
          confirmLabel: 'Cancel visit',
          destructive: true,
        );
        if (reason != null && mounted) {
          await runGuarded(
            context,
            () => ref.read(visitRepositoryProvider).cancel(v.id, reason),
            success: 'Visit cancelled',
          );
        }
      case 'delete':
        final ok = await confirmDialog(
          context,
          title: 'Delete this visit?',
          message:
              'It will be removed from lists. (Completed visits cannot be deleted.)',
          confirmLabel: 'Delete',
          destructive: true,
        );
        if (ok && mounted) {
          final done = await runGuarded(
            context,
            () => ref.read(visitRepositoryProvider).archive(v.id),
            success: 'Visit deleted',
          );
          if (done && mounted) context.pop();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final visit = ref.watch(visitProvider(widget.id));
    return AsyncBody(
      value: visit,
      builder: (v) => v == null
          ? Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                icon: Icons.search_off,
                title: 'Visit not found',
              ),
            )
          : _buildVisit(v),
    );
  }

  Widget _buildVisit(ServiceVisit v) {
    final status = VisitStatus.fromDb(v.status);
    final company = ref.watch(companyProvider(v.companyId)).value;
    final machine = v.machineId == null
        ? null
        : ref.watch(machineProvider(v.machineId!)).value;
    final parts =
        ref.watch(visitPartsProvider(v.id)).value ?? const <VisitPart>[];
    final history =
        ref.watch(historyProvider(('visit', v.id))).value ??
        const <AuditEntry>[];
    final open =
        status == VisitStatus.scheduled || status == VisitStatus.inProgress;
    final charges = ChargeBreakdown(
      labour: v.labourPaise,
      parts: v.partsTotalPaise,
      travel: v.travelPaise,
      other: 0,
      discount: v.discountPaise,
      taxRateBp: v.taxRateBp,
    );
    final times = [
      if (v.arrivalTime != null) 'Arrived ${Dates.displayTime(v.arrivalTime)}',
      if (v.departureTime != null) 'Left ${Dates.displayTime(v.departureTime)}',
    ].join(' • ');

    return Scaffold(
      appBar: AppBar(
        title: Text(v.visitNo),
        actions: [
          IconButton(
            tooltip: 'Service report',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => _run('report', v),
          ),
          PopupMenuButton<String>(
            onSelected: (a) => _run(a, v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              if (status == VisitStatus.scheduled)
                const PopupMenuItem(
                  value: 'reschedule',
                  child: Text('Reschedule'),
                ),
              if (status == VisitStatus.completed)
                const PopupMenuItem(
                  value: 'schedule',
                  child: Text('Schedule next visit'),
                ),
              if (open)
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancel visit'),
                ),
              if (status != VisitStatus.completed)
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
          child: switch (status) {
            VisitStatus.scheduled => FilledButton.icon(
              onPressed: () => _run('start', v),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start this visit'),
            ),
            VisitStatus.inProgress => FilledButton.icon(
              onPressed: () => _run('edit', v),
              icon: const Icon(Icons.edit_note),
              label: const Text('Continue & complete'),
            ),
            VisitStatus.completed => Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _run('payment', v),
                    icon: const Icon(Icons.currency_rupee),
                    label: const Text('Payment'),
                  ),
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _run(
                      v.invoiceId != null ? 'invoice' : 'new-invoice',
                      v,
                    ),
                    icon: const Icon(Icons.receipt_long),
                    label: Text(
                      v.invoiceId != null ? 'Invoice' : 'Create invoice',
                    ),
                  ),
                ),
              ],
            ),
            VisitStatus.cancelled => const SizedBox.shrink(),
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Gap.lg),
        children: [
          SectionCard(
            title: company?.name ?? '',
            icon: Icons.apartment,
            trailing: StatusChip.visit(status),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow(
                  'Machine',
                  machine == null
                      ? 'Not specified'
                      : '${machine.name}${machine.serialNumber == null ? '' : ' (S/N ${machine.serialNumber})'}',
                  showEmpty: true,
                ),
                InfoRow(
                  'Date',
                  '${Dates.display(v.visitDate)}${times.isEmpty ? '' : '  •  $times'}',
                ),
                InfoRow(
                  'Service type',
                  ServiceType.fromDb(v.serviceType).label,
                ),
                InfoRow('Technician', v.technicianName),
                if (status == VisitStatus.scheduled &&
                    v.visitDate.compareTo(Dates.today()) < 0)
                  const NoticeBanner(
                    message:
                        'This scheduled visit was missed. Reschedule or start it.',
                    danger: true,
                  ),
                Wrap(
                  spacing: Gap.sm,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.push('/company/${v.companyId}'),
                      icon: const Icon(Icons.apartment, size: 18),
                      label: const Text('Company'),
                    ),
                    if (machine != null)
                      TextButton.icon(
                        onPressed: () => context.push('/machine/${machine.id}'),
                        icon: const Icon(
                          Icons.precision_manufacturing_outlined,
                          size: 18,
                        ),
                        label: const Text('Machine history'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          _textCard('Problem & diagnosis', Icons.report_problem_outlined, [
            ('Customer\'s complaint', v.reportedProblem),
            ('Symptoms', v.symptoms),
            ('Diagnosis', v.diagnosis),
            ('Root cause', v.rootCause),
          ]),
          _textCard('Work performed', Icons.handyman_outlined, [
            ('Work carried out', v.workDone),
            ('Actions taken', v.actionsTaken),
            ('Tests after repair', v.testsPerformed),
            (
              'Machine status after',
              v.machineStatusAfter == null
                  ? null
                  : MachineStatus.fromDb(v.machineStatusAfter).label,
            ),
            ('Recommendations', v.recommendations),
            (
              'Next recommended service',
              v.nextServiceDate == null
                  ? null
                  : Dates.display(v.nextServiceDate),
            ),
          ]),
          if (parts.isNotEmpty) ...[
            SectionCard(
              title: 'Spare parts',
              icon: Icons.settings_input_component_outlined,
              child: Column(
                children: [
                  for (final p in parts)
                    AmountLine(
                      '${p.partName} × ${Qty.format(p.qtyMilli)}',
                      Money.format(
                        Billing.lineTotal(p.qtyMilli, p.unitPricePaise),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: Gap.md),
          ],
          if (charges.subtotal > 0 || v.onsitePaymentPaise > 0) ...[
            SectionCard(
              title: 'Charges',
              icon: Icons.currency_rupee,
              child: Column(
                children: [
                  if (charges.labour > 0)
                    AmountLine('Labour', Money.format(charges.labour)),
                  if (charges.parts > 0)
                    AmountLine('Spare parts', Money.format(charges.parts)),
                  if (charges.travel > 0)
                    AmountLine('Travel / other', Money.format(charges.travel)),
                  if (charges.appliedDiscount > 0)
                    AmountLine(
                      'Discount',
                      '- ${Money.format(charges.appliedDiscount)}',
                    ),
                  if (charges.tax > 0)
                    AmountLine(
                      'Tax @ ${Billing.rateLabel(v.taxRateBp)}%',
                      Money.format(charges.tax),
                    ),
                  AmountLine('Total', Money.format(charges.total), bold: true),
                  if (v.onsitePaymentPaise > 0)
                    AmountLine(
                      status == VisitStatus.completed
                          ? 'Received at site'
                          : 'To be received at site',
                      Money.format(v.onsitePaymentPaise),
                    ),
                ],
              ),
            ),
            const SizedBox(height: Gap.md),
          ],
          SectionCard(
            title: 'Photos & signature',
            icon: Icons.photo_library_outlined,
            child: AttachmentsSection(
              entityType: 'visit',
              entityId: v.id,
              allowSignature: true,
            ),
          ),
          const SizedBox(height: Gap.md),
          _textCard('Customer & notes', Icons.chat_bubble_outline, [
            ('Signed by', v.signedBy),
            ('Customer feedback', v.customerFeedback),
            ('Internal notes', v.internalNotes),
          ]),
          if (history.isNotEmpty)
            SectionCard(
              title: 'Change history',
              icon: Icons.history,
              child: Column(
                children: [for (final h in history) _HistoryTile(h)],
              ),
            ),
        ],
      ),
    );
  }

  Widget _textCard(String title, IconData icon, List<(String, String?)> rows) {
    if (rows.every((r) => r.$2 == null || r.$2!.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.md),
      child: SectionCard(
        title: title,
        icon: icon,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final r in rows) InfoRow(r.$1, r.$2)],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile(this.entry);
  final AuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final changes = entry.changes == null
        ? null
        : (jsonDecode(entry.changes!) as Map<String, dynamic>);
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      shape: const Border(),
      title: Text(entry.summary ?? entry.action),
      subtitle: Text(
        '${Dates.timestamp(entry.createdAt)}${entry.actor == null ? '' : ' • ${entry.actor}'}',
      ),
      children: [
        if (changes != null)
          for (final e in changes.entries)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Gap.xs),
                child: Text(
                  e.value is Map
                      ? '${_label(e.key)}: ${_fmt(e.key, e.value['from'])} → ${_fmt(e.key, e.value['to'])}'
                      : '${_label(e.key)}: ${e.value}',
                  style: context.text.bodySmall,
                ),
              ),
            ),
      ],
    );
  }

  static String _label(String key) => key
      .replaceAllMapped(RegExp('[A-Z]'), (m) => ' ${m[0]!.toLowerCase()}')
      .replaceAll('paise', '')
      .trim();

  static String _fmt(String key, Object? v) {
    if (v == null || v == '') return '—';
    if (key.endsWith('Paise') && v is int) return Money.format(v);
    return '$v';
  }
}
