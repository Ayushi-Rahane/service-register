import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/company_repository.dart';
import '../machines/machine_form_screen.dart';
import 'company_form_screen.dart';

/// Full-height searchable list of active companies. Returns the chosen id.
Future<String?> pickCompany(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const _CompanyPickerSheet(),
    );

class _CompanyPickerSheet extends ConsumerStatefulWidget {
  const _CompanyPickerSheet();
  @override
  ConsumerState<_CompanyPickerSheet> createState() =>
      _CompanyPickerSheetState();
}

class _CompanyPickerSheetState extends ConsumerState<_CompanyPickerSheet> {
  final _q = TextEditingController();
  late Stream<List<CompanyListItem>> _stream = _load();

  Stream<List<CompanyListItem>> _load() => ref
      .read(companyRepositoryProvider)
      .watchList(query: _q.text, sort: CompanySort.recent);

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    heightFactor: 0.9,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
          child: TextField(
            controller: _q,
            autofocus: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search company name or phone',
            ),
            onChanged: (_) => setState(() => _stream = _load()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_business),
          title: const Text('Add new company'),
          onTap: () async {
            final id = await Navigator.of(context).push<String>(
              MaterialPageRoute(
                builder: (_) => const CompanyFormScreen(returnResult: true),
              ),
            );
            if (id != null && context.mounted) Navigator.pop(context, id);
          },
        ),
        const Divider(),
        Expanded(
          child: StreamBody(
            stream: _stream,
            builder: (context, list) => ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i].company;
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text([?c.city, ?c.phone].join(' • ')),
                  onTap: () => Navigator.pop(context, c.id),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

/// Form field showing the selected company; tap to change.
class CompanyField extends ConsumerWidget {
  const CompanyField({
    super.key,
    required this.companyId,
    required this.onChanged,
    this.enabled = true,
  });
  final String? companyId;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Company?>(
      future: companyId == null
          ? Future.value(null)
          : ref.read(companyRepositoryProvider).get(companyId!),
      builder: (context, snap) => Padding(
        padding: const EdgeInsets.only(bottom: Gap.md),
        child: FormField<String>(
          validator: (_) => companyId == null ? 'Select a company' : null,
          builder: (state) => InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: !enabled
                ? null
                : () async {
                    final id = await pickCompany(context);
                    if (id != null) {
                      onChanged(id);
                      state.didChange(id);
                    }
                  },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Company *',
                prefixIcon: const Icon(Icons.apartment),
                suffixIcon: enabled ? const Icon(Icons.arrow_drop_down) : null,
                errorText: state.errorText,
                enabled: enabled,
              ),
              isEmpty: companyId == null,
              child: Text(
                snap.data?.name ?? (companyId == null ? '' : '…'),
                style: context.text.bodyLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dropdown of the company's machines with an "Add machine" option.
class MachineField extends ConsumerWidget {
  const MachineField({
    super.key,
    required this.companyId,
    required this.machineId,
    required this.onChanged,
    this.enabled = true,
  });
  final String? companyId;
  final String? machineId;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  static const _addNew = '__add__';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (companyId == null) return const SizedBox.shrink();
    return FutureBuilder<List<Machine>>(
      key: ValueKey('$companyId-$machineId'),
      future: ref.read(machineRepositoryProvider).forCompany(companyId!),
      builder: (context, snap) {
        final machines = snap.data ?? const <Machine>[];
        final value = machines.any((m) => m.id == machineId) ? machineId : null;
        return Padding(
          padding: const EdgeInsets.only(bottom: Gap.md),
          child: DropdownButtonFormField<String?>(
            initialValue: value,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Machine',
              prefixIcon: Icon(Icons.precision_manufacturing_outlined),
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('No specific machine'),
              ),
              for (final m in machines)
                DropdownMenuItem<String?>(
                  value: m.id,
                  child: Text(
                    [
                      m.name,
                      if (m.serialNumber != null) 'S/N ${m.serialNumber}',
                    ].join('  •  '),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const DropdownMenuItem<String?>(
                value: _addNew,
                child: Text('+ Add a new machine'),
              ),
            ],
            onChanged: !enabled
                ? null
                : (v) async {
                    if (v == _addNew) {
                      final id = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => MachineFormScreen(
                            companyId: companyId,
                            returnResult: true,
                          ),
                        ),
                      );
                      onChanged(id ?? machineId);
                    } else {
                      onChanged(v);
                    }
                  },
          ),
        );
      },
    );
  }
}
