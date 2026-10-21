import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../domain/enums.dart';
import '../companies/company_picker.dart';

/// Quick form to plan a future visit.
class ScheduleVisitScreen extends ConsumerStatefulWidget {
  const ScheduleVisitScreen({
    super.key,
    this.companyId,
    this.machineId,
    this.date,
  });
  final String? companyId;
  final String? machineId;
  final String? date;

  @override
  ConsumerState<ScheduleVisitScreen> createState() =>
      _ScheduleVisitScreenState();
}

class _ScheduleVisitScreenState extends ConsumerState<ScheduleVisitScreen> {
  final _form = GlobalKey<FormState>();
  final _purpose = TextEditingController();
  final _notes = TextEditingController();
  final _id = Ids.newId(); // fixed id: double taps cannot create two visits
  late String? _companyId = widget.companyId;
  late String? _machineId = widget.machineId;
  late String _date = _initialDate();
  String? _time;
  ServiceType _type = ServiceType.routineMaintenance;
  bool _saving = false;

  String _initialDate() {
    final d = widget.date;
    if (d != null && d.compareTo(Dates.today()) >= 0) return d;
    return Dates.addDays(Dates.today(), 1);
  }

  @override
  void dispose() {
    _purpose.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final settings = ref.read(settingsProvider);
    try {
      await ref
          .read(visitRepositoryProvider)
          .schedule(
            id: _id,
            companyId: _companyId!,
            machineId: _machineId,
            date: _date,
            time: _time,
            serviceType: _type,
            purpose: _purpose.text.trim().isEmpty ? null : _purpose.text.trim(),
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
            technicianName: settings.technicianName.isEmpty
                ? null
                : settings.technicianName,
            visitPrefix: settings.visitPrefix,
          );
      if (!mounted) return;
      showMessage(context, 'Visit scheduled for ${Dates.display(_date)}');
      context.pop();
    } catch (e) {
      if (mounted) {
        showMessage(context, errorText(e), error: true);
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Schedule a visit')),
    bottomNavigationBar: BottomActionBar(
      child: FilledButton.icon(
        onPressed: _saving ? null : _save,
        icon: const Icon(Icons.event_available),
        label: const Text('Schedule visit'),
      ),
    ),
    body: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(Gap.lg),
        children: [
          CompanyField(
            companyId: _companyId,
            onChanged: (id) => setState(() {
              if (id != _companyId) _machineId = null;
              _companyId = id;
            }),
          ),
          MachineField(
            companyId: _companyId,
            machineId: _machineId,
            onChanged: (id) => setState(() => _machineId = id),
          ),
          DateField(
            label: 'Planned date',
            required: true,
            value: _date,
            firstDate: DateTime.now().subtract(const Duration(days: 1)),
            onChanged: (v) => setState(() => _date = v ?? _date),
          ),
          TimeField(
            label: 'Planned time (optional)',
            value: _time,
            onChanged: (v) => setState(() => _time = v),
          ),
          Text('Purpose', style: context.text.labelLarge),
          const SizedBox(height: Gap.sm),
          ChoiceChips<ServiceType>(
            options: ServiceType.values,
            selected: _type,
            labelOf: (t) => t.label,
            onSelected: (t) => setState(() => _type = t),
          ),
          const SizedBox(height: Gap.lg),
          AppTextField(
            controller: _purpose,
            label: 'What needs to be done',
            maxLines: 3,
            minLines: 1,
          ),
          AppTextField(
            controller: _notes,
            label: 'Notes',
            maxLines: 3,
            minLines: 1,
          ),
          const SizedBox(height: Gap.sm),
          Text(
            'A reminder notification is shown on the day (if notifications are allowed).',
            style: context.text.bodySmall,
          ),
        ],
      ),
    ),
  );
}
