import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/env.dart';
import '../../core/providers.dart';
import 'supabase_remote.dart';
import 'sync_remote.dart';
import 'sync_service.dart';

/// Owns automatic synchronisation and exposes its status to the UI.
class SyncController extends Notifier<SyncStatus> {
  SyncService? _service;
  Timer? _debounce;
  Timer? _periodic;
  final _subs = <StreamSubscription<Object?>>[];
  bool _online = true;

  SyncService? get service => _service;

  @override
  SyncStatus build() {
    final auth = ref.watch(authServiceProvider);
    final db = ref.watch(databaseProvider);
    ref.onDispose(_dispose);

    _subs.add(
      db
          .customSelect(
            'SELECT COUNT(*) AS n, SUM(CASE WHEN last_error IS NULL THEN 0 ELSE 1 END) AS f '
            'FROM sync_outbox',
            readsFrom: {db.syncOutbox},
          )
          .watchSingle()
          .listen((r) {
            final pending = r.read<int>('n');
            final failing = r.readNullable<int>('f') ?? 0;
            state = state.copyWith(pending: pending, failing: failing);
            if (pending > 0) _scheduleSync(const Duration(seconds: 5));
          }),
    );
    _subs.add(
      (db.selectOnly(db.syncConflicts)
            ..addColumns([db.syncConflicts.id.count()])
            ..where(db.syncConflicts.resolvedAt.isNull()))
          .map((r) => r.read(db.syncConflicts.id.count()) ?? 0)
          .watchSingle()
          .listen((n) => state = state.copyWith(conflicts: n)),
    );

    if (!auth.configured) {
      return const SyncStatus(phase: SyncPhase.notConfigured);
    }

    _subs.add(
      auth.signedInChanges.listen((signedIn) {
        _service = signedIn ? _buildService() : null;
        state = state.copyWith(
          phase: signedIn ? SyncPhase.idle : SyncPhase.signedOut,
        );
        if (signedIn) _scheduleSync(const Duration(seconds: 2));
      }),
    );
    try {
      _subs.add(
        Connectivity().onConnectivityChanged.listen((results) {
          final online = results.any((r) => r != ConnectivityResult.none);
          if (online && !_online) _scheduleSync(const Duration(seconds: 3));
          _online = online;
        }),
      );
    } catch (_) {
      // Connectivity plugin unavailable (tests): periodic sync still works.
    }
    _periodic = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _scheduleSync(Duration.zero),
    );

    unawaited(_loadLastSuccess());
    if (auth.signedIn) {
      _service = _buildService();
      _scheduleSync(const Duration(seconds: 3));
      return const SyncStatus(phase: SyncPhase.idle);
    }
    return const SyncStatus(phase: SyncPhase.signedOut);
  }

  /// Local data belongs to the first account that synced it. A different
  /// account must never receive (or mix with) another account's records.
  Future<String?> _accountMismatch() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return null;
    final settings = ref.read(settingsRepositoryProvider);
    final owner = await settings.getValue(ownerKey);
    if (owner == null) {
      await settings.setValue(ownerKey, user.id);
      return null;
    }
    if (owner == user.id) return null;
    return 'This phone holds records of another account. Sign in with that account, '
        'or remove the data from $thisDevice first (Backup & sync).';
  }

  static const ownerKey = 'sync_owner_user_id';

  SyncService _buildService() => SyncService(
    db: ref.read(databaseProvider),
    remote: SupabaseRemote(ref.read(authServiceProvider).client!),
    settings: ref.read(settingsRepositoryProvider),
    attachments: ref.read(attachmentRepositoryProvider),
  );

  void _scheduleSync(Duration delay) {
    if (_service == null) return;
    _debounce?.cancel();
    _debounce = Timer(delay, () => unawaited(syncNow(silent: true)));
  }

  /// Called when the app returns to the foreground.
  void onResume() => _scheduleSync(const Duration(seconds: 1));

  /// Called when the app goes to the background or is being closed: upload
  /// waiting changes right away instead of after the usual short delay.
  void onBackground() {
    if (_service == null || state.pending == 0) return;
    _debounce?.cancel();
    unawaited(syncNow(silent: true));
  }

  /// Shows the time of the last successful backup, also after a restart.
  Future<void> _loadLastSuccess() async {
    final v = await ref
        .read(settingsRepositoryProvider)
        .getValue('last_sync_ok');
    final t = v == null ? null : DateTime.tryParse(v);
    if (t != null && state.lastSuccessAt == null) {
      state = state.copyWith(lastSuccessAt: t.toLocal());
    }
  }

  /// Runs a sync. Returns an error message, or null on success.
  Future<String?> syncNow({bool silent = false}) async {
    final svc = _service;
    if (svc == null) {
      return state.phase == SyncPhase.notConfigured
          ? 'Cloud backup is not set up in this build'
          : 'Sign in to back up your data';
    }
    if (state.phase == SyncPhase.syncing) return null;
    final mismatch = await _accountMismatch();
    if (mismatch != null) {
      state = state.copyWith(phase: SyncPhase.error, lastError: mismatch);
      return mismatch;
    }
    state = state.copyWith(phase: SyncPhase.syncing);
    try {
      await svc.syncNow();
      state = state.copyWith(
        phase: SyncPhase.idle,
        lastSuccessAt: DateTime.now(),
        clearError: true,
      );
      return null;
    } on SyncTransportException catch (e) {
      state = state.copyWith(phase: SyncPhase.error, lastError: e.message);
      return e.message;
    } catch (e) {
      state = state.copyWith(phase: SyncPhase.error, lastError: '$e');
      return '$e';
    }
  }

  void _dispose() {
    _debounce?.cancel();
    _periodic?.cancel();
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    _subs.clear();
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncStatus>(
  SyncController.new,
);
