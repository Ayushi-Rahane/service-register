import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/repositories/inventory_repository.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});
  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _q = TextEditingController();
  bool _low = false, _archived = false;
  late Stream<List<PartWithStock>> _stream = _load();

  Stream<List<PartWithStock>> _load() => ref
      .read(inventoryRepositoryProvider)
      .watchParts(query: _q.text, lowOnly: _low, archived: _archived);

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(
      settingsProvider.select((s) => s.inventoryEnabled),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Spare parts')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-part',
        onPressed: () => context.push('/part/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add part'),
      ),
      body: Column(
        children: [
          if (!enabled)
            const Padding(
              padding: EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 0),
              child: NoticeBanner(
                message:
                    'Stock tracking is off (Settings). The catalogue still helps you add parts to visits quickly.',
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 0),
            child: TextField(
              controller: _q,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search name, part no., category',
              ),
              onChanged: (_) => setState(() => _stream = _load()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.sm,
            ),
            child: Row(
              children: [
                if (enabled)
                  FilterChip(
                    label: const Text('Low stock only'),
                    selected: _low,
                    onSelected: (v) => setState(() {
                      _low = v;
                      _stream = _load();
                    }),
                  ),
                const SizedBox(width: Gap.sm),
                FilterChip(
                  label: const Text('Archived'),
                  selected: _archived,
                  onSelected: (v) => setState(() {
                    _archived = v;
                    _stream = _load();
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBody(
              stream: _stream,
              builder: (context, parts) => parts.isEmpty
                  ? EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: _low
                          ? 'No parts are low on stock'
                          : 'No spare parts yet',
                      message: _low
                          ? null
                          : 'Add the parts you commonly use, with their prices and stock.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 96),
                      itemCount: parts.length,
                      separatorBuilder: (_, _) => const Divider(indent: Gap.lg),
                      itemBuilder: (_, i) {
                        final p = parts[i];
                        return ListTile(
                          onTap: () => context.push('/part/${p.part.id}'),
                          title: Text(p.part.name),
                          subtitle: Text(
                            [
                              if (p.part.partNumber != null) p.part.partNumber!,
                              if (p.part.category != null) p.part.category!,
                              if (p.part.sellingPaise != null)
                                'Sell ${Money.format(p.part.sellingPaise!)}',
                            ].join(' • '),
                          ),
                          trailing: enabled
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${Qty.format(p.stockMilli)} ${p.part.unit}',
                                      style: context.text.titleSmall?.copyWith(
                                        color: p.isLow
                                            ? context.colors.error
                                            : null,
                                      ),
                                    ),
                                    if (p.isLow)
                                      Text(
                                        p.stockMilli < 0
                                            ? 'Below zero'
                                            : 'Low stock',
                                        style: context.text.labelSmall
                                            ?.copyWith(
                                              color: context.colors.error,
                                            ),
                                      ),
                                  ],
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
