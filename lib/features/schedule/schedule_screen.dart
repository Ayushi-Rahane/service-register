import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/repositories/machine_repository.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../data/repositories/visit_repository.dart';
import '../../domain/enums.dart';
import '../visits/visit_tile.dart';

enum _View { upcoming, missed, done }

/// Planner: scheduled visits, reminders and maintenance due, grouped by day.
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});
  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  _View _view = _View.upcoming;
  late Stream<List<VisitListItem>> _visits;
  late Stream<List<ReminderItem>> _reminders;
  late Stream<List<MachineListItem>> _maintenance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final today = Dates.today();
    final visits = ref.read(visitRepositoryProvider);
    final reminders = ref.read(reminderRepositoryProvider);
    switch (_view) {
      case _View.upcoming:
        _visits = visits.watchList(
          VisitFilter(
            statuses: const {VisitStatus.scheduled},
            from: today,
            newestFirst: false,
          ),
        );
        _reminders = reminders.watch();
        _maintenance = ref
            .read(machineRepositoryProvider)
            .watchMaintenanceDue(Dates.addDays(today, 60));
      case _View.missed:
        _visits = visits.watchList(
          VisitFilter(
            statuses: const {VisitStatus.scheduled},
            to: Dates.addDays(today, -1),
          ),
        );
        _reminders = reminders.watch(until: Dates.addDays(today, -1));
        _maintenance = ref
            .read(machineRepositoryProvider)
            .watchMaintenanceDue(Dates.addDays(today, -1));
      case _View.done:
        _visits = visits.watchList(
          VisitFilter(
            statuses: const {VisitStatus.completed},
            from: Dates.addDays(today, -30),
          ),
        );
        _reminders = reminders.watch(statuses: const {ReminderStatus.done});
        _maintenance = Stream.value(const []);
    }
  }

  Future<void> _reminderActions(ReminderItem r) async {
    final repo = ref.read(reminderRepositoryProvider);
    final a = await showActionSheet<String>(
      context,
      title: r.reminder.title,
      actions: [
        if (r.reminder.status == ReminderStatus.pending.db)
          (
            icon: Icons.check_circle_outline,
            label: 'Mark as done',
            value: 'done',
          ),
        (icon: Icons.event_repeat, label: 'Reschedule', value: 'reschedule'),
        (icon: Icons.edit_outlined, label: 'Edit', value: 'edit'),
        if (r.reminder.invoiceId != null)
          (icon: Icons.receipt_long, label: 'Open invoice', value: 'invoice'),
        if (r.reminder.companyId != null)
          (icon: Icons.apartment, label: 'Open company', value: 'company'),
        (icon: Icons.delete_outline, label: 'Cancel reminder', value: 'cancel'),
      ],
    );
    if (!mounted || a == null) return;
    switch (a) {
      case 'done':
        await runGuarded(
          context,
          () => repo.markDone(r.reminder.id),
          success: 'Marked as done',
        );
      case 'reschedule':
        final d = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime(2100),
        );
        if (d != null && mounted) {
          await runGuarded(
            context,
            () => repo.reschedule(
              r.reminder.id,
              Dates.iso(d),
              r.reminder.dueTime,
            ),
            success: 'Moved to ${Dates.displayDate(d)}',
          );
        }
      case 'edit':
        await context.push('/reminder/${r.reminder.id}/edit');
      case 'invoice':
        await context.push('/invoice/${r.reminder.invoiceId}');
      case 'company':
        await context.push('/company/${r.reminder.companyId}');
      case 'cancel':
        await runGuarded(
          context,
          () => repo.cancel(r.reminder.id),
          success: 'Reminder cancelled',
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Schedule & reminders')),
    floatingActionButton: FloatingActionButton.extended(
      heroTag: 'schedule-add',
      onPressed: () async {
        final a = await showActionSheet<String>(
          context,
          actions: const [
            (
              icon: Icons.event_available,
              label: 'Schedule a visit',
              value: 'visit',
            ),
            (
              icon: Icons.notifications_active_outlined,
              label: 'Add a reminder',
              value: 'reminder',
            ),
          ],
        );
        if (!context.mounted) return;
        if (a == 'visit') {
          await context.push('/visit/schedule');
        } else if (a == 'reminder') {
          await context.push('/reminder/new');
        }
      },
      icon: const Icon(Icons.add),
      label: const Text('Add'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Gap.lg),
          child: SegmentedButton<_View>(
            segments: const [
              ButtonSegment(value: _View.upcoming, label: Text('Upcoming')),
              ButtonSegment(value: _View.missed, label: Text('Missed')),
              ButtonSegment(value: _View.done, label: Text('Done')),
            ],
            selected: {_view},
            onSelectionChanged: (s) => setState(() {
              _view = s.first;
              _load();
            }),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              StreamBody(
                stream: _visits,
                builder: (context, list) => _group(
                  _view == _View.done
                      ? 'Completed visits (last 30 days)'
                      : (_view == _View.missed
                            ? 'Missed visits'
                            : 'Scheduled visits'),
                  list.isEmpty
                      ? null
                      : Column(
                          children: [
                            for (final v in list)
                              VisitTile(v, relativeDate: true),
                          ],
                        ),
                ),
              ),
              StreamBody(
                stream: _reminders,
                builder: (context, list) {
                  final today = Dates.today();
                  final shown = _view == _View.upcoming
                      ? list
                            .where(
                              (r) => r.reminder.dueDate.compareTo(today) >= 0,
                            )
                            .toList()
                      : list;
                  return _group(
                    'Reminders',
                    shown.isEmpty
                        ? null
                        : Column(
                            children: [
                              for (final r in shown)
                                ListTile(
                                  leading: Icon(
                                    r.reminder.status == ReminderStatus.done.db
                                        ? Icons.check_circle
                                        : Icons.notifications_active_outlined,
                                    color:
                                        r.reminder.dueDate.compareTo(today) <
                                                0 &&
                                            r.reminder.status ==
                                                ReminderStatus.pending.db
                                        ? context.colors.error
                                        : null,
                                  ),
                                  title: Text(r.reminder.title),
                                  subtitle: Text(
                                    [
                                      Dates.relative(r.reminder.dueDate),
                                      if (r.reminder.dueTime != null)
                                        Dates.displayTime(r.reminder.dueTime),
                                      ReminderKind.fromDb(
                                        r.reminder.kind,
                                      ).label,
                                      ?r.companyName,
                                      ?r.invoiceNo,
                                    ].join(' • '),
                                  ),
                                  onTap: () => _reminderActions(r),
                                ),
                            ],
                          ),
                  );
                },
              ),
              StreamBody(
                stream: _maintenance,
                builder: (context, list) => _group(
                  _view == _View.missed
                      ? 'Maintenance overdue'
                      : 'Maintenance due',
                  list.isEmpty
                      ? null
                      : Column(
                          children: [
                            for (final m in list)
                              ListTile(
                                leading: const Icon(
                                  Icons.precision_manufacturing_outlined,
                                ),
                                title: Text(m.machine.name),
                                subtitle: Text(
                                  '${m.companyName} • due ${Dates.display(m.machine.nextServiceDue)}',
                                ),
                                trailing: TextButton(
                                  onPressed: () => context.push(
                                    '/visit/schedule?companyId=${m.machine.companyId}&machineId=${m.machine.id}'
                                    '&date=${m.machine.nextServiceDue}',
                                  ),
                                  child: const Text('Schedule'),
                                ),
                                onTap: () =>
                                    context.push('/machine/${m.machine.id}'),
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _group(String title, Widget? content) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ListHeader(title),
      content ??
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
            child: Text(
              'Nothing here',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ),
    ],
  );
}
