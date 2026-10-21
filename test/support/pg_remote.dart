import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:service_register/data/sync/sync_remote.dart';

/// [SyncRemote] talking to a real local PostgreSQL database that has the
/// Supabase migrations applied (with a stub `auth` schema). Rows come back
/// exactly as Postgres serialises them (`to_jsonb`), like Supabase's API.
///
/// Used only when `psql`/`createdb` are available (see [PgRemote.available]).
class PgRemote implements SyncRemote {
  PgRemote._(this.database, this.userId);

  final String database;
  final String userId;

  static bool get available {
    try {
      return Process.runSync('pg_isready', const []).exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Creates a throw-away database with the schema and one signed-up user.
  static Future<PgRemote> create() async {
    final db = 'sr_sync_${DateTime.now().microsecondsSinceEpoch}';
    await _run(['createdb', db]);
    for (final f in [
      'supabase/tests/auth_stub.sql',
      'supabase/migrations/20261016000000_initial_schema.sql',
    ]) {
      await _psql(db, File(f).readAsStringSync());
    }
    const user = '00000000-0000-0000-0000-00000000c0de';
    await _psql(
      db,
      "insert into auth.users (id, email) values ('$user', 'test@example.com');",
    );
    return PgRemote._(db, user);
  }

  Future<void> drop() => _run(['dropdb', '--if-exists', database]);

  static Future<String> _run(List<String> cmd) async {
    final r = await Process.run(cmd.first, cmd.sublist(1));
    if (r.exitCode != 0) throw StateError('${cmd.first} failed: ${r.stderr}');
    return r.stdout as String;
  }

  static Future<String> _psql(String db, String sql) async {
    final file = File(
      '${Directory.systemTemp.path}/sr_${DateTime.now().microsecondsSinceEpoch}.sql',
    )..writeAsStringSync(sql);
    try {
      return await _run([
        'psql',
        '-X',
        '-q',
        '-At',
        '-v',
        'ON_ERROR_STOP=1',
        '-d',
        db,
        '-f',
        file.path,
      ]);
    } finally {
      file.deleteSync();
    }
  }

  /// Runs [query] as the signed-in user (RLS applies) and returns its text.
  Future<String> _asUser(String query) => _psql(database, '''
set role authenticated;
set request.jwt.claim.sub = '$userId';
$query
''');

  @override
  Future<String> businessId() async =>
      (await _asUser('select public.current_business_id();')).trim();

  @override
  Future<List<PushResult>> push(
    String deviceId,
    List<PushChange> changes,
  ) async {
    final json = jsonEncode([for (final c in changes) c.toJson()]);
    final out = await _asUser(
      "select public.sync_push('$deviceId', \$json\$$json\$json\$::jsonb);",
    );
    return [
      for (final r in jsonDecode(out.trim()) as List)
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
    final out = await _asUser('''
select coalesce(json_agg(r), '[]'::json) from (
  select to_jsonb(t) as r from public."$table" t
  where t.server_updated_at >= '${since.toUtc().toIso8601String()}'
  order by t.server_updated_at, t.id
  offset $offset limit $limit
) s;''');
    return [
      for (final r in jsonDecode(out.trim()) as List)
        (r as Map).cast<String, Object?>(),
    ];
  }

  @override
  Future<void> uploadFile(
    String path,
    Uint8List bytes,
    String? mimeType,
  ) async {}

  @override
  Future<Uint8List> downloadFile(String path) async => Uint8List(0);
}
