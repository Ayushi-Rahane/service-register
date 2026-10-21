import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../local/app_database.dart';

/// Thrown for business-rule violations; the message is shown to the user.
class BusinessRuleException implements Exception {
  BusinessRuleException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Shared helpers: every local write happens in a transaction that also
/// records the changed rows in the sync outbox, so a change can never be
/// saved without being queued for upload (and vice versa).
abstract class BaseRepository {
  BaseRepository(this.db);

  final AppDatabase db;

  /// Overridable clock (tests).
  static DateTime Function() clock = DateTime.now;

  DateTime nowUtc() => clock().toUtc();

  Future<T> write<T>(Future<T> Function() body) => db.transaction(body);

  /// Queues [rowId] of [table] for upload. Repeated changes coalesce into a
  /// single outbox entry with a fresh operation id.
  Future<void> markChanged(String table, String rowId) async {
    final now = nowUtc();
    await db
        .into(db.syncOutbox)
        .insert(
          SyncOutboxCompanion.insert(
            tableName_: table,
            rowId: rowId,
            opId: Ids.newId(),
            queuedAt: now,
          ),
          onConflict: DoUpdate(
            (old) => SyncOutboxCompanion(
              opId: Value(Ids.newId()),
              queuedAt: Value(now),
              attempts: const Value(0),
              lastError: const Value(null),
              nextAttemptAt: const Value(null),
            ),
          ),
        );
  }

  /// Appends an audit entry (also synced).
  Future<void> audit({
    required String entityType,
    required String entityId,
    required String action,
    String? summary,
    Map<String, Object?>? changes,
    String? actor,
  }) async {
    final id = Ids.newId();
    final now = nowUtc();
    await db
        .into(db.auditLog)
        .insert(
          AuditLogCompanion.insert(
            id: id,
            createdAt: now,
            updatedAt: now,
            entityType: entityType,
            entityId: entityId,
            action: action,
            summary: Value(summary),
            changes: Value(changes == null ? null : jsonEncode(changes)),
            actor: Value(actor),
          ),
        );
    await markChanged('audit_log', id);
  }

  /// Field-level differences between two JSON maps (ignoring bookkeeping
  /// columns). Returns {"field": {"from": a, "to": b}}.
  static Map<String, Object?> diff(
    Map<String, Object?> before,
    Map<String, Object?> after,
  ) {
    const ignored = {'updatedAt', 'serverRev', 'createdAt'};
    final out = <String, Object?>{};
    for (final key in after.keys) {
      if (ignored.contains(key)) continue;
      final a = before[key], b = after[key];
      if ('$a' != '$b') out[key] = {'from': a, 'to': b};
    }
    return out;
  }
}

String? emptyToNull(String? s) {
  final t = s?.trim();
  return (t == null || t.isEmpty) ? null : t;
}
