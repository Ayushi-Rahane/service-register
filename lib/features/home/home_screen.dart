import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/repositories/machine_repository.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../data/repositories/visit_repository.dart';
import '../../domain/enums.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers.dart';
import '../sync/sync_badge.dart';
import '../visits/visit_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Stream<List<VisitListItem>> _today, _inProgress, _upcoming;
  late Stream<List<MachineListItem>> _maintenance;
  late Stream<List<ReminderItem>> _reminders;
  late String _day;

  @override
  void initState() {
    super.initState();
    _buildStreams();
  }

  void _buildStreams() {
    _day = Dates.today();
    final visits = ref.read(visitRepositoryProvider);
    _today = visits.watchList(
      VisitFilter(from: _day, to: _day, newestFirst: false),
    );
    _inProgress = visits.watchList(
      const VisitFilter(statuses: {VisitStatus.inProgress}, newestFirst: false),
    );
    _upcoming = visits.watchList(
      VisitFilter(
        statuses: const {VisitStatus.scheduled},
        from: Dates.addDays(_day, 1),
        to: Dates.addDays(_day, 14),
        newestFirst: false,
        limit: 6,
      ),
    );
    _maintenance = ref
        .read(machineRepositoryProvider)
        .watchMaintenanceDue(Dates.addDays(_day, 30));
    _reminders = ref
        .read(reminderRepositoryProvider)
        .watch(until: Dates.addDays(_day, 3));
  }

  @override
  Widget build(BuildContext context) {
    // Re-query when the date changes while the app stays open.
    if (_day != Dates.today()) _buildStreams();
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              settings.displayBusinessName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              Dates.dayName(_day),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l.actionSearch,
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          const SyncBadge(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'new-visit',
        onPressed: () => context.push('/visit/new'),
        icon: const Icon(Icons.add),
        label: Text(l.newVisit),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 96),
        children: [
          const _Kpis(),
          const SizedBox(height: Gap.lg),
          _VisitsCard(
            title: l.todaysVisits,
            icon: Icons.today,
            stream: _today,
            empty: 'No visits planned for today',
            action: TextButton.icon(
              onPressed: () => context.push('/visit/schedule?date=$_day'),
              icon: const Icon(Icons.event_available),
              label: const Text('Schedule'),
            ),
          ),
          const SizedBox(height: Gap.md),
          _VisitsCard(
            title: 'Jobs in progress',
            icon: Icons.engineering,
            stream: _inProgress,
            empty: 'No unfinished jobs',
            hideWhenEmpty: true,
          ),
          _VisitsCard(
            title: l.upcomingVisits,
            icon: Icons.event,
            stream: _upcoming,
            empty: 'Nothing scheduled in the next 2 weeks',
            relative: true,
            action: TextButton(
              onPressed: () => context.push('/schedule'),
              child: const Text('Calendar'),
            ),
          ),
          const SizedBox(height: Gap.md),
          _MaintenanceCard(stream: _maintenance),
          _RemindersCard(stream: _reminders),
          const _BalancesCard(),
          const _WorkDoneCard(),
        ],
      ),
    );
  }
}

