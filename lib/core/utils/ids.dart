import 'package:uuid/uuid.dart';

abstract final class Ids {
  static const _uuid = Uuid();

  /// Fixed namespace for deterministic (v5) identifiers.
  static const _namespace = '6f1c2a52-8f37-4f0e-9b0a-3a8b1f7d2c11';

  /// Random client-side UUID for new records.
  static String newId() => _uuid.v4();

  /// Deterministic UUID derived from [name]. Used where the same logical record
  /// must always get the same id (e.g. the stock movement for a visit part),
  /// which makes repeated operations idempotent.
  static String derived(String name) => _uuid.v5(_namespace, name);
}
