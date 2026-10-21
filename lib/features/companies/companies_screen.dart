import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/repositories/company_repository.dart';
import '../sync/sync_badge.dart';

class CompaniesScreen extends ConsumerStatefulWidget {
  const CompaniesScreen({super.key});
  @override
  ConsumerState<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends ConsumerState<CompaniesScreen> {
  final _search = TextEditingController();
  bool _archived = false;
  CompanySort _sort = CompanySort.name;
  late Stream<List<CompanyListItem>> _stream;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _stream = ref
        .read(companyRepositoryProvider)
        .watchList(query: _search.text, archived: _archived, sort: _sort);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Companies'),
      actions: [
        PopupMenuButton<CompanySort>(
          tooltip: 'Sort',
          icon: const Icon(Icons.sort),
          initialValue: _sort,
          onSelected: (s) => setState(() {
            _sort = s;
            _reload();
          }),
          itemBuilder: (_) => const [
            PopupMenuItem(value: CompanySort.name, child: Text('Name (A–Z)')),
            PopupMenuItem(
              value: CompanySort.recent,
              child: Text('Recently visited'),
            ),
            PopupMenuItem(
              value: CompanySort.outstanding,
              child: Text('Highest balance due'),
            ),
          ],
        ),
        const SyncBadge(),
      ],
    ),
    floatingActionButton: FloatingActionButton.extended(
      heroTag: 'add-company',
      onPressed: () => context.push('/company/new'),
      icon: const Icon(Icons.add_business),
      label: const Text('Add company'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.xs),
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search name, phone or code',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _search.clear();
                        _reload();
                      }),
                    ),
            ),
            onChanged: (_) => setState(_reload),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Show archived'),
                selected: _archived,
                onSelected: (v) => setState(() {
                  _archived = v;
                  _reload();
                }),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBody(
            stream: _stream,
            builder: (context, items) {
              if (items.isEmpty) {
                return _search.text.isNotEmpty || _archived
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No matching companies',
                      )
                    : EmptyState(
                        icon: Icons.apartment,
                        title: 'No companies yet',
                        message:
                            'Add the companies you service. You can then add their machines and record visits.',
                        actionLabel: 'Add company',
                        onAction: () => context.push('/company/new'),
                      );
              }
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(indent: Gap.lg),
                itemBuilder: (context, i) => _CompanyTile(items[i]),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _CompanyTile extends StatelessWidget {
  const _CompanyTile(this.item);
  final CompanyListItem item;

  @override
  Widget build(BuildContext context) {
    final c = item.company;
    final sub = [
      if (c.city != null) c.city!,
      if (c.phone != null) c.phone!,
      '${item.machineCount} machine${item.machineCount == 1 ? '' : 's'}',
    ].join(' • ');
    return ListTile(
      onTap: () => context.push('/company/${c.id}'),
      leading: CircleAvatar(
        backgroundColor: context.colors.primaryContainer,
        child: Text(
          c.name.trim().isEmpty ? '?' : c.name.trim()[0].toUpperCase(),
          style: TextStyle(
            color: context.colors.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (item.lastVisit != null)
            Text(
              'Last visit ${Dates.display(item.lastVisit)}',
              style: context.text.bodySmall,
            ),
        ],
      ),
      trailing: item.outstanding > 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Due', style: context.text.labelSmall),
                Text(
                  Money.short(item.outstanding),
                  style: context.text.titleSmall?.copyWith(
                    color: context.status.onWarning,
                  ),
                ),
              ],
            )
          : (c.code == null
                ? null
                : Text(c.code!, style: context.text.labelMedium)),
    );
  }
}
