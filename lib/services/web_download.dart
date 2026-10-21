/// Saves bytes as a file download in the browser. Only used on web; on
/// phones files go through the share sheet instead.
library;

export 'web_download_stub.dart'
    if (dart.library.js_interop) 'web_download_web.dart';
