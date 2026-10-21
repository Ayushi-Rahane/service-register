import 'package:flutter/foundation.dart' show kIsWeb;

/// Build-time configuration, supplied with
/// `flutter run --dart-define-from-file=env/dev.json` (see env/example.json).
///
/// Only the Supabase URL and the public anon/publishable key belong here. They
/// are safe to ship in an app because Row Level Security protects the data.
/// Never put the service-role key in the app.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get cloudConfigured =>
      supabaseUrl.startsWith('https://') &&
      !supabaseUrl.contains('YOUR-PROJECT') &&
      supabaseAnonKey.length > 20;
}

/// "this phone" in the app, "this browser" on the website.
const thisDevice = kIsWeb ? 'this browser' : 'this phone';
