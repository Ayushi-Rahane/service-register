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
import '../../core/widgets/stream_body.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/machine_repository.dart';
import '../../data/repositories/visit_repository.dart';
import '../../domain/enums.dart';
import '../providers.dart';
import '../visits/visit_tile.dart';

class MachineDetailScreen extends ConsumerWidget {
  const MachineDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(machineProvider(id)),
    builder: (m) => m == null
        ? Scaffold(
            appBar: AppBar(),
            body: const EmptyState(
              icon: Icons.search_off,
              title: 'Machine not found',
            ),
          )
        : _MachineView(machine: m),
  );
}

class _MachineView extends ConsumerStatefulWidget {
  const _MachineView({required this.machine});
  final Machine machine;
  @override
  ConsumerState<_MachineView> createState() => _MachineViewState();
}

class _MachineViewState extends ConsumerState<_MachineView> {
  late final Stream<List<VisitListItem>> _visits = ref
      .read(visitRepositoryProvider)
      .watchList(VisitFilter(machineId: widget.machine.id));

  @override
  Widget build(BuildContext context) {
    final m = widget.machine;
    final company = ref.watch(companyProvider(m.companyId)).value;
    final stats = ref.watch(machineStatsProvider(m.id));
    final today = Dates.today();
    final warrantyActive =
        m.warrantyUntil != null && m.warrantyUntil!.compareTo(today) >= 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(m.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => context.push('/machine/${m.id}/edit'),
          ),
          PopupMenuButton<String>(
            onSelected: (a) async {
              final repo = ref.read(machineRepositoryProvider);
              if (a == 'report') {
                await context.push('/reports/machineHistory?machineId=${m.id}');
              } else if (a == 'archive') {
                final ok = await confirmDialog(
                  context,
                  title: 'Archive machine?',
                  message:
                      'It will be hidden from lists. Its service history is kept.',
                  confirmLabel: 'Archive',
                );
                if (ok && context.mounted) {
                  await runGuarded(
                    context,
                    () => repo.setArchived(m.id, true),
                    success: 'Machine archived',
                  );
                }
              } else if (a == 'restore') {
                await runGuarded(
                  context,
                  () => repo.setArchived(m.id, false),
                  success: 'Machine restored',
                );
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'report',
                child: Text('Maintenance history report'),
              ),
              PopupMenuItem(
                value: m.archivedAt == null ? 'archive' : 'restore',
                child: Text(
                  m.archivedAt == null ? 'Archive machine' : 'Restore machine',
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'machine-visit',
        onPressed: () => context.push(
          '/visit/new?companyId=${m.companyId}&machineId=${m.id}',
        ),
        icon: const Icon(Icons.add),
        label: const Text('New visit'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, 96),
        children: [
          SectionCard(
            title: company?.name ?? '',
            icon: Icons.apartment,
            trailing: StatusChip.machine(MachineStatus.fromDb(m.status)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow('Category', MachineCategory.fromDb(m.category).label),
                InfoRow(
                  'Manufacturer / model',
                  [m.manufacturer, m.model].whereType<String>().join(' '),
                ),
                InfoRow(
                  'Serial number',
                  m.serialNumber ?? 'Not recorded',
                  showEmpty: true,
                ),
                InfoRow('Location', m.location),
                InfoRow(
                  'Installed on',
                  m.installedOn == null ? null : Dates.display(m.installedOn),
                ),
                InfoRow(
                  'Warranty',
                  m.warrantyUntil == null
                      ? null
                      : '${warrantyActive ? 'Valid until' : 'Expired on'} ${Dates.display(m.warrantyUntil)}',
                ),
                InfoRow(
                  'Maintenance interval',
                  m.serviceIntervalDays == null
                      ? null
                      : 'Every ${m.serviceIntervalDays} days',
                ),
                InfoRow('Notes', m.notes),
                TextButton.icon(
                  onPressed: () => context.push('/company/${m.companyId}'),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open company'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          AsyncBody<MachineStats>(
            value: stats,
            builder: (s) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: KpiTile(
                        label: 'Visits',
                        value: '${s.visitCount}',
                        icon: Icons.build_outlined,
                      ),
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: KpiTile(
                        label: 'Total service spend',
                        value: Money.short(s.totalSpend),
                        icon: Icons.currency_rupee,
                        caption: 'Completed visits',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Gap.md),
                SectionCard(
                  title: 'Maintenance',
                  icon: Icons.event_repeat,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InfoRow(
                        'Last service',
                        s.lastVisit == null
                            ? 'Never'
                            : Dates.display(s.lastVisit),
                        showEmpty: true,
                      ),
                      InfoRow(
                        'Next maintenance due',
                        m.nextServiceDue == null
                            ? 'Not set'
                            : '${Dates.display(m.nextServiceDue)}${m.nextServiceDue!.compareTo(today) < 0 ? ' (overdue)' : ''}',
                        showEmpty: true,
                      ),
                      const SizedBox(height: Gap.sm),
                      OutlinedButton.icon(
                        onPressed: () => context.push(
                          '/visit/schedule?companyId=${m.companyId}&machineId=${m.id}'
                          '${m.nextServiceDue == null ? '' : '&date=${m.nextServiceDue}'}',
                        ),
                        icon: const Icon(Icons.event_available),
                        label: const Text('Schedule maintenance visit'),
                      ),
                    ],
                  ),
                ),
                if (s.recurringFaults.isNotEmpty) ...[
                  const SizedBox(height: Gap.md),
                  SectionCard(
                    title: 'Recurring faults',
                    icon: Icons.repeat,
                    child: Column(
                      children: [
                        for (final f in s.recurringFaults)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: context.status.warning,
                              child: Text(
                                '${f.count}×',
                                style: TextStyle(
                                  color: context.status.onWarning,
                                ),
                              ),
                            ),
                            title: Text(f.description),
                            subtitle: Text(
                              'Last on ${Dates.display(f.lastDate)}',
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (s.partsReplaced.isNotEmpty) ...[
                  const SizedBox(height: Gap.md),
                  SectionCard(
                    title: 'Parts replaced',
                    icon: Icons.settings_input_component_outlined,
                    child: Column(
                      children: [
                        for (final p in s.partsReplaced.take(20))
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              '${p.partName} × ${Qty.format(p.qtyMilli)}',
                            ),
                            subtitle: Text(
                              '${Dates.display(p.visitDate)} • ${p.visitNo}',
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const ListHeader('Service history'),
          StreamBody(
            stream: _visits,
            builder: (context, list) => list.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(Gap.lg),
                    child: Text('No visits recorded for this machine yet.'),
                  )
                : Card(
                    child: Column(
                      children: [
                        for (final v in list) VisitTile(v, showCompany: false),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
