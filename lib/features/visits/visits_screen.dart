import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/repositories/visit_repository.dart';
import '../../domain/enums.dart';
import '../sync/sync_badge.dart';
import 'visit_tile.dart';

enum _Tab { upcoming, active, completed, all }

class VisitsScreen extends ConsumerStatefulWidget {
  const VisitsScreen({super.key});
  @override
  ConsumerState<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends ConsumerState<VisitsScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 4, vsync: this)..addListener(_onTab);
  final _search = TextEditingController();
  ServiceType? _type;
  DateTimeRange? _range;
  late Stream<List<VisitListItem>> _stream = _load();

  void _onTab() {
    if (!_tabs.indexIsChanging) setState(() => _stream = _load());
  }

  Stream<List<VisitListItem>> _load() {
    final tab = _Tab.values[_tabs.index];
    final from = _range == null ? null : Dates.iso(_range!.start);
    final to = _range == null ? null : Dates.iso(_range!.end);
    final f = switch (tab) {
      _Tab.upcoming => VisitFilter(
        statuses: const {VisitStatus.scheduled},
        newestFirst: false,
        serviceType: _type,
        query: _search.text,
        from: from,
        to: to,
      ),
      _Tab.active => VisitFilter(
        statuses: const {VisitStatus.inProgress},
        serviceType: _type,
        query: _search.text,
        from: from,
        to: to,
      ),
      _Tab.completed => VisitFilter(
        statuses: const {VisitStatus.completed},
        serviceType: _type,
        query: _search.text,
        from: from,
        to: to,
      ),
      _Tab.all => VisitFilter(
        serviceType: _type,
        query: _search.text,
        from: from,
        to: to,
      ),
    };
    return ref.read(visitRepositoryProvider).watchList(f);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _pickRange() async {
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _range,
    );
    if (r != null) {
      setState(() {
        _range = r;
        _stream = _load();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Service visits'),
      actions: [
        IconButton(
          tooltip: 'Calendar',
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () => context.push('/schedule'),
        ),
        const SyncBadge(),
      ],
      bottom: TabBar(
        controller: _tabs,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Scheduled'),
          Tab(text: 'In progress'),
          Tab(text: 'Completed'),
          Tab(text: 'All'),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      heroTag: 'visits-new',
      onPressed: () => context.push('/visit/new'),
      icon: const Icon(Icons.add),
      label: const Text('New visit'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, 0),
          child: TextField(
            controller: _search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Visit no., company, machine, problem…',
            ),
            onChanged: (_) => setState(() => _stream = _load()),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.sm,
            ),
            children: [
              FilterChip(
                avatar: const Icon(Icons.date_range, size: 18),
                label: Text(
                  _range == null
                      ? 'Any date'
                      : '${Dates.displayDate(_range!.start)} – ${Dates.displayDate(_range!.end)}',
                ),
                selected: _range != null,
                onSelected: (_) => _range == null
                    ? _pickRange()
                    : setState(() {
                        _range = null;
                        _stream = _load();
                      }),
              ),
              const SizedBox(width: Gap.sm),
              PopupMenuButton<ServiceType?>(
                onSelected: (t) => setState(() {
                  _type = t;
                  _stream = _load();
                }),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: null,
                    child: Text('All service types'),
                  ),
                  for (final t in ServiceType.values)
                    PopupMenuItem(value: t, child: Text(t.label)),
                ],
                child: Chip(
                  avatar: const Icon(Icons.filter_list, size: 18),
                  label: Text(_type?.label ?? 'All types'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBody(
            stream: _stream,
            builder: (context, items) => items.isEmpty
                ? const EmptyState(
                    icon: Icons.build_outlined,
                    title: 'No visits here',
                    // The floating "New visit" button is the action here.
                    message:
                        'Tap "New visit" to record one, or schedule one from a company.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 96),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(indent: Gap.lg),
                    itemBuilder: (_, i) =>
                        VisitTile(items[i], relativeDate: _tabs.index == 0),
                  ),
          ),
        ),
      ],
    ),
  );
}
