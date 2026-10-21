import 'dart:typed_data';

import 'package:service_register/data/sync/sync_remote.dart';

/// In-memory server mirroring the semantics of `public.sync_push` in
/// supabase/migrations (idempotent op ids, revisions, device rule).
class FakeRemote implements SyncRemote {
  final Map<String, Map<String, Map<String, Object?>>> tables = {};
  final Map<String, PushResult> appliedOps = {};
  final Map<String, Uint8List> files = {};
  int pushCalls = 0;
  bool offline = false;

  /// Apply the next push but "lose" the response (throw afterwards).
  bool loseNextResponse = false;
  DateTime _clock = DateTime.utc(2026, 10, 16, 8);

  DateTime _tick() => _clock = _clock.add(const Duration(seconds: 1));

  List<Map<String, Object?>> rows(String table) =>
      (tables[table] ?? {}).values.toList();

  /// Business of the signed-in user (tests switch it to simulate accounts).
  String business = 'biz-1';

  @override
  Future<String> businessId() async => business;

  @override
  Future<List<PushResult>> push(
    String deviceId,
    List<PushChange> changes,
  ) async {
    if (offline) throw SyncTransportException('No internet connection');
    pushCalls++;
    final results = <PushResult>[];
    for (final c in changes) {
      final prior = appliedOps[c.opId];
      if (prior != null) {
        results.add(prior);
        continue;
      }
      final t = tables.putIfAbsent(c.table, () => {});
      final existing = t[c.id];
      PushResult r;
      if (existing == null ||
          existing['rev'] == c.baseRev ||
          existing['updated_by_device'] == deviceId) {
        final rev = ((existing?['rev'] as int?) ?? 0) + 1;
        t[c.id] = {
          ...c.data,
          'business_id': business,
          'rev': rev,
          'server_updated_at': _tick().toIso8601String(),
          'updated_by_device': deviceId,
        };
        r = PushResult(opId: c.opId, status: PushStatus.applied, rev: rev);
      } else {
        r = PushResult(
          opId: c.opId,
          status: PushStatus.conflict,
          serverRow: existing,
        );
      }
      appliedOps[c.opId] = r;
      results.add(r);
    }
    if (loseNextResponse) {
      loseNextResponse = false;
      throw SyncTransportException('Connection reset');
    }
    return results;
  }

  /// Simulates an edit made on another phone.
  void editFromOtherDevice(
    String table,
    String id,
    Map<String, Object?> changes,
  ) {
    final row = tables[table]![id]!;
    tables[table]![id] = {
      ...row,
      ...changes,
      'rev': (row['rev'] as int) + 1,
      'server_updated_at': _tick().toIso8601String(),
      'updated_by_device': 'other-device',
    };
  }

  @override
  Future<List<Map<String, Object?>>> pull(
    String table, {
    required DateTime since,
    required int offset,
    required int limit,
  }) async {
    if (offline) throw SyncTransportException('No internet connection');
    final list =
        rows(table)
            .where(
              (r) => !DateTime.parse(
                r['server_updated_at'] as String,
              ).isBefore(since),
            )
            .toList()
          ..sort(
            (a, b) => (a['server_updated_at'] as String).compareTo(
              b['server_updated_at'] as String,
            ),
          );
    return list.skip(offset).take(limit).toList();
  }

  @override
  Future<void> uploadFile(
    String path,
    Uint8List bytes,
    String? mimeType,
  ) async {
    if (offline) throw SyncTransportException('No internet connection');
    files[path] = bytes;
  }

  @override
  Future<Uint8List> downloadFile(String path) async => files[path]!;
}
