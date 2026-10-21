import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/utils/ids.dart';
import '../local/app_database.dart';
import '../repositories/attachment_repository.dart';
import '../repositories/settings_repository.dart';
import 'sync_remote.dart';

enum SyncPhase { notConfigured, signedOut, idle, syncing, error }

class SyncStatus {
  const SyncStatus({
    required this.phase,
    this.pending = 0,
    this.failing = 0,
    this.conflicts = 0,
    this.lastSuccessAt,
    this.lastError,
  });
  final SyncPhase phase;

  /// Local changes not yet confirmed by the server.
  final int pending;

  /// Pending changes that were rejected and are waiting to retry.
  final int failing;
  final int conflicts;
  final DateTime? lastSuccessAt;
  final String? lastError;

  bool get allSynced => pending == 0 && phase == SyncPhase.idle;

  SyncStatus copyWith({
    SyncPhase? phase,
    int? pending,
    int? failing,
    int? conflicts,
    DateTime? lastSuccessAt,
    String? lastError,
    bool clearError = false,
  }) => SyncStatus(
    phase: phase ?? this.phase,
    pending: pending ?? this.pending,
    failing: failing ?? this.failing,
    conflicts: conflicts ?? this.conflicts,
    lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
    lastError: clearError ? null : (lastError ?? this.lastError),
  );
}

class SyncReport {
  SyncReport();
  int pushed = 0;
  int pulled = 0;
  int conflicts = 0;
  int errors = 0;
  @override
  String toString() =>
      'pushed $pushed, pulled $pulled, conflicts $conflicts, errors $errors';
}

/// Offline-first synchronisation.
///
/// * Push: every outbox entry is sent with its op id and the server revision
///   the edit was based on. The server applies it only if nobody else changed
///   the row since (or the newer revision came from this same device);
///   otherwise it reports a conflict, the server version wins locally and the
///   local version is kept in `sync_conflicts` for review. Op ids make retries
///   idempotent; client-generated UUIDs make re-inserts upserts.
/// * Pull: per table, rows changed since the last cursor (with an overlap
///   window) are applied unless the local row has unpushed changes or is
///   already at that revision.
class SyncService {
  SyncService({
    required this.db,
    required this.remote,
    required this.settings,
    required this.attachments,
    this.batchSize = 100,
    this.pageSize = 500,
  });

  final AppDatabase db;
  final SyncRemote remote;
  final SettingsRepository settings;
  final AttachmentRepository attachments;
  final int batchSize;
  final int pageSize;

  static const pullOverlap = Duration(minutes: 2);

  /// Columns that exist only on the device.
  static const localOnlyColumns = {'server_rev', 'local_path'};

  /// Columns that exist only on the server.
  static const serverOnlyColumns = {
    'business_id',
    'rev',
    'server_updated_at',
    'updated_by_device',
  };

  Future<void>? _running;

  late final Map<String, TableInfo<Table, dynamic>> _tables = {
    for (final t in db.syncedTables) t.actualTableName: t,
  };

  List<String> get tableOrder => [
    for (final t in db.syncedTables) t.actualTableName,
  ];

  /// Runs one sync cycle. Concurrent calls share the running cycle.
  Future<SyncReport> syncNow() async {
    if (_running != null) {
      await _running;
      return SyncReport();
    }
    final report = SyncReport();
    final completer = Completer<void>();
    _running = completer.future;
    try {
      await _uploadAttachments();
      await _push(report);
      await _pull(report);
      await settings.setValue(
        'last_sync_ok',
        DateTime.now().toUtc().toIso8601String(),
      );
      await settings.setValue('last_sync_error', null);
    } catch (e) {
      await settings.setValue('last_sync_error', '$e');
      rethrow;
    } finally {
      completer.complete();
      _running = null;
    }
    return report;
  }

  // ---------------------------------------------------------------------------
  // Push
  // ---------------------------------------------------------------------------

  Future<Map<String, Object?>?> readLocalRow(String table, String id) async {
    final row = await db
        .customSelect(
          'SELECT * FROM "$table" WHERE id = ?',
          variables: [Variable.withString(id)],
        )
        .getSingleOrNull();
    return row?.data;
  }

