import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/local/app_database.dart';
import '../../data/sync/conflict_repository.dart';

final conflictRepositoryProvider = Provider(
  (ref) => ConflictRepository(ref.watch(databaseProvider)),
);

class ConflictsScreen extends ConsumerStatefulWidget {
  const ConflictsScreen({super.key});
  @override
  ConsumerState<ConflictsScreen> createState() => _ConflictsScreenState();
}

class _ConflictsScreenState extends ConsumerState<ConflictsScreen> {
  late final _stream = ref.read(conflictRepositoryProvider).watchOpen();

  static const _ignored = {
    'updated_at',
    'created_at',
    'server_rev',
    'rev',
    'server_updated_at',
    'updated_by_device',
    'business_id',
  };

  List<String> _differences(SyncConflict c) {
    final local = (jsonDecode(c.localData) as Map).cast<String, Object?>();
    final server = (jsonDecode(c.serverData) as Map? ?? {})
        .cast<String, Object?>();
    return [
      for (final k in local.keys)
        if (!_ignored.contains(k) &&
            '${local[k] ?? ''}' != '${server[k] ?? ''}')
          '${k.replaceAll('_', ' ')}: yours "${local[k] ?? ''}" • saved "${server[k] ?? ''}"',
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edits needing review')),
    body: StreamBody(
      stream: _stream,
      builder: (context, list) => list.isEmpty
          ? const EmptyState(
              icon: Icons.check_circle_outline,
              title: 'Nothing to review',
            )
          : ListView(
              padding: const EdgeInsets.all(Gap.lg),
              children: [
                const NoticeBanner(
                  message:
                      'These records were changed on another phone before your change was uploaded. '
                      'The newer saved version was kept. Choose what to do with your change.',
                ),
                const SizedBox(height: Gap.md),
                for (final c in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.md),
                    child: SectionCard(
                      title: c.tableName_.replaceAll('_', ' '),
                      icon: Icons.merge_type,
                      trailing: Text(
                        Dates.timestamp(c.detectedAt),
                        style: context.text.bodySmall,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final d in _differences(c))
                            Text(d, style: context.text.bodySmall),
                          if (_differences(c).isEmpty)
                            const Text('No visible differences.'),
                          const SizedBox(height: Gap.md),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => runGuarded(
                                    context,
                                    () => ref
                                        .read(conflictRepositoryProvider)
                                        .dismiss(c.id),
                                    success: 'Kept the saved version',
                                  ),
                                  child: const Text('Keep saved'),
                                ),
                              ),
                              const SizedBox(width: Gap.md),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () async {
                                    final ok = await confirmDialog(
                                      context,
                                      title: 'Use your version?',
                                      message:
                                          'Your change will replace the saved version on all phones.',
                                      confirmLabel: 'Use mine',
                                    );
                                    if (ok && context.mounted) {
                                      await runGuarded(
                                        context,
                                        () => ref
                                            .read(conflictRepositoryProvider)
                                            .keepMine(c),
                                        success:
                                            'Your version will be uploaded',
                                      );
                                    }
                                  },
                                  child: const Text('Use mine'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    ),
  );
}
