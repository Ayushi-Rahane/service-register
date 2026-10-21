import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/report_repository.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static IconData _icon(ReportType t) => switch (t) {
    ReportType.businessSummary => Icons.insights,
    ReportType.companyHistory => Icons.apartment,
    ReportType.machineHistory => Icons.precision_manufacturing_outlined,
    ReportType.monthlyBilling => Icons.calendar_month,
    ReportType.outstanding => Icons.account_balance_wallet_outlined,
    ReportType.payments => Icons.payments_outlined,
    ReportType.partsUsed => Icons.settings_input_component_outlined,
    ReportType.stockSummary => Icons.inventory_2_outlined,
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reports')),
    body: ListView(
      padding: const EdgeInsets.all(Gap.lg),
      children: [
        for (final t in ReportType.values)
          Card(
            margin: const EdgeInsets.only(bottom: Gap.sm),
            child: ListTile(
              leading: CircleAvatar(child: Icon(_icon(t))),
              title: Text(t.title),
              subtitle: Text(t.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/reports/${t.name}'),
            ),
          ),
      ],
    ),
  );
}
