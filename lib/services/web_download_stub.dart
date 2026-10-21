import 'dart:typed_data';

Future<void> downloadBytes(Uint8List bytes, String fileName, String mimeType) =>
    throw UnsupportedError('Browser downloads are only available on web');
