import '../../core/utils/ids.dart';
import '../../domain/app_settings.dart';
import '../local/app_database.dart';

/// Device-local key/value settings (business profile, preferences and sync
/// bookkeeping).
class SettingsRepository {
  SettingsRepository(this.db);

  final AppDatabase db;

  Future<Map<String, String>> _all() async {
    final rows = await db.select(db.appSettings).get();
    return {for (final r in rows) r.key: r.value};
  }

  Future<BusinessSettings> load() async =>
      BusinessSettings.fromMap(await _all());

  Future<void> save(BusinessSettings settings) async {
    await db.batch((b) {
      b.insertAllOnConflictUpdate(db.appSettings, [
        for (final e in settings.toMap().entries)
          AppSettingsCompanion.insert(key: e.key, value: e.value),
      ]);
    });
  }

  Future<String?> getValue(String key) async {
    final row = await (db.select(
      db.appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setValue(String key, String? value) async {
    if (value == null) {
      await (db.delete(db.appSettings)..where((t) => t.key.equals(key))).go();
    } else {
      await db
          .into(db.appSettings)
          .insertOnConflictUpdate(
            AppSettingsCompanion.insert(key: key, value: value),
          );
    }
  }

  /// Stable per-install identifier used by the sync protocol.
  Future<String> deviceId() async {
    final existing = await getValue('device_id');
    if (existing != null) return existing;
    final id = Ids.newId();
    await setValue('device_id', id);
    return id;
  }
}
