import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/env.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/sync_controller.dart';
import '../../data/sync/sync_service.dart';
import '../providers.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncControllerProvider);
    final lowStock =
        ref.watch(dashboardStatsProvider).value?.lowStockCount ?? 0;
    final inventory = ref.watch(
      settingsProvider.select((s) => s.inventoryEnabled),
    );
    final syncText = switch (sync.phase) {
      SyncPhase.notConfigured =>
        'Data is saved on $thisDevice. Make regular backups.',
      SyncPhase.signedOut => 'Not signed in – saved on $thisDevice only',
      SyncPhase.error => 'Last backup failed – tap to see why',
      SyncPhase.syncing => 'Backing up now…',
      SyncPhase.idle =>
        sync.pending == 0
            ? 'Everything is backed up'
            : '${sync.pending} changes waiting to upload',
    };
    Widget tile(
      IconData icon,
      String title,
      String? subtitle,
      String route, {
      Widget? trailing,
    }) => ListTile(
      leading: Icon(icon, color: context.colors.primary),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: () => context.push(route),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          tile(
            Icons.calendar_month_outlined,
            'Schedule & reminders',
            'Upcoming, missed and maintenance due',
            '/schedule',
          ),
          tile(
            Icons.inventory_2_outlined,
            'Spare parts & stock',
            inventory
                ? (lowStock > 0
                      ? '$lowStock low on stock'
                      : 'Catalogue and stock levels')
                : 'Parts catalogue',
            '/inventory',
            trailing: lowStock > 0 && inventory
                ? Badge(label: Text('$lowStock'))
                : null,
          ),
          tile(
            Icons.bar_chart,
            'Reports',
            'Billing, collections, history, parts — PDF & Excel',
            '/reports',
          ),
          tile(Icons.search, 'Search', 'Find anything', '/search'),
          const Divider(),
          tile(Icons.cloud_outlined, 'Backup & sync', syncText, '/backup'),
          tile(
            Icons.settings_outlined,
            'Settings',
            'Business details, invoices, tax, stock',
            '/settings',
          ),
          tile(
            Icons.chat_outlined,
            'Message templates',
            'Payment reminder text',
            '/settings/templates',
          ),
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'Service Register',
            applicationVersion: '1.0.0',
            aboutBoxChildren: [
              Text(
                'Records of companies, machines, service visits, invoices, payments and spare parts.\n\n'
                'Generated invoices are plain business documents. Check tax / GST requirements with your accountant.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
