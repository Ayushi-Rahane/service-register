import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/repositories/settings_repository.dart';
import 'auth_service.dart';

/// Whether this device has a signed-in account, for the sign-in-first screen.
///
/// This is remembered on the device rather than read from the live session,
/// because the session cannot be refreshed without internet: a technician
/// working offline in a factory must not be sent back to the sign-in page.
/// It is cleared only by "Sign out" or when the server ends the session.
class AccountGate extends ChangeNotifier {
  AccountGate({
    required this.auth,
    required SettingsRepository settings,
    required bool signedIn,
  }) : _settings = settings,
       _signedIn = signedIn {
    _sub = auth.signedOutEvents.listen((_) => unawaited(_set(false)));
  }

  static const key = 'account_signed_in';

  final AuthService auth;
  final SettingsRepository _settings;
  late final StreamSubscription<void> _sub;
  bool _signedIn;

  /// Accounts are required whenever cloud sync is set up in this build.
  bool get required => auth.configured;
  bool get signedIn => _signedIn;

  /// Initial state at app start.
  static Future<bool> load(
    SettingsRepository settings,
    AuthService auth,
  ) async {
    if (!auth.configured) return false;
    if (await settings.getValue(key) == 'true') return true;
    // Devices signed in before this screen existed.
    if (auth.signedIn) {
      await settings.setValue(key, 'true');
      return true;
    }
    return false;
  }

  Future<void> markSignedIn() => _set(true);

  Future<void> signOut() async {
    await auth.signOut();
    await _set(false);
  }

  Future<void> _set(bool value) async {
    await _settings.setValue(key, value ? 'true' : null);
    if (_signedIn == value) return;
    _signedIn = value;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }
}
