import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/dialogs.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/attachment_repository.dart';
import '../../data/sync/sync_controller.dart';
import '../../domain/enums.dart';
import '../providers.dart';
import '../../services/web_download.dart';
import 'signature_pad.dart';

/// Photos, documents and signature attached to a record.
class AttachmentsSection extends ConsumerWidget {
  const AttachmentsSection({
    super.key,
    required this.entityType,
    required this.entityId,
    this.ensureSaved,
    this.allowSignature = false,
    this.readOnly = false,
  });

  final String entityType;
  final String entityId;

  /// Called before adding the first file (e.g. to save a new visit). Return
  /// false to abort.
  final Future<bool> Function()? ensureSaved;
  final bool allowSignature;
  final bool readOnly;

  Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    AttachmentKind kind,
  ) async {
    if (ensureSaved != null && !await ensureSaved!()) return;
    if (!context.mounted) return;
    final repo = ref.read(attachmentRepositoryProvider);
    try {
      switch (kind) {
        case AttachmentKind.photoBefore || AttachmentKind.photoAfter:
          final source = await showActionSheet<ImageSource>(
            context,
            title: kind.label,
            actions: const [
              (
                icon: Icons.photo_camera_outlined,
                label: 'Take photo',
                value: ImageSource.camera,
              ),
              (
                icon: Icons.photo_library_outlined,
                label: 'Choose from gallery',
                value: ImageSource.gallery,
              ),
            ],
          );
          if (source == null) return;
          final img = await ImagePicker().pickImage(
            source: source,
            maxWidth: 1800,
            imageQuality: 80,
          );
          if (img == null) return;
          await repo.addFile(
            entityType: entityType,
            entityId: entityId,
            kind: kind,
            sourcePath: img.path,
            fileName: '${kind.db}_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
        case AttachmentKind.document:
          final files = await FilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: const [
              'pdf',
              'jpg',
              'jpeg',
              'png',
              'doc',
              'docx',
              'xls',
              'xlsx',
            ],
          );
          if (files.isEmpty || files.first.path == null) return;
          await repo.addFile(
            entityType: entityType,
            entityId: entityId,
            kind: kind,
            sourcePath: files.first.path!,
            fileName: files.first.name,
          );
        case AttachmentKind.signature:
          final png = await captureSignature(context);
          if (png == null) return;
          await repo.addBytes(
            entityType: entityType,
            entityId: entityId,
            kind: kind,
            bytes: png,
            fileName: 'signature.png',
            mimeType: 'image/png',
          );
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context,
          'Could not add the file. Check camera / storage permission. ($e)',
          error: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(attachmentsProvider((entityType, entityId))).value ??
        const <Attachment>[];
    final hasSignature = items.any(
      (a) => a.kind == AttachmentKind.signature.db,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: Text(
              'No photos or documents',
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          )
        else
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: Gap.sm),
              itemBuilder: (_, i) =>
                  _Thumb(attachment: items[i], readOnly: readOnly),
            ),
          ),
        if (!readOnly && kIsWeb)
          Padding(
            padding: const EdgeInsets.only(top: Gap.sm),
            child: Text(
              'Add photos, documents and signatures from the phone app.',
              style: context.text.bodySmall,
            ),
          ),
        if (!readOnly && !kIsWeb) ...[
          const SizedBox(height: Gap.sm),
          Wrap(
            spacing: Gap.sm,
            runSpacing: Gap.sm,
            children: [
              ActionChip(
                avatar: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Before photo'),
                onPressed: () => _add(context, ref, AttachmentKind.photoBefore),
              ),
              ActionChip(
                avatar: const Icon(Icons.add_a_photo),
                label: const Text('After photo'),
                onPressed: () => _add(context, ref, AttachmentKind.photoAfter),
              ),
              ActionChip(
                avatar: const Icon(Icons.attach_file),
                label: const Text('Document'),
                onPressed: () => _add(context, ref, AttachmentKind.document),
              ),
              if (allowSignature && !hasSignature)
                ActionChip(
                  avatar: const Icon(Icons.draw_outlined),
                  label: const Text('Customer signature'),
                  onPressed: () => _add(context, ref, AttachmentKind.signature),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Thumb extends ConsumerStatefulWidget {
  const _Thumb({required this.attachment, required this.readOnly});
  final Attachment attachment;
  final bool readOnly;

  @override
  ConsumerState<_Thumb> createState() => _ThumbState();
}

class _ThumbState extends ConsumerState<_Thumb> {
  /// A local file (phones) or bytes from cloud storage (browser).
  late final Future<(File?, Uint8List?)> _future = _load();
  Attachment get attachment => widget.attachment;
  bool get readOnly => widget.readOnly;

  Future<(File?, Uint8List?)> _load() async {
    final repo = ref.read(attachmentRepositoryProvider);
    final local = await repo.fileFor(attachment);
    if (local != null) return (local, null);
    final sync = ref.read(syncControllerProvider.notifier).service;
    if (sync == null || attachment.storagePath == null) return (null, null);
    try {
      if (kIsWeb) return (null, await sync.downloadAttachmentBytes(attachment));
      return (await sync.downloadAttachment(attachment), null);
    } catch (_) {
      return (null, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kind = AttachmentKind.fromDb(attachment.kind);
    return FutureBuilder<(File?, Uint8List?)>(
      future: _future,
      builder: (context, snap) {
        final file = snap.data?.$1;
        final bytes = snap.data?.$2;
        final available = file != null || bytes != null;
        final isImage = AttachmentRepository.isImage(attachment);
        return InkWell(
          onTap: !available ? null : () => _open(context, file, bytes, isImage),
          onLongPress: readOnly ? null : () => _remove(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 104,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.colors.outlineVariant),
              color: context.colors.surfaceContainerHighest,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (file != null && isImage)
                  Image.file(file, fit: BoxFit.cover, cacheWidth: 300)
                else if (bytes != null && isImage)
                  Image.memory(bytes, fit: BoxFit.cover, cacheWidth: 300)
                else
                  Center(
                    child: Icon(
                      snap.connectionState == ConnectionState.waiting
                          ? Icons.hourglass_empty
                          : (!available
                                ? Icons.cloud_download_outlined
                                : Icons.description_outlined),
                      size: 36,
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      kind == AttachmentKind.document
                          ? attachment.fileName
                          : kind.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
                if (attachment.storagePath == null)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.phone_android,
                      size: 16,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4)],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _open(BuildContext context, File? file, Uint8List? bytes, bool isImage) {
    if (bytes != null) {
      // Browser: show images, download other files.
      if (!isImage) {
        downloadBytes(
          bytes,
          attachment.fileName,
          attachment.mimeType ?? 'application/octet-stream',
        );
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text(AttachmentKind.fromDb(attachment.kind).label),
              actions: [
                IconButton(
                  tooltip: 'Download',
                  icon: const Icon(Icons.download),
                  onPressed: () => downloadBytes(
                    bytes,
                    attachment.fileName,
                    attachment.mimeType ?? 'image/jpeg',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black,
            body: InteractiveViewer(child: Center(child: Image.memory(bytes))),
          ),
        ),
      );
      return;
    }
    if (file == null) return;
    if (!isImage) {
      SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(AttachmentKind.fromDb(attachment.kind).label),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => SharePlus.instance.share(
                  ShareParams(files: [XFile(file.path)]),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          body: InteractiveViewer(child: Center(child: Image.file(file))),
        ),
      ),
    );
  }

  Future<void> _remove(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Remove attachment?',
      message: 'The file will be removed from this record.',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (ok && context.mounted) {
      await runGuarded(
        context,
        () => ref.read(attachmentRepositoryProvider).remove(attachment.id),
      );
    }
  }
}