  Future<void> _push(SyncReport report) async {
    final deviceId = await settings.deviceId();
    while (true) {
      final now = DateTime.now().toUtc();
      final entries =
          await (db.select(db.syncOutbox)..where(
                (t) =>
                    t.nextAttemptAt.isNull() |
                    t.nextAttemptAt.isSmallerOrEqualValue(now),
              ))
              .get();
      entries.sort((a, b) {
        final c = tableOrder
            .indexOf(a.tableName_)
            .compareTo(tableOrder.indexOf(b.tableName_));
        return c != 0 ? c : a.queuedAt.compareTo(b.queuedAt);
      });
      final changes = <PushChange>[];
      final skipped = <OutboxEntry>[];
      for (final e in entries) {
        if (changes.length >= batchSize) break;
        if (!_tables.containsKey(e.tableName_)) {
          await _deleteOutbox(e.tableName_, e.rowId, e.opId);
          continue;
        }
        final row = await readLocalRow(e.tableName_, e.rowId);
        if (row == null) {
          await _deleteOutbox(e.tableName_, e.rowId, e.opId);
          continue;
        }
        // Attachment rows wait until their file is in storage.
        if (e.tableName_ == 'attachments' && row['storage_path'] == null) {
          skipped.add(e);
          continue;
        }
        changes.add(
          PushChange(
            opId: e.opId,
            table: e.tableName_,
            id: e.rowId,
            baseRev: (row['server_rev'] as int?) ?? 0,
            data: {
              for (final kv in row.entries)
                if (!localOnlyColumns.contains(kv.key)) kv.key: kv.value,
            },
          ),
        );
      }
      if (changes.isEmpty) return;

      final List<PushResult> results;
      try {
        results = await remote.push(deviceId, changes);
      } on SyncTransportException {
        rethrow;
      } catch (e) {
        throw SyncTransportException('Upload failed: $e');
      }
      final byOp = {for (final r in results) r.opId: r};
      var progressed = false;
      for (final c in changes) {
        final r = byOp[c.opId];
        if (r == null) continue;
        switch (r.status) {
          case PushStatus.applied:
            await db.transaction(() async {
              await db.customUpdate(
                'UPDATE "${c.table}" SET server_rev = ? WHERE id = ? AND server_rev < ?',
                variables: [
                  Variable.withInt(r.rev ?? 0),
                  Variable.withString(c.id),
                  Variable.withInt(r.rev ?? 0),
                ],
                updates: {_tables[c.table]!},
              );
              await _deleteOutbox(c.table, c.id, c.opId);
            });
            report.pushed++;
            progressed = true;
          case PushStatus.conflict:
            await db.transaction(() async {
              await db
                  .into(db.syncConflicts)
                  .insert(
                    SyncConflictsCompanion.insert(
                      id: Ids.newId(),
                      tableName_: c.table,
                      rowId: c.id,
                      localData: jsonEncode(c.data),
                      serverData: jsonEncode(r.serverRow),
                      detectedAt: DateTime.now().toUtc(),
                    ),
                  );
              if (r.serverRow != null) {
                await applyServerRow(c.table, r.serverRow!);
              }
              await _deleteOutbox(c.table, c.id, c.opId);
            });
            report.conflicts++;
            progressed = true;
          case PushStatus.error:
            await _markFailed(
              c.table,
              c.id,
              c.opId,
              r.error ?? 'Rejected by server',
            );
            report.errors++;
        }
      }
      if (!progressed) return;
      if (entries.length - skipped.length <= changes.length) return;
    }
  }

  Future<void> _deleteOutbox(String table, String rowId, String opId) async {
    // Only remove the entry if it was not re-queued by a newer local edit.
    await (db.delete(db.syncOutbox)..where(
          (t) =>
              t.tableName_.equals(table) &
              t.rowId.equals(rowId) &
              t.opId.equals(opId),
        ))
        .go();
  }

