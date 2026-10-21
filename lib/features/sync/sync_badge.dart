import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/env.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/sync_controller.dart';
import '../../data/sync/sync_service.dart';

/// App-bar icon showing whether everything is backed up.
class SyncBadge extends ConsumerWidget {
  const SyncBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(syncControllerProvider);
    final (icon, color, tip) = switch (s.phase) {
      SyncPhase.syncing => (
        Icons.cloud_sync_outlined,
        context.colors.primary,
        'Backing up…',
      ),
      SyncPhase.error => (
        Icons.cloud_off_outlined,
        context.colors.error,
        'Backup failed – tap for details',
      ),
      SyncPhase.idle when s.pending == 0 => (
        Icons.cloud_done_outlined,
        context.status.onSuccess,
        'All changes backed up',
      ),
      SyncPhase.idle => (
        Icons.cloud_upload_outlined,
        context.status.onWarning,
        '${s.pending} changes waiting to upload',
      ),
      _ => (
        Icons.phone_android,
        context.colors.onSurfaceVariant,
        'Saved on $thisDevice only',
      ),
    };
    return IconButton(
      tooltip: tip,
      onPressed: () => context.push('/backup'),
      icon: Badge(
        isLabelVisible: s.conflicts > 0,
        label: Text('${s.conflicts}'),
        child: Icon(icon, color: color),
      ),
    );
  }
}
