import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/money.dart';
import '../../core/utils/quantity.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/base_repository.dart';

class PartFormScreen extends ConsumerStatefulWidget {
  const PartFormScreen({super.key, this.id});
  final String? id;
  @override
  ConsumerState<PartFormScreen> createState() => _PartFormScreenState();
}

class _PartFormScreenState extends ConsumerState<PartFormScreen> {
  final _form = GlobalKey<FormState>();
  final _c = {
    for (final k in [
      'name',
      'number',
      'category',
      'unit',
      'min',
      'purchase',
      'selling',
      'supplier',
      'contact',
      'notes',
      'opening',
    ])
      k: TextEditingController(),
  };
  bool _loading = true, _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.id != null) {
      final p = await ref.read(inventoryRepositoryProvider).getPart(widget.id!);
      if (p != null) {
        _c['name']!.text = p.name;
        _c['number']!.text = p.partNumber ?? '';
        _c['category']!.text = p.category ?? '';
        _c['unit']!.text = p.unit;
        _c['min']!.text = p.minStockMilli == 0
            ? ''
            : Qty.format(p.minStockMilli);
        _c['purchase']!.text = Money.editable(p.purchasePaise);
        _c['selling']!.text = Money.editable(p.sellingPaise);
        _c['supplier']!.text = p.supplierName ?? '';
        _c['contact']!.text = p.supplierContact ?? '';
        _c['notes']!.text = p.notes ?? '';
      }
    } else {
      _c['unit']!.text = 'pcs';
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? _v(String k) => emptyToNull(_c[k]!.text);

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final id = await ref
          .read(inventoryRepositoryProvider)
          .savePart(
            PartsCompanion(
              name: Value(_c['name']!.text.trim()),
              partNumber: Value(_v('number')),
              category: Value(_v('category')),
              unit: Value(_v('unit') ?? 'pcs'),
              minStockMilli: Value(Qty.tryParse(_c['min']!.text) ?? 0),
              purchasePaise: Value(Money.tryParse(_c['purchase']!.text)),
              sellingPaise: Value(Money.tryParse(_c['selling']!.text)),
              supplierName: Value(_v('supplier')),
              supplierContact: Value(_v('contact')),
              notes: Value(_v('notes')),
            ),
            id: widget.id,
            openingStockMilli: widget.id == null
                ? (Qty.tryParse(_c['opening']!.text) ?? 0)
                : 0,
          );
      if (!mounted) return;
      showMessage(context, widget.id == null ? 'Part added' : 'Changes saved');
      widget.id == null ? context.pushReplacement('/part/$id') : context.pop();
    } catch (e) {
      if (mounted) {
        showMessage(context, errorText(e), error: true);
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(
      settingsProvider.select((s) => s.inventoryEnabled),
    );
    String? qty(String v) => v.isEmpty || (Qty.tryParse(v) ?? -1) >= 0
        ? null
        : 'Enter a valid quantity';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add spare part' : 'Edit spare part'),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: const Icon(Icons.check),
          label: const Text('Save part'),
        ),
      ),
      body: _loading
          ? const LoadingView()
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.all(Gap.lg),
                children: [
                  AppTextField(
                    controller: _c['name']!,
                    label: 'Part name',
                    required: true,
                    autofocus: widget.id == null,
                    capitalization: TextCapitalization.words,
                  ),
                  AppTextField(
                    controller: _c['number']!,
                    label: 'Part number / SKU',
                    capitalization: TextCapitalization.characters,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _c['category']!,
                          label: 'Category',
                          hint: 'e.g. Relays',
                        ),
                      ),
                      const SizedBox(width: Gap.md),
                      SizedBox(
                        width: 120,
                        child: AppTextField(
                          controller: _c['unit']!,
                          label: 'Unit',
                          hint: 'pcs, m, kg',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MoneyField(
                          controller: _c['purchase']!,
                          label: 'Purchase price',
                        ),
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        child: MoneyField(
                          controller: _c['selling']!,
                          label: 'Selling price',
                        ),
                      ),
                    ],
                  ),
                  if (inventory) ...[
                    if (widget.id == null)
                      AppTextField(
                        controller: _c['opening']!,
                        label: 'Current stock (opening)',
                        keyboardType: TextInputType.number,
                        validator: qty,
                        helper: 'How many you have right now',
                      ),
                    AppTextField(
                      controller: _c['min']!,
                      label: 'Warn when stock falls to',
                      keyboardType: TextInputType.number,
                      validator: qty,
                      helper: 'Minimum stock level (0 = no warning)',
                    ),
                  ],
                  AppTextField(
                    controller: _c['supplier']!,
                    label: 'Supplier name',
                    capitalization: TextCapitalization.words,
                  ),
                  AppTextField(
                    controller: _c['contact']!,
                    label: 'Supplier contact',
                    keyboardType: TextInputType.phone,
                  ),
                  AppTextField(
                    controller: _c['notes']!,
                    label: 'Notes',
                    maxLines: 3,
                    minLines: 1,
                  ),
                ],
              ),
            ),
    );
  }
}
