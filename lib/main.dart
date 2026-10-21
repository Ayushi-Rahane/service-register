import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/providers.dart';
import 'data/local/app_database.dart';
import 'data/repositories/settings_repository.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_IN');

  final db = AppDatabase.device();
  final settingsRepo = SettingsRepository(db);
  final settings = await settingsRepo.load();
  await settingsRepo.deviceId();

  AuthService auth;
  try {
    auth = await AuthService.initialize();
  } catch (e) {
    // Bad configuration must never stop the technician from working offline.
    debugPrint('Cloud sync disabled: $e');
    auth = AuthService.disabled();
  }
  await NotificationService.instance.init();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        authServiceProvider.overrideWithValue(auth),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: ServiceApp(onboarded: settings.onboarded),
    ),
  );
}