class _Kpis extends ConsumerWidget {
  const _Kpis();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final inventory = ref.watch(
      settingsProvider.select((s) => s.inventoryEnabled),
    );
    final l = AppLocalizations.of(context);
    return AsyncBody(
      value: stats,
      builder: (s) => Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: KpiTile(
                    label: l.collectedThisMonth,
                    value: Money.short(s.collectedMonth),
                    icon: Icons.savings_outlined,
                    color: context.status.onSuccess,
                    caption: 'Money received',
                    onTap: () => context.go('/billing'),
                  ),
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: KpiTile(
                    label: l.billedThisMonth,
                    value: Money.short(s.billedMonth),
                    icon: Icons.receipt_long_outlined,
                    caption: 'Invoices raised',
                    onTap: () => context.go('/billing'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: KpiTile(
                    label: '${l.outstanding} balance',
                    value: Money.short(s.outstanding),
                    icon: Icons.account_balance_wallet_outlined,
                    color: context.status.onWarning,
                    caption:
                        '${s.pendingCount} unpaid invoice${s.pendingCount == 1 ? '' : 's'}',
                    onTap: () => context.go('/billing'),
                  ),
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: KpiTile(
                    label: l.overdue,
                    value: Money.short(s.overdueAmount),
                    icon: Icons.warning_amber_rounded,
                    color: s.overdueCount > 0
                        ? context.colors.error
                        : context.colors.onSurfaceVariant,
                    caption:
                        '${s.overdueCount} invoice${s.overdueCount == 1 ? '' : 's'} past due',
                    onTap: () => context.go('/billing'),
                  ),
                ),
              ],
            ),
          ),
          if (inventory && s.lowStockCount > 0) ...[
            const SizedBox(height: Gap.md),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.inventory_2_outlined,
                  color: context.colors.error,
                ),
                title: Text(
                  '${s.lowStockCount} spare part${s.lowStockCount == 1 ? '' : 's'} low on stock',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/inventory'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VisitsCard extends StatelessWidget {
  const _VisitsCard({
    required this.title,
    required this.icon,
    required this.stream,
    required this.empty,
    this.action,
    this.hideWhenEmpty = false,
    this.relative = false,
  });
  final String title;
  final IconData icon;
  final Stream<List<VisitListItem>> stream;
  final String empty;
  final Widget? action;
  final bool hideWhenEmpty;
  final bool relative;

  @override
  Widget build(BuildContext context) => StreamBody(
    stream: stream,
    builder: (context, items) {
      if (items.isEmpty && hideWhenEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: Gap.md),
        child: SectionCard(
          title: items.isEmpty ? title : '$title (${items.length})',
          icon: icon,
          trailing: action,
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.sm, Gap.sm),
          child: items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: Gap.sm),
                  child: Text(
                    empty,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (final i in items.take(8))
                      VisitTile(i, relativeDate: relative),
                  ],
                ),
        ),
      );
    },
  );
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.stream});
  final Stream<List<MachineListItem>> stream;

  @override
  Widget build(BuildContext context) => StreamBody(
    stream: stream,
    builder: (context, items) {
      if (items.isEmpty) return const SizedBox.shrink();
      final today = Dates.today();
      return Padding(
        padding: const EdgeInsets.only(bottom: Gap.md),
        child: SectionCard(
          title: 'Maintenance due',
          icon: Icons.precision_manufacturing_outlined,
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.sm, Gap.sm),
          child: Column(
            children: [
              for (final m in items.take(6))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(m.machine.name),
                  subtitle: Text(m.companyName),
                  trailing: Text(
                    m.machine.nextServiceDue!.compareTo(today) < 0
                        ? 'Overdue\n${Dates.display(m.machine.nextServiceDue)}'
                        : Dates.relative(m.machine.nextServiceDue!),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: m.machine.nextServiceDue!.compareTo(today) < 0
                          ? context.colors.error
                          : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => context.push(
                    '/visit/schedule?companyId=${m.machine.companyId}&machineId=${m.machine.id}',
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _RemindersCard extends ConsumerWidget {
  const _RemindersCard({required this.stream});
  final Stream<List<ReminderItem>> stream;

  @override
  Widget build(BuildContext context, WidgetRef ref) => StreamBody(
    stream: stream,
    builder: (context, items) {
      if (items.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: Gap.md),
        child: SectionCard(
          title: 'Reminders',
          icon: Icons.notifications_active_outlined,
          trailing: TextButton(
            onPressed: () => context.push('/schedule'),
            child: const Text('All'),
          ),
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.sm, Gap.sm),
          child: Column(
            children: [
              for (final r in items.take(5))
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: false,
                  onChanged: (_) => ref
                      .read(reminderRepositoryProvider)
                      .markDone(r.reminder.id),
                  title: Text(r.reminder.title),
                  subtitle: Text(
                    [
                      Dates.relative(r.reminder.dueDate),
                      ?r.companyName,
                    ].join(' • '),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _BalancesCard extends ConsumerWidget {
  const _BalancesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(topBalancesProvider).value ?? const [];
    if (balances.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.md),
      child: SectionCard(
        title: 'Customers with balance due',
        icon: Icons.people_outline,
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.sm, Gap.sm),
        child: Column(
          children: [
            for (final b in balances)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(b.name),
                trailing: Text(
                  Money.format(b.outstanding),
                  style: context.text.titleSmall,
                ),
                onTap: () => context.push('/company/${b.companyId}'),
              ),
          ],
        ),
      ),
    );
  }
}

class _WorkDoneCard extends ConsumerWidget {
  const _WorkDoneCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(dashboardStatsProvider).value;
    if (s == null) return const SizedBox.shrink();
    Widget cell(String label, int n) => Expanded(
      child: Column(
        children: [
          Text(
            '$n',
            style: context.text.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(label, style: context.text.bodySmall),
        ],
      ),
    );
    return SectionCard(
      title: 'Visits completed',
      icon: Icons.task_alt,
      trailing: TextButton(
        onPressed: () => context.push('/reports'),
        child: const Text('Reports'),
      ),
      child: Row(
        children: [
          cell('Today', s.completedToday),
          cell('This week', s.completedWeek),
          cell('This month', s.completedMonth),
        ],
      ),
    );
  }
}
