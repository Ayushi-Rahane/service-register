import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../core/utils/csv.dart';
import '../core/utils/dates.dart';
import '../core/utils/ids.dart';
import '../core/utils/money.dart';
import '../core/utils/quantity.dart';
import '../data/local/app_database.dart';
import 'document_service.dart';

class BackupSummary {
  const BackupSummary(this.exportedAt, this.counts, this.files);
  final String exportedAt;
  final Map<String, int> counts;
  final int files;
  int get records => counts.values.fold(0, (s, v) => s + v);
}

/// Manual backup / restore and spreadsheet export. Works without any cloud
/// account: the zip can be saved to Google Drive, sent on WhatsApp, etc.
class BackupService {
  BackupService(this.db, this.baseDir);

  final AppDatabase db;
  final Future<Directory> Function() baseDir;

  static const format = 'service-register-backup';
  static const version = 1;

  /// Settings that belong to this install and must not be copied.
  static const _deviceKeys = {'device_id', 'last_sync_ok', 'last_sync_error'};

  List<TableInfo<Table, dynamic>> get _tables => [
    ...db.syncedTables,
    db.syncOutbox,
    db.syncConflicts,
  ];

  Future<GeneratedDoc> exportBackup() async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final t in _tables) {
      final rows = await db
          .customSelect('SELECT * FROM "${t.actualTableName}"')
          .get();
      tables[t.actualTableName] = [for (final r in rows) r.data];
    }
    final settings = await db.select(db.appSettings).get();
    final json = jsonEncode({
      'format': format,
      'version': version,
      'schema_version': db.schemaVersion,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'settings': {
        for (final s in settings)
          if (!_deviceKeys.contains(s.key) && !s.key.startsWith('pull_cursor:'))
            s.key: s.value,
      },
      'tables': tables,
    });
    final archive = Archive()..addFile(ArchiveFile.string('data.json', json));
    final base = kIsWeb ? null : await baseDir();
    for (final a
        in kIsWeb
            ? const <Attachment>[]
            : await db.select(db.attachments).get()) {
      if (a.localPath == null || a.deletedAt != null) continue;
      final f = File(p.join(base!.path, a.localPath));
      if (!f.existsSync()) continue;
      archive.addFile(
        ArchiveFile.bytes(
          a.localPath!.replaceAll(r'\', '/'),
          await f.readAsBytes(),
        ),
      );
    }
    final bytes = ZipEncoder().encodeBytes(archive);
    return GeneratedDoc(
      'ServiceRegister_Backup_${Dates.today()}.zip',
      Uint8List.fromList(bytes),
      mimeType: 'application/zip',
    );
  }

  /// Reads a backup without changing anything.
  BackupSummary inspect(Uint8List zip) {
    final data = _readData(zip);
    final tables = (data['tables'] as Map).cast<String, Object?>();
    final archive = ZipDecoder().decodeBytes(zip);
    return BackupSummary(
      data['exported_at'] as String,
      {for (final e in tables.entries) e.key: (e.value as List).length},
      archive.files.where((f) => f.isFile && f.name != 'data.json').length,
    );
  }

  Map<String, Object?> _readData(Uint8List zip) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zip);
    } catch (_) {
      throw const FormatException(
        'This file is not a Service Register backup (not a zip file)',
      );
    }
    final entry = archive.findFile('data.json');
    if (entry == null) {
      throw const FormatException('Backup file is missing data.json');
    }
    final data =
        jsonDecode(utf8.decode(entry.content as List<int>))
            as Map<String, Object?>;
    if (data['format'] != format) {
      throw const FormatException('This is not a Service Register backup');
    }
    if ((data['schema_version'] as int? ?? 0) > db.schemaVersion) {
      throw const FormatException(
        'This backup was made by a newer version of the app. Update the app first.',
      );
    }
    return data;
  }

  /// Replaces ALL data on this device with the backup, in one transaction.
  Future<BackupSummary> restore(Uint8List zip) async {
    final data = _readData(zip);
    final summary = inspect(zip);
    final tables = (data['tables'] as Map).cast<String, Object?>();
    final settings = (data['settings'] as Map? ?? {}).cast<String, Object?>();

    await db.transaction(() async {
      await db.customStatement('PRAGMA defer_foreign_keys = ON');
      for (final t in _tables.reversed) {
        await db.customStatement('DELETE FROM "${t.actualTableName}"');
      }
      for (final t in _tables) {
        final rows = (tables[t.actualTableName] as List?) ?? const [];
        final known = {for (final c in t.$columns) c.name};
        for (final raw in rows) {
          final row = (raw as Map).cast<String, Object?>();
          final cols = row.keys.where(known.contains).toList();
          await db.customInsert(
            'INSERT INTO "${t.actualTableName}" (${cols.map((c) => '"$c"').join(', ')}) '
            'VALUES (${List.filled(cols.length, '?').join(', ')})',
            variables: [for (final c in cols) _variable(row[c])],
          );
        }
      }
      // Records never uploaded must be queued for the cloud.
      final now = DateTime.now().toUtc();
      for (final t in db.syncedTables) {
        final ids = await db
            .customSelect(
              'SELECT id FROM "${t.actualTableName}" WHERE server_rev = 0',
            )
            .get();
        for (final r in ids) {
          await db
              .into(db.syncOutbox)
              .insert(
                SyncOutboxCompanion.insert(
                  tableName_: t.actualTableName,
                  rowId: r.read<String>('id'),
                  opId: Ids.newId(),
                  queuedAt: now,
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }
      for (final e in settings.entries) {
        await db
            .into(db.appSettings)
            .insertOnConflictUpdate(
              AppSettingsCompanion.insert(key: e.key, value: '${e.value}'),
            );
      }
      await db.customStatement(
        "DELETE FROM app_settings WHERE key LIKE 'pull_cursor:%'",
      );
    });
    // Notify all streams.
    db.notifyUpdates({for (final t in _tables) TableUpdate.onTable(t)});
    if (kIsWeb) return summary; // photos stay in cloud storage

    final base = await baseDir();
    for (final f in ZipDecoder().decodeBytes(zip).files) {
      if (!f.isFile || f.name == 'data.json') {
        continue;
      }
      final normalized = p.normalize(f.name);
      // Zip-slip guard: never write outside the app folder.
      if (normalized.startsWith('..') || p.isAbsolute(normalized)) {
        continue;
      }
      final out = File(p.join(base.path, normalized));
      await out.parent.create(recursive: true);
      await out.writeAsBytes(f.content as List<int>, flush: true);
    }
    return summary;
  }

  /// Deletes every record and file from this phone (used before handing the
  /// phone to another account). Does not touch cloud data.
  Future<void> wipeLocal() async {
    await db.transaction(() async {
      await db.customStatement('PRAGMA defer_foreign_keys = ON');
      for (final t in _tables.reversed) {
        await db.customStatement('DELETE FROM "${t.actualTableName}"');
      }
      await db.customStatement(
        "DELETE FROM app_settings WHERE key LIKE 'pull_cursor:%' OR key = 'sync_owner_user_id'",
      );
    });
    db.notifyUpdates({for (final t in _tables) TableUpdate.onTable(t)});
    if (kIsWeb) return;
    final dir = Directory(p.join((await baseDir()).path, 'attachments'));
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  static Variable<Object> _variable(Object? v) => switch (v) {
    null => const Variable(null),
    final int i => Variable.withInt(i),
    final double d => Variable.withReal(d),
    final bool b => Variable.withBool(b),
    _ => Variable.withString('$v'),
  };

  /// Spreadsheet export: one CSV per record type. Amounts in rupees.
  Future<GeneratedDoc> exportCsvZip() async {
    final archive = Archive();
    const exportTables = {
      'companies': 'Companies',
      'machines': 'Machines',
      'service_visits': 'Service visits',
      'visit_parts': 'Visit spare parts',
      'invoices': 'Invoices',
      'invoice_items': 'Invoice items',
      'payments': 'Payments',
      'payment_allocations': 'Payment allocations',
      'parts': 'Parts catalogue',
      'stock_movements': 'Stock movements',
      'reminders': 'Reminders',
    };
    for (final e in exportTables.entries) {
      final rows = await db.customSelect('SELECT * FROM "${e.key}"').get();
      final cols = rows.isEmpty
          ? [
              for (final c
                  in db.syncedTables
                      .firstWhere((t) => t.actualTableName == e.key)
                      .$columns)
                c.name,
            ]
          : rows.first.data.keys.toList();
      final visible = cols
          .where((c) => c != 'server_rev' && c != 'local_path')
          .toList();
      String header(String c) => c.endsWith('_paise')
          ? '${c.substring(0, c.length - 6)}_rupees'
          : c.endsWith('_milli')
          ? c.substring(0, c.length - 6)
          : c;
      String cell(String c, Object? v) {
        if (v == null) return '';
        if (c.endsWith('_paise') && v is int) return Money.plain(v);
        if (c.endsWith('_milli') && v is int) return Qty.format(v);
        return '$v';
      }

      final csv = Csv.encode([
        visible.map(header).toList(),
        for (final r in rows) [for (final c in visible) cell(c, r.data[c])],
      ]);
      archive.addFile(ArchiveFile.bytes('${e.value}.csv', utf8.encode(csv)));
    }
    return GeneratedDoc(
      'ServiceRegister_CSV_${Dates.today()}.zip',
      Uint8List.fromList(ZipEncoder().encodeBytes(archive)),
      mimeType: 'application/zip',
    );
  }
}
