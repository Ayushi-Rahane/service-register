import 'package:drift/drift.dart' show Value;
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
import '../../data/local/app_database.dart';
import '../../domain/enums.dart';
import '../companies/company_picker.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({
    super.key,
    this.id,
    this.companyId,
    this.invoiceId,
    this.kind,
  });
  final String? id;
  final String? companyId;
  final String? invoiceId;
  final String? kind;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _notes = TextEditingController();
  late final String _id = widget.id ?? Ids.newId();
  late ReminderKind _kind = ReminderKind.fromDb(widget.kind);
  late String? _companyId = widget.companyId;
  String? _invoiceId;
  String _date = Dates.addDays(Dates.today(), 1);
  String? _time;
  bool _loading = true, _saving = false;

  @override
  void initState() {
    super.initState();
    _invoiceId = widget.invoiceId;
    _load();
  }

  Future<void> _load() async {
    if (widget.id != null) {
      final r = await ref.read(reminderRepositoryProvider).get(widget.id!);
      if (r != null) {
        _title.text = r.title;
        _notes.text = r.notes ?? '';
        _kind = ReminderKind.fromDb(r.kind);
        _companyId = r.companyId;
        _invoiceId = r.invoiceId;
        _date = r.dueDate;
        _time = r.dueTime;
      }
    } else if (_invoiceId != null) {
      final inv = await ref
          .read(billingRepositoryProvider)
          .getInvoice(_invoiceId!);
      if (inv != null) {
        _title.text = 'Follow up payment for ${inv.invoice.invoiceNo}';
        _companyId ??= inv.invoice.companyId;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final ok = await runGuarded(
      context,
      () => ref
          .read(reminderRepositoryProvider)
          .save(
            RemindersCompanion(
              kind: Value(_kind.db),
              title: Value(_title.text.trim()),
              notes: Value(
                _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              ),
              dueDate: Value(_date),
              dueTime: Value(_time),
              companyId: Value(_companyId),
              invoiceId: Value(_invoiceId),
              status: Value(ReminderStatus.pending.db),
            ),
            id: _id,
          ),
      success: 'Reminder saved',
    );
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.id == null ? 'New reminder' : 'Edit reminder'),
    ),
    bottomNavigationBar: BottomActionBar(
      child: FilledButton.icon(
        onPressed: _saving ? null : _save,
        icon: const Icon(Icons.check),
        label: const Text('Save reminder'),
      ),
    ),
    body: _loading
        ? const LoadingView()
        : Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(Gap.lg),
              children: [
                ChoiceChips<ReminderKind>(
                  options: ReminderKind.values,
                  selected: _kind,
                  labelOf: (k) => k.label,
                  onSelected: (k) => setState(() => _kind = k),
                ),
                const SizedBox(height: Gap.lg),
                AppTextField(
                  controller: _title,
                  label: 'Reminder',
                  required: true,
                  hint: 'e.g. Call about AMC renewal',
                ),
                DateField(
                  label: 'Date',
                  required: true,
                  value: _date,
                  onChanged: (v) => setState(() => _date = v ?? _date),
                ),
                TimeField(
                  label: 'Time (optional)',
                  value: _time,
                  onChanged: (v) => setState(() => _time = v),
                ),
                if (_companyId == null)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final id = await pickCompany(context);
                      if (id != null) setState(() => _companyId = id);
                    },
                    icon: const Icon(Icons.apartment),
                    label: const Text('Link to a company (optional)'),
                  )
                else
                  CompanyField(
                    companyId: _companyId,
                    onChanged: (id) => setState(() => _companyId = id),
                  ),
                const SizedBox(height: Gap.md),
                AppTextField(
                  controller: _notes,
                  label: 'Notes',
                  maxLines: 3,
                  minLines: 1,
                ),
              ],
            ),
          ),
  );
}
