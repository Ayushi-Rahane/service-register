/// Reading / replacing the address bar on the website (no-op on phones).
library;

export 'web_url_stub.dart' if (dart.library.js_interop) 'web_url_web.dart';
