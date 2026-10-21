import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../core/widgets/dialogs.dart';
import '../../services/document_service.dart';

/// Preview with print, share (WhatsApp, email…) and save.
class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key, required this.doc});
  final GeneratedDoc doc;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(doc.fileName, overflow: TextOverflow.ellipsis),
      actions: [
        IconButton(
          tooltip: 'Share',
          icon: const Icon(Icons.share),
          onPressed: () =>
              runGuarded(context, () => DocumentService.share(doc)),
        ),
        IconButton(
          tooltip: 'Save a copy',
          icon: const Icon(Icons.download),
          onPressed: () => runGuarded(context, () async {
            final path = await DocumentService.saveCopy(doc);
            if (context.mounted) showMessage(context, 'Saved to $path');
          }),
        ),
      ],
    ),
    body: PdfPreview(
      build: (_) async => doc.bytes,
      pdfFileName: doc.fileName,
      canChangeOrientation: false,
      canChangePageFormat: false,
      canDebug: false,
      allowSharing: true,
      allowPrinting: true,
    ),
  );
}
