import 'dart:convert';

import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../repositories/base_repository.dart';
import 'sync_service.dart';

/// Review of edits that lost against newer server data.
class ConflictRepository extends BaseRepository {
  ConflictRepository(super.db);

  Stream<List<SyncConflict>> watchOpen() =>
      (db.select(db.syncConflicts)
            ..where((t) => t.resolvedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.detectedAt)]))
          .watch();

  Future<void> dismiss(String id) =>
      (db.update(db.syncConflicts)..where((t) => t.id.equals(id))).write(
        SyncConflictsCompanion(resolvedAt: Value(nowUtc())),
      );

  /// Explicitly re-applies the local version on top of the current server
  /// version (the user chose to overwrite). It is queued as a normal edit.
  Future<void> keepMine(SyncConflict c) => write(() async {
    final data = (jsonDecode(c.localData) as Map).cast<String, Object?>();
    final table = db.syncedTables.firstWhere(
      (t) => t.actualTableName == c.tableName_,
    );
    final known = {for (final col in table.$columns) col.name};
    final cols = data.keys
        .where(
          (k) =>
              known.contains(k) &&
              k != 'id' &&
              !SyncService.localOnlyColumns.contains(k),
        )
        .toList();
    await db.customUpdate(
      'UPDATE "${c.tableName_}" SET ${cols.map((k) => '"$k" = ?').join(', ')}, updated_at = ? WHERE id = ?',
      variables: [
        for (final k in cols) _v(data[k]),
        Variable.withDateTime(nowUtc()),
        Variable.withString(c.rowId),
      ],
      updates: {table},
    );
    await markChanged(c.tableName_, c.rowId);
    await dismiss(c.id);
  });

  static Variable<Object> _v(Object? v) => switch (v) {
    null => const Variable(null),
    final int i => Variable.withInt(i),
    final double d => Variable.withReal(d),
    _ => Variable.withString('$v'),
  };
}
