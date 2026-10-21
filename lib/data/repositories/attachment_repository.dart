import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../core/utils/ids.dart';
import '../../domain/enums.dart';
import '../local/app_database.dart';
import 'base_repository.dart';

/// Photos, documents and signatures. Files live in the app's documents
/// directory; the database stores a path *relative* to it (absolute app
/// container paths change on iOS updates).
class AttachmentRepository extends BaseRepository {
  AttachmentRepository(super.db, this.baseDir);

  final Future<Directory> Function() baseDir;

  static const folder = 'attachments';

  Stream<List<Attachment>> watchFor(String entityType, String entityId) =>
      (db.select(db.attachments)
            ..where(
              (t) =>
                  t.entityType.equals(entityType) &
                  t.entityId.equals(entityId) &
                  t.deletedAt.isNull(),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .watch();

  Future<File?> fileFor(Attachment a) async {
    // Browsers have no app folder; files there come from cloud storage.
    if (kIsWeb || a.localPath == null) return null;
    final f = File(p.join((await baseDir()).path, a.localPath));
    return f.existsSync() ? f : null;
  }

  /// Destination for a downloaded copy of [a].
  Future<File> localTarget(Attachment a) async {
    final rel = p.join(folder, '${a.id}${p.extension(a.fileName)}');
    final f = File(p.join((await baseDir()).path, rel));
    await f.parent.create(recursive: true);
    return f;
  }

  Future<void> setLocalPath(String id, String relativePath) async {
    // Local-only column: no outbox entry needed.
    await (db.update(db.attachments)..where((t) => t.id.equals(id))).write(
      AttachmentsCompanion(localPath: Value(relativePath)),
    );
  }

  Future<String> addBytes({
    required String entityType,
    required String entityId,
    required AttachmentKind kind,
    required Uint8List bytes,
    required String fileName,
    String? mimeType,
    String? caption,
  }) async {
    if (kIsWeb) {
      throw BusinessRuleException(
        'Add photos and documents from the phone app',
      );
    }
    final id = Ids.newId();
    final ext = p.extension(fileName).toLowerCase();
    final rel = p.join(folder, '$id$ext');
    final file = File(p.join((await baseDir()).path, rel));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    try {
      await write(() async {
        final now = nowUtc();
        await db
            .into(db.attachments)
            .insert(
              AttachmentsCompanion.insert(
                id: id,
                createdAt: now,
                updatedAt: now,
                entityType: entityType,
                entityId: entityId,
                kind: kind.db,
                fileName: fileName,
                mimeType: Value(mimeType ?? _mimeFor(ext)),
                sizeBytes: Value(bytes.length),
                caption: Value(caption),
                localPath: Value(rel),
              ),
            );
        await markChanged('attachments', id);
      });
    } catch (_) {
      if (file.existsSync()) await file.delete();
      rethrow;
    }
    return id;
  }

  Future<String> addFile({
    required String entityType,
    required String entityId,
    required AttachmentKind kind,
    required String sourcePath,
    String? fileName,
  }) async => addBytes(
    entityType: entityType,
    entityId: entityId,
    kind: kind,
    bytes: await File(sourcePath).readAsBytes(),
    fileName: fileName ?? p.basename(sourcePath),
  );

  Future<void> remove(String id) => write(() async {
    final now = nowUtc();
    await (db.update(db.attachments)..where((t) => t.id.equals(id))).write(
      AttachmentsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    await markChanged('attachments', id);
  });

  static String _mimeFor(String ext) => switch (ext) {
    '.jpg' || '.jpeg' => 'image/jpeg',
    '.png' => 'image/png',
    '.heic' => 'image/heic',
    '.webp' => 'image/webp',
    '.pdf' => 'application/pdf',
    _ => 'application/octet-stream',
  };

  static bool isImage(Attachment a) => (a.mimeType ?? '').startsWith('image/');
}
