import 'package:web/web.dart' as web;

/// Route in the address bar, e.g. "/companies" for ".../#/companies".
String? currentWebRoute() {
  final hash = web.window.location.hash;
  if (hash.length < 2) return null;
  return Uri.parse(hash.substring(1)).path;
}
