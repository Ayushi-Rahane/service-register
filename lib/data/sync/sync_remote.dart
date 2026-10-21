import 'dart:typed_data';

/// One local change sent to the server.
class PushChange {
  const PushChange({
    required this.opId,
    required this.table,
    required this.id,
    required this.baseRev,
    required this.data,
  });

  /// Unique per change; the server remembers applied op ids, so re-sending
  /// the same change (e.g. after a lost response) is a no-op.
  final String opId;
  final String table;
  final String id;

  /// Server revision the local edit was based on (0 = new record).
  final int baseRev;
  final Map<String, Object?> data;

  Map<String, Object?> toJson() => {
    'op_id': opId,
    'table': table,
    'id': id,
    'base_rev': baseRev,
    'data': data,
  };
}

enum PushStatus { applied, conflict, error }

class PushResult {
  const PushResult({
    required this.opId,
    required this.status,
    this.rev,
    this.serverRow,
    this.error,
  });

  factory PushResult.fromJson(Map<String, dynamic> j) => PushResult(
    opId: j['op_id'] as String,
    status: switch (j['status']) {
      'applied' => PushStatus.applied,
      'conflict' => PushStatus.conflict,
      _ => PushStatus.error,
    },
    rev: (j['rev'] as num?)?.toInt(),
    serverRow: (j['server_row'] as Map?)?.cast<String, Object?>(),
    error: j['error'] as String?,
  );

  final String opId;
  final PushStatus status;
  final int? rev;

  /// For conflicts: the current server version, which wins.
  final Map<String, Object?>? serverRow;
  final String? error;
}

/// Transport used by the sync engine. Implemented for Supabase and, in tests,
/// by an in-memory fake server with the same semantics.
abstract interface class SyncRemote {
  /// Business (tenant) id of the signed-in user; used for storage paths.
  Future<String> businessId();

  Future<List<PushResult>> push(String deviceId, List<PushChange> changes);

  /// Rows of [table] changed at or after [since] (server time), ordered by
  /// `server_updated_at`, paged with [offset]/[limit].
  Future<List<Map<String, Object?>>> pull(
    String table, {
    required DateTime since,
    required int offset,
    required int limit,
  });

  Future<void> uploadFile(String path, Uint8List bytes, String? mimeType);
  Future<Uint8List> downloadFile(String path);
}

/// Raised for transport failures (offline, timeouts, auth expiry).
class SyncTransportException implements Exception {
  SyncTransportException(this.message);
  final String message;
  @override
  String toString() => message;
}
