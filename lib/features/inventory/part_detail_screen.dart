import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../domain/enums.dart';
import '../providers.dart';

class PartDetailScreen extends ConsumerWidget {
  const PartDetailScreen({super.key, required this.id});
  final String id;

  Future<void> _movement(
    BuildContext context,
    WidgetRef ref,
    PartWithStock p,
    StockMovementKind kind,
  ) async {
    final form = GlobalKey<FormState>();
    final qty = TextEditingController();
    final cost = TextEditingController(
      text: Money.editable(p.part.purchasePaise),
    );
    final notes = TextEditingController();
    var date = Dates.today();
    var add = true;
    final opId = Ids.newId(); // retried submits are ignored
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            kind == StockMovementKind.purchase
                ? 'Record purchase'
                : 'Adjust stock',
          ),
          scrollable: true,
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kind == StockMovementKind.adjustment) ...[
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Add'),
                        icon: Icon(Icons.add),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Remove'),
                        icon: Icon(Icons.remove),
                      ),
                    ],
                    selected: {add},
                    onSelectionChanged: (s) => setState(() => add = s.first),
                  ),
                  const SizedBox(height: Gap.md),
                ],
                QtyField(controller: qty, unit: p.part.unit),
                if (kind == StockMovementKind.purchase)
                  MoneyField(controller: cost, label: 'Cost per unit'),
                DateField(
                  label: 'Date',
                  value: date,
                  onChanged: (v) => setState(() => date = v ?? date),
                ),
                AppTextField(
                  controller: notes,
                  label: kind == StockMovementKind.purchase
                      ? 'Supplier / bill no.'
                      : 'Reason',
                  required: kind == StockMovementKind.adjustment,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => form.currentState!.validate()
                  ? Navigator.pop(ctx, true)
                  : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final q = Qty.parse(qty.text)!;
    await runGuarded(
      context,
      () => ref
          .read(inventoryRepositoryProvider)
          .recordMovement(
            id: opId,
            partId: p.part.id,
            kind: kind,
            qtyMilli: kind == StockMovementKind.adjustment && !add ? -q : q,
            unitCostPaise: kind == StockMovementKind.purchase
                ? Money.tryParse(cost.text)
                : null,
            occurredOn: date,
            notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
          ),
      success: 'Stock updated',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(partProvider(id)),
    builder: (p) {
      if (p == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const EmptyState(
            icon: Icons.search_off,
            title: 'Part not found',
          ),
        );
      }
      final part = p.part;
      final inventory = ref.watch(
        settingsProvider.select((s) => s.inventoryEnabled),
      );
      final moves =
          ref.watch(partMovementsProvider(id)).value ?? const <MovementRow>[];
      return Scaffold(
        appBar: AppBar(
          title: Text(part.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: () => context.push('/part/$id/edit'),
            ),
            PopupMenuButton<String>(
              onSelected: (a) => runGuarded(
                context,
                () => ref
                    .read(inventoryRepositoryProvider)
                    .setArchived(id, a == 'archive'),
                success: a == 'archive' ? 'Part archived' : 'Part restored',
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: part.archivedAt == null ? 'archive' : 'restore',
                  child: Text(
                    part.archivedAt == null ? 'Archive part' : 'Restore part',
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: !inventory
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.lg,
                    Gap.sm,
                    Gap.lg,
                    Gap.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _movement(
                            context,
                            ref,
                            p,
                            StockMovementKind.adjustment,
                          ),
                          icon: const Icon(Icons.tune),
                          label: const Text('Adjust'),
                        ),
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _movement(
                            context,
                            ref,
                            p,
                            StockMovementKind.purchase,
                          ),
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Purchase'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        body: ListView(
          padding: const EdgeInsets.all(Gap.lg),
          children: [
            if (inventory)
              Row(
                children: [
                  Expanded(
                    child: KpiTile(
                      label: 'In stock',
                      value: '${Qty.format(p.stockMilli)} ${part.unit}',
                      icon: Icons.inventory_2_outlined,
                      color: p.isLow ? context.colors.error : null,
                      caption: part.minStockMilli > 0
                          ? 'Minimum ${Qty.format(part.minStockMilli)}'
                          : null,
                    ),
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: KpiTile(
                      label: 'Selling price',
                      value: part.sellingPaise == null
                          ? '-'
                          : Money.short(part.sellingPaise!),
                      icon: Icons.sell_outlined,
                      caption: part.purchasePaise == null
                          ? null
                          : 'Cost ${Money.short(part.purchasePaise!)}',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: Gap.md),
            SectionCard(
              title: 'Details',
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoRow('Part number', part.partNumber),
                  InfoRow('Category', part.category),
                  InfoRow('Unit', part.unit),
                  InfoRow(
                    'Supplier',
                    [
                      part.supplierName,
                      part.supplierContact,
                    ].whereType<String>().join(' • '),
                  ),
                  InfoRow('Notes', part.notes),
                ],
              ),
            ),
            if (inventory) ...[
              const ListHeader('Stock history'),
              if (moves.isEmpty) const Text('No stock movements yet'),
              Card(
                child: Column(
                  children: [
                    for (final m in moves)
                      ListTile(
                        leading: Icon(
                          m.movement.qtyMilli > 0
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: m.movement.qtyMilli > 0
                              ? context.status.onSuccess
                              : context.status.onWarning,
                        ),
                        title: Text(
                          StockMovementKind.fromDb(m.movement.kind).label +
                              (m.visitNo == null ? '' : ' • ${m.visitNo}'),
                        ),
                        subtitle: Text(
                          [
                            Dates.display(m.movement.occurredOn),
                            ?m.movement.notes,
                          ].join(' • '),
                        ),
                        trailing: Text(
                          '${m.movement.qtyMilli > 0 ? '+' : ''}${Qty.format(m.movement.qtyMilli)}',
                          style: context.text.titleSmall,
                        ),
                        onTap: m.movement.visitId == null
                            ? null
                            : () =>
                                  context.push('/visit/${m.movement.visitId}'),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}
