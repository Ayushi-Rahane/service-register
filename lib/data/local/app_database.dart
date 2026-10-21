import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Companies,
    Machines,
    Parts,
    ServiceVisits,
    VisitParts,
    StockMovements,
    Invoices,
    InvoiceItems,
    Payments,
    PaymentAllocations,
    Reminders,
    Attachments,
    AuditLog,
    SyncOutbox,
    SyncConflicts,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// On phones: a SQLite file in the app folder. In a browser: SQLite
  /// compiled to WebAssembly, stored in the browser (web/sqlite3.wasm and
  /// web/drift_worker.js are served with the site).
  factory AppDatabase.device() => AppDatabase(
    driftDatabase(
      name: 'service_register',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    ),
  );

  // In a browser the database lives in IndexedDB and drift only writes it to
  // disk after a statement that runs outside a transaction; the COMMIT of a
  // transaction or batch does not trigger that. Without the extra no-op
  // statement below, data saved in a transaction would be lost on reload.
  @override
  Future<T> transaction<T>(
    Future<T> Function() action, {
    bool requireNew = false,
  }) async {
    final result = await super.transaction(action, requireNew: requireNew);
    await _persistInBrowser();
    return result;
  }

  @override
  Future<void> batch(FutureOr<void> Function(Batch batch) runInBatch) async {
    await super.batch(runInBatch);
    await _persistInBrowser();
  }

  Future<void> _persistInBrowser() async {
    // Inside an outer transaction this is a harmless no-op; once outside, it
    // makes drift flush everything to browser storage.
    if (kIsWeb) await customStatement('SELECT 1');
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Future schema changes go here, one step per version.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Tables that are synchronised with the server, in foreign-key order
  /// (parents before children).
  List<TableInfo<Table, dynamic>> get syncedTables => [
    companies,
    machines,
    parts,
    invoices,
    serviceVisits,
    visitParts,
    stockMovements,
    invoiceItems,
    payments,
    paymentAllocations,
    reminders,
    attachments,
    auditLog,
  ];
}
