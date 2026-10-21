import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/csv.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../data/repositories/report_repository.dart';
import '../../domain/enums.dart';
import '../../domain/report_table.dart';
import '../../services/document_service.dart';
import '../../services/pdf/pdf_kit.dart';
import '../../services/pdf/report_pdfs.dart';
import '../companies/company_picker.dart';

enum _Period { thisMonth, lastMonth, thisFy, lastFy, custom }

class ReportViewScreen extends ConsumerStatefulWidget {
  const ReportViewScreen({
    super.key,
    required this.typeName,
    this.companyId,
    this.machineId,
  });
  final String typeName;
  final String? companyId;
  final String? machineId;

  @override
  ConsumerState<ReportViewScreen> createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends ConsumerState<ReportViewScreen> {
  late final ReportType _type = ReportType.values.byName(widget.typeName);
  _Period _period = _Period.thisMonth;
  late String _from, _to;
  late String? _companyId = widget.companyId;
  late String? _machineId = widget.machineId;
  MachineCategory? _category;
  ServiceType? _serviceType;
  Future<ReportTable>? _result;

  @override
  void initState() {
    super.initState();
    _setPeriod(
      _type == ReportType.monthlyBilling ? _Period.thisFy : _Period.thisMonth,
    );
    if (_machineId != null) {
      ref.read(machineRepositoryProvider).get(_machineId!).then((m) {
        if (m != null && mounted) setState(() => _companyId = m.companyId);
      });
      _setPeriod(_Period.custom, from: '2000-01-01', to: Dates.today());
    }
    if (!_type.needsMachine || _machineId != null) _run();
  }

  void _setPeriod(_Period p, {String? from, String? to}) {
    final now = Dates.todayDate();
    final fyStart = DateTime(now.month >= 4 ? now.year : now.year - 1, 4, 1);
    _period = p;
    switch (p) {
      case _Period.thisMonth:
        _from = Dates.monthStart(now);
        _to = Dates.monthEnd(now);
      case _Period.lastMonth:
        final last = DateTime(now.year, now.month - 1, 1);
        _from = Dates.monthStart(last);
        _to = Dates.monthEnd(last);
      case _Period.thisFy:
        _from = Dates.iso(fyStart);
        _to = Dates.iso(DateTime(fyStart.year + 1, 3, 31));
      case _Period.lastFy:
        _from = Dates.iso(DateTime(fyStart.year - 1, 4, 1));
        _to = Dates.iso(DateTime(fyStart.year, 3, 31));
      case _Period.custom:
        _from = from ?? _from;
        _to = to ?? _to;
    }
  }

  void _run() {
    setState(() {
      _result = ref
          .read(reportRepositoryProvider)
          .build(
            ReportRequest(
              type: _type,
              from: _from,
              to: _to,
              companyId: _companyId,
              machineId: _machineId,
              category: _category,
              serviceType: _serviceType,
            ),
          );
    });
  }

  Future<void> _exportCsv(ReportTable t) async {
    final name = '${DocumentService.safeName(t.title)}_${Dates.today()}.csv';
    await runGuarded(
      context,
      () => DocumentService.share(
        GeneratedDoc(
          name,
          Uint8List.fromList(utf8.encode(Csv.fromReport(t))),
          mimeType: 'text/csv',
        ),
      ),
    );
  }

  Future<void> _exportPdf(ReportTable t) async {
    try {
      final bytes = await buildReportPdf(
        t,
        ref.read(settingsProvider),
        await PdfFonts.load(),
      );
      if (!mounted) return;
      await context.push(
        '/pdf',
        extra: GeneratedDoc(
          '${DocumentService.safeName(t.title)}_${Dates.today()}.pdf',
          bytes,
        ),
      );
    } catch (e) {
      if (mounted) showMessage(context, errorText(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const periodLabels = {
      _Period.thisMonth: 'This month',
      _Period.lastMonth: 'Last month',
      _Period.thisFy: 'This financial year',
      _Period.lastFy: 'Last financial year',
      _Period.custom: 'Custom',
    };
    return Scaffold(
      appBar: AppBar(title: Text(_type.title)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.lg),
        children: [
          SectionCard(
            title: 'Filters',
            icon: Icons.tune,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_type.usesDates) ...[
                  Wrap(
                    spacing: Gap.sm,
                    runSpacing: Gap.sm,
                    children: [
                      for (final p in _Period.values)
                        ChoiceChip(
                          label: Text(periodLabels[p]!),
                          selected: _period == p,
                          onSelected: (_) async {
                            if (p == _Period.custom) {
                              final r = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                initialDateRange: DateTimeRange(
                                  start: Dates.parse(_from),
                                  end: Dates.parse(_to),
                                ),
                              );
                              if (r == null) return;
                              _setPeriod(
                                p,
                                from: Dates.iso(r.start),
                                to: Dates.iso(r.end),
                              );
                            } else {
                              _setPeriod(p);
                            }
                            _run();
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: Gap.sm),
                  Text(
                    '${Dates.display(_from)} – ${Dates.display(_to)}',
                    style: context.text.bodySmall,
                  ),
                  const SizedBox(height: Gap.md),
                ],
                if (_type.usesCompany || _type.needsMachine)
                  Row(
                    children: [
                      Expanded(
                        child: CompanyField(
                          companyId: _companyId,
                          onChanged: (id) {
                            _companyId = id;
                            _machineId = null;
                            if (!_type.needsMachine) _run();
                            setState(() {});
                          },
                        ),
                      ),
                      if (_companyId != null && !_type.needsMachine)
                        IconButton(
                          tooltip: 'All companies',
                          onPressed: () {
                            _companyId = null;
                            _run();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),
                if (_type.needsMachine)
                  MachineField(
                    companyId: _companyId,
                    machineId: _machineId,
                    onChanged: (id) {
                      _machineId = id;
                      if (id != null) _run();
                      setState(() {});
                    },
                  ),
                if (_type.usesCategoryAndType) ...[
                  EnumDropdown<MachineCategory>(
                    label: 'Machine category',
                    values: MachineCategory.values,
                    value: _category,
                    allowNone: true,
                    noneLabel: 'All categories',
                    onChanged: (v) {
                      _category = v;
                      _run();
                    },
                  ),
                  EnumDropdown<ServiceType>(
                    label: 'Service type',
                    values: ServiceType.values,
                    value: _serviceType,
                    allowNone: true,
                    noneLabel: 'All service types',
                    onChanged: (v) {
                      _serviceType = v;
                      _run();
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          if (_result == null)
            const EmptyState(
              icon: Icons.precision_manufacturing_outlined,
              title: 'Select a machine to see its history',
            )
          else
            FutureBuilder<ReportTable>(
              future: _result,
              builder: (context, snap) {
                if (snap.hasError) return ErrorView(message: '${snap.error}');
                if (!snap.hasData) return const LoadingView();
                final t = snap.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _exportCsv(t),
                            icon: const Icon(Icons.table_view),
                            label: const Text('Excel / CSV'),
                          ),
                        ),
                        const SizedBox(width: Gap.md),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _exportPdf(t),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('PDF'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Gap.md),
                    if (t.summary.isNotEmpty)
                      SectionCard(
                        child: Column(
                          children: [
                            for (final s in t.summary) AmountLine(s.$1, s.$2),
                          ],
                        ),
                      ),
                    const SizedBox(height: Gap.md),
                    _TablePreview(table: t),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TablePreview extends StatelessWidget {
  const _TablePreview({required this.table});
  final ReportTable table;

  @override
  Widget build(BuildContext context) {
    final t = table;
    if (t.rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(Gap.lg),
        child: Text(
          'No records for the selected filters.',
          textAlign: TextAlign.center,
        ),
      );
    }
    final shown = t.rows.take(200).toList();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(
                context.colors.surfaceContainerHighest,
              ),
              columnSpacing: 20,
              columns: [
                for (final c in t.columns)
                  DataColumn(label: Text(c.label), numeric: c.numeric),
              ],
              rows: [
                for (final r in shown)
                  DataRow(
                    cells: [
                      for (var i = 0; i < r.length; i++)
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 220),
                            child: Text(
                              t.display(i, r[i]),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                if (t.hasTotals)
                  DataRow(
                    color: WidgetStatePropertyAll(
                      context.colors.surfaceContainerHigh,
                    ),
                    cells: [
                      for (var i = 0; i < t.columns.length; i++)
                        DataCell(
                          Text(
                            t.display(i, t.totalsRow[i]),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          if (t.rows.length > shown.length)
            Padding(
              padding: const EdgeInsets.all(Gap.md),
              child: Text(
                'Showing ${shown.length} of ${t.rows.length} rows. Export to see all.',
              ),
            ),
        ],
      ),
    );
  }
}
