import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'sync_remote.dart';

/// [SyncRemote] backed by Supabase (PostgREST RPC + Storage). All access runs
/// as the signed-in user, so Row Level Security applies to every request.
class SupabaseRemote implements SyncRemote {
  SupabaseRemote(this.client);

  final SupabaseClient client;
  static const bucket = 'attachments';
  static const _timeout = Duration(seconds: 45);

  String? _businessId;

  Future<T> _guard<T>(Future<T> Function() body) async {
    if (client.auth.currentSession == null) {
      throw SyncTransportException('Not signed in');
    }
    try {
      return await body().timeout(_timeout);
    } on SocketException {
      throw SyncTransportException('No internet connection');
    } on TimeoutException {
      throw SyncTransportException('The server took too long to respond');
    } on AuthException catch (e) {
      throw SyncTransportException('Sign-in expired: ${e.message}');
    } on PostgrestException catch (e) {
      throw SyncTransportException('Server error: ${e.message}');
    } on StorageException catch (e) {
      throw SyncTransportException('Storage error: ${e.message}');
    }
  }

  @override
  Future<String> businessId() async {
    if (_businessId != null) return _businessId!;
    final id = await _guard(() => client.rpc<dynamic>('current_business_id'));
    if (id == null) {
      throw SyncTransportException('No business set up for this account');
    }
    return _businessId = id as String;
  }

  @override
  Future<List<PushResult>> push(
    String deviceId,
    List<PushChange> changes,
  ) async {
    final res = await _guard(
      () => client.rpc<dynamic>(
        'sync_push',
        params: {
          'p_device_id': deviceId,
          'p_changes': [for (final c in changes) c.toJson()],
        },
      ),
    );
    return [
      for (final r in (res as List))
        PushResult.fromJson((r as Map).cast<String, dynamic>()),
    ];
  }

  @override
  Future<List<Map<String, Object?>>> pull(
    String table, {
    required DateTime since,
    required int offset,
    required int limit,
  }) async {
    final rows = await _guard(
      () => client
          .from(table)
          .select()
          .gte('server_updated_at', since.toUtc().toIso8601String())
          .order('server_updated_at', ascending: true)
          .order('id', ascending: true)
          .range(offset, offset + limit - 1),
    );
    return [for (final r in rows) r.cast<String, Object?>()];
  }

  @override
  Future<void> uploadFile(String path, Uint8List bytes, String? mimeType) =>
      _guard(
        () => client.storage
            .from(bucket)
            .uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(upsert: true, contentType: mimeType),
            ),
      );

  @override
  Future<Uint8List> downloadFile(String path) =>
      _guard(() => client.storage.from(bucket).download(path));

  void resetCache() => _businessId = null;
}
