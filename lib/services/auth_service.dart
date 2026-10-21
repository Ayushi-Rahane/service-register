import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/env.dart';

/// Keeps the Supabase session in the platform keychain / keystore instead of
/// plain shared preferences.
class SecureSessionStorage extends LocalStorage {
  const SecureSessionStorage();

  static const _storage = FlutterSecureStorage();
  static const _key = 'supabase_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async =>
      (await _storage.read(key: _key)) != null;

  @override
  Future<String?> accessToken() => _storage.read(key: _key);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _key);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _key, value: persistSessionString);
}

/// Thin wrapper over Supabase Auth (email + password).
class AuthService {
  AuthService._(this._client);

  final SupabaseClient? _client;

  static Future<AuthService> initialize() async {
    if (!Env.cloudConfigured) return AuthService._(null);
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        localStorage: SecureSessionStorage(),
      ),
    );
    return AuthService._(Supabase.instance.client);
  }

  /// For tests / local-only mode.
  factory AuthService.disabled() => AuthService._(null);

  bool get configured => _client != null;
  SupabaseClient? get client => _client;
  User? get currentUser => _client?.auth.currentUser;
  bool get signedIn => _client?.auth.currentSession != null;

  Stream<bool> get signedInChanges => _client == null
      ? Stream.value(false)
      : _client.auth.onAuthStateChange.map((s) => s.session != null);

  Future<void> signIn(String email, String password) async {
    _require();
    await _client!.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Returns true when the account still needs email confirmation.
  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
    String? businessName,
  }) async {
    _require();
    final res = await _client!.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        if (fullName != null && fullName.isNotEmpty) 'full_name': fullName,
        if (businessName != null && businessName.isNotEmpty)
          'business_name': businessName,
      },
    );
    return res.session == null;
  }

  Future<void> resetPassword(String email) async {
    _require();
    await _client!.auth.resetPasswordForEmail(email.trim());
  }

  Future<void> signOut() async => _client?.auth.signOut();

  void _require() {
    if (_client == null) {
      throw StateError('Cloud backup is not configured in this build');
    }
  }

  /// Friendly text for auth errors.
  static String describe(Object e) {
    if (e is AuthException) {
      final m = e.message.toLowerCase();
      if (m.contains('invalid login')) return 'Wrong email or password';
      if (m.contains('email not confirmed')) {
        return 'Please confirm your email first (check your inbox)';
      }
      if (m.contains('already registered')) {
        return 'An account with this email already exists';
      }
      return e.message;
    }
    final s = '$e';
    if (s.contains('SocketException') || s.contains('Failed host lookup')) {
      return 'No internet connection';
    }
    return s;
  }
}
