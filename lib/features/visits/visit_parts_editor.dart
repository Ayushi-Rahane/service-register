import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../core/widgets/form_fields.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../domain/billing.dart';
import '../../domain/drafts.dart';

/// List of spare parts on a visit with add / edit / remove.
class VisitPartsEditor extends ConsumerWidget {
  const VisitPartsEditor({
    super.key,
    required this.parts,
    required this.onChanged,
    this.enabled = true,
  });
  final List<VisitPartDraft> parts;
  final VoidCallback onChanged;
  final bool enabled;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final inventory = ref.read(settingsProvider).inventoryEnabled;
    final choice = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const _CataloguePicker(),
    );
    if (!context.mounted || choice == null) return;
    VisitPartDraft draft;
    if (choice is PartWithStock) {
      draft = VisitPartDraft(
        partId: choice.part.id,
        partName: choice.part.name,
        partNumber: choice.part.partNumber,
        unitCostPaise: choice.part.purchasePaise,
        unitPricePaise: choice.part.sellingPaise ?? 0,
      );
    } else {
      draft = VisitPartDraft(partName: '', addToCatalogue: inventory);
    }
    final edited = await _editPart(
      context,
      draft,
      isNew: true,
      inventoryEnabled: inventory,
    );
    if (edited != null) {
      parts.add(edited);
      onChanged();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = parts.fold(0, (s, p) => s + p.lineTotal);
    final inventory = ref.watch(
      settingsProvider.select((s) => s.inventoryEnabled),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (parts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: Text(
              'No spare parts added',
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        for (var i = 0; i < parts.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: Gap.sm),
            child: ListTile(
              onTap: !enabled
                  ? null
                  : () async {
                      final edited = await _editPart(
                        context,
                        parts[i],
                        inventoryEnabled: inventory,
                      );
                      if (edited != null) onChanged();
                    },
              title: Text(parts[i].partName),
              subtitle: Text(
                '${Qty.format(parts[i].qtyMilli)} × ${Money.format(parts[i].unitPricePaise)}'
                '${parts[i].partNumber == null ? '' : '  •  ${parts[i].partNumber}'}'
                '${parts[i].partId == null ? (parts[i].addToCatalogue ? '  •  will be added to catalogue' : '  •  not in catalogue') : ''}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Money.format(parts[i].lineTotal),
                    style: context.text.titleSmall,
                  ),
                  if (enabled)
                    IconButton(
                      tooltip: 'Remove',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        parts.removeAt(i);
                        onChanged();
                      },
                    ),
                ],
              ),
            ),
          ),
        if (parts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Row(
              children: [
                const Expanded(child: Text('Spare parts total')),
                Text(Money.format(total), style: context.text.titleMedium),
              ],
            ),
          ),
        if (enabled)
          OutlinedButton.icon(
            onPressed: () => _add(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add spare part'),
          ),
      ],
    );
  }
}

/// Edits [p] in a dialog; returns it (mutated) or null when cancelled.
Future<VisitPartDraft?> _editPart(
  BuildContext context,
  VisitPartDraft p, {
  bool isNew = false,
  required bool inventoryEnabled,
}) {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(text: p.partName);
  final number = TextEditingController(text: p.partNumber ?? '');
  final qty = TextEditingController(text: Qty.format(p.qtyMilli));
  final price = TextEditingController(text: Money.editable(p.unitPricePaise));
  final cost = TextEditingController(text: Money.editable(p.unitCostPaise));
  var addToCatalogue = p.addToCatalogue;
  return showDialog<VisitPartDraft>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final line = Billing.lineTotal(
          Qty.tryParse(qty.text) ?? 0,
          Money.tryParse(price.text) ?? 0,
        );
        return AlertDialog(
          title: Text(isNew ? 'Add spare part' : 'Edit spare part'),
          scrollable: true,
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: name,
                  label: 'Part name',
                  required: true,
                  autofocus: p.partName.isEmpty,
                  capitalization: TextCapitalization.words,
                ),
                AppTextField(
                  controller: number,
                  label: 'Part number',
                  capitalization: TextCapitalization.characters,
                ),
                QtyField(controller: qty, onChanged: (_) => setState(() {})),
                MoneyField(
                  controller: price,
                  label: 'Selling price per unit',
                  onChanged: (_) => setState(() {}),
                ),
                MoneyField(
                  controller: cost,
                  label: 'Purchase cost per unit (optional)',
                  helper: 'For your profit reports; not shown to the customer',
                ),
                if (p.partId == null && inventoryEnabled)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: addToCatalogue,
                    onChanged: (v) =>
                        setState(() => addToCatalogue = v ?? false),
                    title: const Text(
                      'Add this part to the inventory catalogue',
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Line total: ${Money.format(line)}',
                    style: ctx.text.titleSmall,
                  ),
                ),
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
                p
                  ..partName = name.text.trim()
                  ..partNumber = number.text.trim().isEmpty
                      ? null
                      : number.text.trim()
                  ..qtyMilli = Qty.parse(qty.text)!
                  ..unitPricePaise = Money.parse(price.text) ?? 0
                  ..unitCostPaise = Money.parse(cost.text)
                  ..addToCatalogue = addToCatalogue;
                Navigator.pop(ctx, p);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ),
  );
}

class _CataloguePicker extends ConsumerStatefulWidget {
  const _CataloguePicker();
  @override
  ConsumerState<_CataloguePicker> createState() => _CataloguePickerState();
}

class _CataloguePickerState extends ConsumerState<_CataloguePicker> {
  final _q = TextEditingController();
  late Stream<List<PartWithStock>> _stream = _load();

  Stream<List<PartWithStock>> _load() =>
      ref.read(inventoryRepositoryProvider).watchParts(query: _q.text);

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(
      settingsProvider.select((s) => s.inventoryEnabled),
    );
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
            child: TextField(
              controller: _q,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search parts catalogue',
              ),
              onChanged: (_) => setState(() => _stream = _load()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Part not in the list'),
            subtitle: const Text('Type the part details yourself'),
            onTap: () => Navigator.pop(context, 'custom'),
          ),
          const Divider(),
          Expanded(
            child: StreamBody(
              stream: _stream,
              builder: (context, parts) => ListView.builder(
                itemCount: parts.length,
                itemBuilder: (_, i) {
                  final p = parts[i];
                  return ListTile(
                    title: Text(p.part.name),
                    subtitle: Text(
                      [
                        if (p.part.partNumber != null) p.part.partNumber!,
                        if (p.part.sellingPaise != null)
                          Money.format(p.part.sellingPaise!),
                      ].join(' • '),
                    ),
                    trailing: inventory
                        ? Text(
                            'Stock ${Qty.format(p.stockMilli)} ${p.part.unit}',
                            style: TextStyle(
                              color: p.isLow ? context.colors.error : null,
                            ),
                          )
                        : null,
                    onTap: () => Navigator.pop(context, p),
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