  Future<void> _markFailed(
    String table,
    String rowId,
    String opId,
    String error,
  ) async {
    final entry =
        await (db.select(db.syncOutbox)..where(
              (t) =>
                  t.tableName_.equals(table) &
                  t.rowId.equals(rowId) &
                  t.opId.equals(opId),
            ))
            .getSingleOrNull();
    if (entry == null) return;
    final attempts = entry.attempts + 1;
    final backoffMinutes = attempts >= 7 ? 60 : (1 << (attempts - 1));
    await (db.update(
      db.syncOutbox,
    )..where((t) => t.tableName_.equals(table) & t.rowId.equals(rowId))).write(
      SyncOutboxCompanion(
        attempts: Value(attempts),
        lastError: Value(error),
        nextAttemptAt: Value(
          DateTime.now().toUtc().add(Duration(minutes: backoffMinutes)),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pull
  // ---------------------------------------------------------------------------

  Future<void> _pull(SyncReport report) async {
    for (final table in tableOrder) {
      final key = 'pull_cursor:$table';
      final cursorStr = await settings.getValue(key);
      final cursor = cursorStr == null
          ? DateTime.utc(2000)
          : DateTime.parse(cursorStr).subtract(pullOverlap);
      DateTime? maxSeen = cursorStr == null ? null : DateTime.parse(cursorStr);
      var offset = 0;
      while (true) {
        final List<Map<String, Object?>> rows;
        try {
          rows = await remote.pull(
            table,
            since: cursor,
            offset: offset,
            limit: pageSize,
          );
        } on SyncTransportException {
          rethrow;
        } catch (e) {
          throw SyncTransportException('Download failed: $e');
        }
        await db.transaction(() async {
          for (final row in rows) {
            if (await _applyPulledRow(table, row)) report.pulled++;
            final ts = DateTime.parse(
              row['server_updated_at'] as String,
            ).toUtc();
            if (maxSeen == null || ts.isAfter(maxSeen!)) maxSeen = ts;
          }
        });
        if (rows.length < pageSize) break;
        offset += rows.length;
      }
      if (maxSeen != null) {
        await settings.setValue(key, maxSeen!.toIso8601String());
      }
    }
  }

  Future<bool> _applyPulledRow(String table, Map<String, Object?> row) async {
    final id = row['id'] as String;
    final rev = (row['rev'] as num).toInt();
    final pending =
        await (db.select(db.syncOutbox)
              ..where((t) => t.tableName_.equals(table) & t.rowId.equals(id)))
            .getSingleOrNull();
    if (pending != null) return false; // local change wins until pushed
    final local = await readLocalRow(table, id);
    if (local != null && ((local['server_rev'] as int?) ?? 0) >= rev) {
      return false;
    }
    await applyServerRow(table, row);
    return true;
  }

  /// Writes a server row into the local table (upsert), recording its
  /// revision. Local-only columns are preserved.
  Future<void> applyServerRow(String table, Map<String, Object?> row) async {
    final info = _tables[table]!;
    final cols = <String>[];
    final vars = <Variable<Object>>[];
    for (final c in info.$columns) {
      final name = c.name;
      if (name == 'server_rev') {
        cols.add(name);
        vars.add(Variable.withInt((row['rev'] as num).toInt()));
        continue;
      }
      if (localOnlyColumns.contains(name) || !row.containsKey(name)) continue;
      cols.add(name);
      vars.add(_toVariable(c.type, row[name]));
    }
    final updates = cols
        .where((c) => c != 'id')
        .map((c) => '"$c" = excluded."$c"')
        .join(', ');
    await db.customInsert(
      'INSERT INTO "$table" (${cols.map((c) => '"$c"').join(', ')}) '
      'VALUES (${List.filled(cols.length, '?').join(', ')}) '
      'ON CONFLICT(id) DO UPDATE SET $updates',
      variables: vars,
      updates: {info},
    );
  }

  static Variable<Object> _toVariable(Object type, Object? v) {
    if (v == null) return const Variable(null);
    return switch (type) {
      DriftSqlType.dateTime => Variable.withDateTime(
        DateTime.parse('$v').toUtc(),
      ),
      DriftSqlType.int ||
      DriftSqlType.bigInt => Variable.withInt((v as num).toInt()),
      DriftSqlType.bool => Variable.withBool(v == true || v == 1),
      _ => Variable.withString('$v'),
    };
  }

  // ---------------------------------------------------------------------------
  // Attachments
  // ---------------------------------------------------------------------------

  Future<void> _uploadAttachments() async {
    if (kIsWeb) return; // files are only added on phones
    final pendingRows =
        await (db.select(db.attachments)..where(
              (t) =>
                  t.storagePath.isNull() &
                  t.localPath.isNotNull() &
                  t.deletedAt.isNull(),
            ))
            .get();
    if (pendingRows.isEmpty) return;
    final business = await remote.businessId();
    for (final a in pendingRows) {
      final file = await attachments.fileFor(a);
      if (file == null) continue;
      final path = '$business/${a.id}${p.extension(a.fileName).toLowerCase()}';
      try {
        await remote.uploadFile(path, await file.readAsBytes(), a.mimeType);
      } catch (e) {
        throw SyncTransportException('Photo upload failed: $e');
      }
      await db.transaction(() async {
        await (db.update(
          db.attachments,
        )..where((t) => t.id.equals(a.id))).write(
          AttachmentsCompanion(
            storagePath: Value(path),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
        await attachments.markChanged('attachments', a.id);
      });
    }
  }

  /// Bytes of an attachment from cloud storage (used in the browser).
  Future<Uint8List?> downloadAttachmentBytes(Attachment a) async {
    if (a.storagePath == null) return null;
    return remote.downloadFile(a.storagePath!);
  }

  /// Downloads an attachment that exists only in cloud storage.
  Future<File?> downloadAttachment(Attachment a) async {
    if (kIsWeb || a.storagePath == null) return null;
    final bytes = await remote.downloadFile(a.storagePath!);
    final target = await attachments.localTarget(a);
    await target.writeAsBytes(bytes, flush: true);
    final base = await attachments.baseDir();
    await attachments.setLocalPath(
      a.id,
      p.relative(target.path, from: base.path),
    );
    return target;
  }

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  /// Pending outbox entries per table (for the "not yet backed up" view).
  Stream<Map<String, int>> watchPendingByTable() => db
      .customSelect(
        'SELECT table_name, COUNT(*) AS n FROM sync_outbox GROUP BY table_name',
        readsFrom: {db.syncOutbox},
      )
      .watch()
      .map(
        (rows) => {
          for (final r in rows) r.read<String>('table_name'): r.read<int>('n'),
        },
      );
}
