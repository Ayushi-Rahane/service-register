import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../data/local/app_database.dart';
import '../data/repositories/attachment_repository.dart';
import '../data/repositories/billing_repository.dart';
import '../data/repositories/company_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/machine_repository.dart';
import '../data/repositories/reminder_repository.dart';
import '../data/repositories/report_repository.dart';
import '../data/repositories/search_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/visit_repository.dart';
import '../domain/app_settings.dart';
import '../services/account_gate.dart';
import '../services/auth_service.dart';

/// Overridden in main() (and in tests).
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService.disabled(),
);

/// Sign-in state for the sign-in-first screen. Overridden in main() with the
/// state loaded at start-up.
final accountGateProvider = Provider<AccountGate>((ref) {
  final gate = AccountGate(
    auth: ref.watch(authServiceProvider),
    settings: ref.watch(settingsRepositoryProvider),
    signedIn: false,
  );
  ref.onDispose(gate.dispose);
  return gate;
});

final initialSettingsProvider = Provider<BusinessSettings>(
  (ref) => const BusinessSettings(),
);

final documentsDirProvider = Provider<Future<Directory> Function()>(
  (ref) => getApplicationDocumentsDirectory,
);

final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);
final companyRepositoryProvider = Provider(
  (ref) => CompanyRepository(ref.watch(databaseProvider)),
);
final machineRepositoryProvider = Provider(
  (ref) => MachineRepository(ref.watch(databaseProvider)),
);
final inventoryRepositoryProvider = Provider(
  (ref) => InventoryRepository(ref.watch(databaseProvider)),
);
final visitRepositoryProvider = Provider(
  (ref) => VisitRepository(
    ref.watch(databaseProvider),
    ref.watch(inventoryRepositoryProvider),
    ref.watch(machineRepositoryProvider),
  ),
);
final billingRepositoryProvider = Provider(
  (ref) => BillingRepository(
    ref.watch(databaseProvider),
    ref.watch(visitRepositoryProvider),
  ),
);
final reminderRepositoryProvider = Provider(
  (ref) => ReminderRepository(ref.watch(databaseProvider)),
);
final attachmentRepositoryProvider = Provider(
  (ref) => AttachmentRepository(
    ref.watch(databaseProvider),
    ref.watch(documentsDirProvider),
  ),
);
final dashboardRepositoryProvider = Provider(
  (ref) => DashboardRepository(ref.watch(databaseProvider)),
);
final searchRepositoryProvider = Provider(
  (ref) => SearchRepository(ref.watch(databaseProvider)),
);
final reportRepositoryProvider = Provider(
  (ref) => ReportRepository(ref.watch(databaseProvider)),
);

/// Business settings; changes are written to the device database.
class SettingsNotifier extends Notifier<BusinessSettings> {
  @override
  BusinessSettings build() => ref.watch(initialSettingsProvider);

  Future<void> save(BusinessSettings s) async {
    await ref.read(settingsRepositoryProvider).save(s);
    state = s;
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, BusinessSettings>(
  SettingsNotifier.new,
);

/// Name recorded in history entries.
final actorProvider = Provider<String?>((ref) {
  final s = ref.watch(settingsProvider);
  final user = ref.watch(authServiceProvider).currentUser;
  if (s.technicianName.isNotEmpty) return s.technicianName;
  return user?.email;
});
