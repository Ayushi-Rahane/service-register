import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/base_repository.dart';
import '../../domain/enums.dart';
import '../companies/company_picker.dart';

class MachineFormScreen extends ConsumerStatefulWidget {
  const MachineFormScreen({
    super.key,
    this.id,
    this.companyId,
    this.returnResult = false,
  });
  final String? id;
  final String? companyId;
  final bool returnResult;

  @override
  ConsumerState<MachineFormScreen> createState() => _MachineFormScreenState();
}

class _MachineFormScreenState extends ConsumerState<MachineFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _manufacturer = TextEditingController();
  final _model = TextEditingController();
  final _serial = TextEditingController();
  final _location = TextEditingController();
  final _interval = TextEditingController();
  final _notes = TextEditingController();
  String? _companyId;
  MachineCategory _category = MachineCategory.pcb;
  MachineStatus _status = MachineStatus.operational;
  String? _installed, _warranty, _nextDue;
  bool _loading = true, _saving = false;

  @override
  void initState() {
    super.initState();
    _companyId = widget.companyId;
    _load();
  }

  Future<void> _load() async {
    if (widget.id != null) {
      final m = await ref.read(machineRepositoryProvider).get(widget.id!);
      if (m != null) {
        _companyId = m.companyId;
        _name.text = m.name;
        _manufacturer.text = m.manufacturer ?? '';
        _model.text = m.model ?? '';
        _serial.text = m.serialNumber ?? '';
        _location.text = m.location ?? '';
        _interval.text = m.serviceIntervalDays?.toString() ?? '';
        _notes.text = m.notes ?? '';
        _category = MachineCategory.fromDb(m.category);
        _status = MachineStatus.fromDb(m.status);
        _installed = m.installedOn;
        _warranty = m.warrantyUntil;
        _nextDue = m.nextServiceDue;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _manufacturer,
      _model,
      _serial,
      _location,
      _interval,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final id = await ref
          .read(machineRepositoryProvider)
          .save(
            MachinesCompanion(
              companyId: Value(_companyId!),
              name: Value(_name.text.trim()),
              category: Value(_category.db),
              manufacturer: Value(emptyToNull(_manufacturer.text)),
              model: Value(emptyToNull(_model.text)),
              serialNumber: Value(emptyToNull(_serial.text)),
              location: Value(emptyToNull(_location.text)),
              installedOn: Value(_installed),
              warrantyUntil: Value(_warranty),
              serviceIntervalDays: Value(int.tryParse(_interval.text.trim())),
              nextServiceDue: Value(_nextDue),
              status: Value(_status.db),
              notes: Value(emptyToNull(_notes.text)),
            ),
            id: widget.id,
          );
      if (!mounted) return;
      showMessage(
        context,
        widget.id == null ? 'Machine added' : 'Changes saved',
      );
      if (widget.returnResult) {
        Navigator.of(context).pop(id);
      } else {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, errorText(e), error: true);
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.id == null ? 'Add machine' : 'Edit machine'),
    ),
    bottomNavigationBar: BottomActionBar(
      child: FilledButton.icon(
        onPressed: _saving ? null : _save,
        icon: const Icon(Icons.check),
        label: Text(widget.id == null ? 'Save machine' : 'Save changes'),
      ),
    ),
    body: _loading
        ? const LoadingView()
        : Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(Gap.lg),
              children: [
                CompanyField(
                  companyId: _companyId,
                  enabled: widget.id == null && widget.companyId == null,
                  onChanged: (id) => setState(() => _companyId = id),
                ),
                AppTextField(
                  controller: _name,
                  label: 'Machine name',
                  required: true,
                  hint: 'e.g. PCB Drilling Machine 2',
                  autofocus: widget.id == null,
                ),
                Text('Category', style: context.text.labelLarge),
                const SizedBox(height: Gap.sm),
                ChoiceChips<MachineCategory>(
                  options: MachineCategory.values,
                  selected: _category,
                  labelOf: (c) => c.label,
                  onSelected: (c) => setState(() => _category = c),
                ),
                const SizedBox(height: Gap.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _manufacturer,
                        label: 'Manufacturer',
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: AppTextField(controller: _model, label: 'Model'),
                    ),
                  ],
                ),
                AppTextField(
                  controller: _serial,
                  label: 'Serial number',
                  helper: 'Leave blank if not known',
                  capitalization: TextCapitalization.characters,
                ),
                AppTextField(
                  controller: _location,
                  label: 'Location in factory',
                  hint: 'e.g. Shop floor 2, Bay 4',
                ),
                EnumDropdown<MachineStatus>(
                  label: 'Current status',
                  values: MachineStatus.values,
                  value: _status,
                  onChanged: (v) =>
                      setState(() => _status = v ?? MachineStatus.operational),
                ),
                DateField(
                  label: 'Installed / commissioned on',
                  value: _installed,
                  allowClear: true,
                  lastDate: DateTime.now(),
                  onChanged: (v) => setState(() => _installed = v),
                ),
                DateField(
                  label: 'Warranty valid until',
                  value: _warranty,
                  allowClear: true,
                  onChanged: (v) => setState(() => _warranty = v),
                ),
                AppTextField(
                  controller: _interval,
                  label: 'Preventive maintenance every (days)',
                  keyboardType: TextInputType.number,
                  helper:
                      'Used to suggest the next maintenance date after a routine visit',
                  validator: (v) => v.isEmpty || (int.tryParse(v) ?? 0) > 0
                      ? null
                      : 'Enter number of days',
                ),
                DateField(
                  label: 'Next maintenance due',
                  value: _nextDue,
                  allowClear: true,
                  onChanged: (v) => setState(() => _nextDue = v),
                ),
                AppTextField(
                  controller: _notes,
                  label: 'Notes',
                  maxLines: 4,
                  minLines: 2,
                ),
              ],
            ),
          ),
  );
}
