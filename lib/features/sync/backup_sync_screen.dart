import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/env.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../data/sync/sync_controller.dart';
import '../../data/sync/sync_service.dart';
import '../../services/document_service.dart';
import '../providers.dart';

class BackupSyncScreen extends ConsumerStatefulWidget {
  const BackupSyncScreen({super.key});
  @override
  ConsumerState<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends ConsumerState<BackupSyncScreen> {
  late final Stream<Map<String, int>> _pending = ref
      .read(databaseProvider)
      .customSelect(
        'SELECT table_name, COUNT(*) AS n FROM sync_outbox GROUP BY table_name',
        readsFrom: {ref.read(databaseProvider).syncOutbox},
      )
      .watch()
      .map(
        (rows) => {
          for (final r in rows) r.read<String>('table_name'): r.read<int>('n'),
        },
      );
  bool _busy = false;

  static const _names = {
    'companies': 'Companies',
    'machines': 'Machines',
    'parts': 'Spare parts',
    'invoices': 'Invoices',
    'service_visits': 'Service visits',
    'visit_parts': 'Visit spare parts',
    'stock_movements': 'Stock changes',
    'invoice_items': 'Invoice items',
    'payments': 'Payments',
    'payment_allocations': 'Payment allocations',
    'reminders': 'Reminders',
    'attachments': 'Photos & documents',
    'audit_log': 'Change history',
  };

  Future<void> _busyRun(Future<void> Function() f) async {
    setState(() => _busy = true);
    try {
      await f();
    } catch (e) {
      if (mounted) showMessage(context, errorText(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() => _busyRun(() async {
    final doc = await ref.read(backupServiceProvider).exportBackup();
    await ref
        .read(settingsRepositoryProvider)
        .setValue(
          'last_manual_backup',
          DateTime.now().toUtc().toIso8601String(),
        );
    await DocumentService.share(
      doc,
      text: 'Service Register backup ${Dates.today()}',
    );
    if (mounted) setState(() {});
  });

  Future<void> _csv() => _busyRun(() async {
    final doc = await ref.read(backupServiceProvider).exportCsvZip();
    await DocumentService.share(doc);
  });

  Future<void> _restore() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
    );
    if (files.isEmpty || !mounted) return;
    // Works for a file path (phone) and in-memory contents (browser).
    final Uint8List bytes = await files.first.readAsBytes();
    if (!mounted) return;
    final backup = ref.read(backupServiceProvider);
    try {
      final summary = backup.inspect(bytes);
      if (!mounted) return;
      final ok = await confirmDialog(
        context,
        title: 'Replace all data on $thisDevice?',
        message:
            'Backup from ${Dates.timestamp(DateTime.parse(summary.exportedAt))} with '
            '${summary.counts['companies'] ?? 0} companies, ${summary.counts['service_visits'] ?? 0} visits, '
            '${summary.counts['invoices'] ?? 0} invoices and ${summary.files} files.\n\n'
            'Everything currently on $thisDevice will be replaced. Make a backup of the current data first if unsure.',
        confirmLabel: 'Restore',
        destructive: true,
      );
      if (!ok) return;
      await _busyRun(() async {
        final s = await backup.restore(bytes);
        final settings = await ref.read(settingsRepositoryProvider).load();
        await ref.read(settingsProvider.notifier).save(settings);
        if (mounted) {
          showMessage(
            context,
            'Restored ${s.records} records and ${s.files} files',
          );
        }
      });
    } on FormatException catch (e) {
      if (mounted) showMessage(context, e.message, error: true);
    }
  }

  Future<void> _wipe() async {
    final sync = ref.read(syncControllerProvider);
    final ok = await confirmDialog(
      context,
      title: 'Remove all data from $thisDevice?',
      message:
          '${sync.pending > 0 ? '${sync.pending} changes have NOT been uploaded and will be lost. ' : ''}'
          'All companies, visits, invoices, payments and photos will be deleted from $thisDevice. '
          'Cloud data (if any) is not affected. Save a backup file first if unsure.',
      confirmLabel: 'Remove everything',
      destructive: true,
    );
    if (!ok) return;
    await _busyRun(() async {
      await ref.read(backupServiceProvider).wipeLocal();
      if (mounted) showMessage(context, 'All data removed from $thisDevice');
    });
  }

  Future<void> _signOut(SyncStatus s) async {
    final auth = ref.read(authServiceProvider);
    if (s.pending > 0) {
      final ok = await confirmDialog(
        context,
        title: '${s.pending} changes not uploaded',
        message:
            'If you sign out now these changes stay only on $thisDevice and will be uploaded when you sign in again '
            'with the same account. Sign out anyway?',
        confirmLabel: 'Sign out',
        destructive: true,
      );
      if (!ok) return;
    }
    if (!mounted) return;
    await runGuarded(
      context,
      auth.signOut,
      success: 'Signed out. Your data is still on $thisDevice.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sync = ref.watch(syncControllerProvider);
    final auth = ref.watch(authServiceProvider);
    final user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & sync')),
      body: ListView(
        padding: const EdgeInsets.all(Gap.lg),
        children: [
          if (_busy) const LinearProgressIndicator(),
          SectionCard(
            title: 'Cloud backup',
            icon: Icons.cloud_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (sync.phase == SyncPhase.notConfigured) ...[
                  const Text(
                    'Cloud backup is not set up in this version of the app. Your data is saved on $thisDevice. '
                    'Use "Save backup file" below regularly and keep the file somewhere safe (Google Drive, email).',
                  ),
                ] else if (sync.phase == SyncPhase.signedOut) ...[
                  const Text(
                    'Sign in to back up automatically and to use the same data on a new phone.',
                  ),
                  const SizedBox(height: Gap.md),
                  FilledButton.icon(
                    onPressed: () => context.push('/sign-in'),
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in'),
                  ),
                ] else ...[
                  InfoRow('Signed in as', user?.email),
                  InfoRow('Status', switch (sync.phase) {
                    SyncPhase.syncing => 'Backing up…',
                    SyncPhase.error => 'Last attempt failed: ${sync.lastError}',
                    _ =>
                      sync.pending == 0
                          ? 'All changes backed up'
                          : '${sync.pending} changes waiting to upload',
                  }),
                  InfoRow(
                    'Last successful backup',
                    sync.lastSuccessAt == null
                        ? 'Not yet'
                        : Dates.timestamp(sync.lastSuccessAt!.toUtc()),
                  ),
                  if (sync.failing > 0)
                    NoticeBanner(
                      message:
                          '${sync.failing} change(s) were rejected by the server and will be retried. '
                          'If this continues, check the details below.',
                      danger: true,
                    ),
                  const SizedBox(height: Gap.sm),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: sync.phase == SyncPhase.syncing
                              ? null
                              : () async {
                                  final err = await ref
                                      .read(syncControllerProvider.notifier)
                                      .syncNow();
                                  if (context.mounted) {
                                    showMessage(
                                      context,
                                      err ?? 'Backup complete',
                                      error: err != null,
                                    );
                                  }
                                },
                          icon: const Icon(Icons.sync),
                          label: const Text('Sync now'),
                        ),
                      ),
                      const SizedBox(width: Gap.md),
                      OutlinedButton(
                        onPressed: () => _signOut(sync),
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                ],
                if (sync.conflicts > 0) ...[
                  const SizedBox(height: Gap.md),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/backup/conflicts'),
                    icon: const Icon(Icons.merge_type),
                    label: Text('${sync.conflicts} edit(s) need review'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          StreamBuilder<Map<String, int>>(
            stream: _pending,
            builder: (context, snap) {
              final m = snap.data ?? const {};
              return SectionCard(
                title: m.isEmpty
                    ? 'Nothing waiting to upload'
                    : 'Saved on $thisDevice, not yet uploaded',
                icon: m.isEmpty
                    ? Icons.cloud_done_outlined
                    : Icons.phone_android,
                child: m.isEmpty
                    ? Text(
                        sync.phase == SyncPhase.idle
                            ? 'Every record is in the cloud.'
                            : 'No pending changes recorded.',
                      )
                    : Column(
                        children: [
                          for (final e in m.entries)
                            AmountLine(_names[e.key] ?? e.key, '${e.value}'),
                        ],
                      ),
              );
            },
          ),
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'Backup file',
            icon: Icons.archive_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'A single file with all your records and photos. Works without internet or an account.',
                ),
                const SizedBox(height: Gap.md),
                FilledButton.tonalIcon(
                  onPressed: _busy ? null : _export,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Save backup file'),
                ),
                const SizedBox(height: Gap.sm),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _restore,
                  icon: const Icon(Icons.restore),
                  label: const Text('Restore from backup file'),
                ),
                const SizedBox(height: Gap.sm),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _csv,
                  icon: const Icon(Icons.table_view),
                  label: const Text('Export spreadsheets (CSV)'),
                ),
                const SizedBox(height: Gap.sm),
                TextButton.icon(
                  onPressed: _busy ? null : _wipe,
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: context.colors.error,
                  ),
                  label: Text(
                    'Remove all data from $thisDevice',
                    style: TextStyle(color: context.colors.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          const SectionCard(
            title: 'Changing to a new phone',
            icon: Icons.phonelink_setup,
            child: Text(
              'With cloud backup: install the app on the new phone and sign in with the same email. '
              'All records download automatically; photos download when you open them.\n\n'
              'Without cloud backup: on the old phone tap "Save backup file" and send the file to yourself '
              '(WhatsApp, email or Google Drive). On the new phone open this screen, tap "Restore from backup file" '
              'and choose that file.',
            ),
          ),
        ],
      ),
    );
  }
}
