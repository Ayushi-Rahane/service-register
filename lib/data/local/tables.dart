import 'package:drift/drift.dart';

// Conventions (mirrored by supabase/migrations):
// * `id` is a client-generated UUID so records can be created offline.
// * Money is stored as integer paise (₹1 = 100 paise) – never floating point.
// * Quantities are stored as integer thousandths ("milli units") so 1.5 m of
//   cable is 1500.
// * Calendar dates are ISO strings (yyyy-MM-dd); timestamps are UTC DateTimes.
// * Records are archived / soft-deleted, never hard-deleted.
// * `server_rev` is local-only: the server revision this row was last synced at.

mixin SyncedColumns on Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get serverRev => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'idx_companies_name', columns: {#name})
class Companies extends Table with SyncedColumns {
  TextColumn get code => text().nullable()();
  TextColumn get name => text()();
  TextColumn get contactPerson => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get altPhone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get pincode => text().nullable()();
  TextColumn get gstin => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_machines_company', columns: {#companyId})
class Machines extends Table with SyncedColumns {
  TextColumn get companyId => text().references(Companies, #id)();
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant('other'))();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get serialNumber => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get installedOn => text().nullable()();
  TextColumn get warrantyUntil => text().nullable()();
  IntColumn get serviceIntervalDays => integer().nullable()();
  TextColumn get nextServiceDue => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('operational'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_parts_name', columns: {#name})
class Parts extends Table with SyncedColumns {
  TextColumn get name => text()();
  TextColumn get partNumber => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  IntColumn get minStockMilli => integer().withDefault(const Constant(0))();
  IntColumn get purchasePaise => integer().nullable()();
  IntColumn get sellingPaise => integer().nullable()();
  TextColumn get supplierName => text().nullable()();
  TextColumn get supplierContact => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@DataClassName('ServiceVisit')
@TableIndex(name: 'idx_visits_company', columns: {#companyId})
@TableIndex(name: 'idx_visits_machine', columns: {#machineId})
@TableIndex(name: 'idx_visits_date', columns: {#visitDate})
class ServiceVisits extends Table with SyncedColumns {
  TextColumn get visitNo => text()();
  TextColumn get companyId => text().references(Companies, #id)();
  TextColumn get machineId => text().nullable().references(Machines, #id)();
  TextColumn get visitDate => text()();
  TextColumn get arrivalTime => text().nullable()();
  TextColumn get departureTime => text().nullable()();
  TextColumn get serviceType =>
      text().withDefault(const Constant('routine_maintenance'))();
  TextColumn get status => text().withDefault(const Constant('in_progress'))();
  TextColumn get technicianName => text().nullable()();
  TextColumn get reportedProblem => text().nullable()();
  TextColumn get symptoms => text().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get rootCause => text().nullable()();
  TextColumn get workDone => text().nullable()();
  TextColumn get actionsTaken => text().nullable()();
  TextColumn get testsPerformed => text().nullable()();
  TextColumn get machineStatusAfter => text().nullable()();
  TextColumn get recommendations => text().nullable()();
  IntColumn get labourPaise => integer().withDefault(const Constant(0))();
  IntColumn get travelPaise => integer().withDefault(const Constant(0))();
  IntColumn get discountPaise => integer().withDefault(const Constant(0))();
  IntColumn get taxRateBp => integer().withDefault(const Constant(0))();
  IntColumn get partsTotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get totalPaise => integer().withDefault(const Constant(0))();
  IntColumn get onsitePaymentPaise =>
      integer().withDefault(const Constant(0))();
  TextColumn get onsitePaymentMethod => text().nullable()();
  TextColumn get customerFeedback => text().nullable()();
  TextColumn get signedBy => text().nullable()();
  TextColumn get nextServiceDate => text().nullable()();
  TextColumn get internalNotes => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get invoiceId => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_visit_parts_visit', columns: {#visitId})
@TableIndex(name: 'idx_visit_parts_part', columns: {#partId})
class VisitParts extends Table with SyncedColumns {
  TextColumn get visitId => text().references(ServiceVisits, #id)();
  TextColumn get partId => text().nullable().references(Parts, #id)();
  TextColumn get partName => text()();
  TextColumn get partNumber => text().nullable()();
  IntColumn get qtyMilli => integer()();
  IntColumn get unitCostPaise => integer().nullable()();
  IntColumn get unitPricePaise => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_movements_part', columns: {#partId})
class StockMovements extends Table with SyncedColumns {
  TextColumn get partId => text().references(Parts, #id)();
  TextColumn get kind => text()();
  IntColumn get qtyMilli => integer()();
  IntColumn get unitCostPaise => integer().nullable()();
  TextColumn get visitId => text().nullable()();
  TextColumn get visitPartId => text().nullable()();
  TextColumn get occurredOn => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_invoices_company', columns: {#companyId})
class Invoices extends Table with SyncedColumns {
  TextColumn get invoiceNo => text().unique()();
  TextColumn get companyId => text().references(Companies, #id)();
  TextColumn get invoiceDate => text()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get billToName => text()();
  TextColumn get billToAddress => text().nullable()();
  TextColumn get billToPhone => text().nullable()();
  TextColumn get billToGstin => text().nullable()();
  IntColumn get discountPaise => integer().withDefault(const Constant(0))();
  TextColumn get taxLabel => text().nullable()();
  IntColumn get taxRateBp => integer().withDefault(const Constant(0))();
  IntColumn get subtotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get taxPaise => integer().withDefault(const Constant(0))();
  IntColumn get totalPaise => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get cancelledAt => dateTime().nullable()();
  TextColumn get cancelReason => text().nullable()();
}

@TableIndex(name: 'idx_invoice_items_invoice', columns: {#invoiceId})
class InvoiceItems extends Table with SyncedColumns {
  TextColumn get invoiceId => text().references(Invoices, #id)();
  TextColumn get visitId => text().nullable()();
  TextColumn get kind => text().withDefault(const Constant('other'))();
  TextColumn get description => text()();
  IntColumn get qtyMilli => integer().withDefault(const Constant(1000))();
  IntColumn get unitPricePaise => integer().withDefault(const Constant(0))();
  IntColumn get amountPaise => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_payments_company', columns: {#companyId})
class Payments extends Table with SyncedColumns {
  TextColumn get receiptNo => text().unique()();
  TextColumn get companyId => text().references(Companies, #id)();
  TextColumn get paidOn => text()();
  IntColumn get amountPaise => integer()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  TextColumn get reference => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  TextColumn get voidReason => text().nullable()();
}

@TableIndex(name: 'idx_allocations_invoice', columns: {#invoiceId})
@TableIndex(name: 'idx_allocations_payment', columns: {#paymentId})
class PaymentAllocations extends Table with SyncedColumns {
  TextColumn get paymentId => text().references(Payments, #id)();
  TextColumn get invoiceId => text().references(Invoices, #id)();
  IntColumn get amountPaise => integer()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Reminders extends Table with SyncedColumns {
  TextColumn get kind => text().withDefault(const Constant('follow_up'))();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get dueDate => text()();
  TextColumn get dueTime => text().nullable()();
  TextColumn get companyId => text().nullable().references(Companies, #id)();
  TextColumn get machineId => text().nullable().references(Machines, #id)();
  TextColumn get invoiceId => text().nullable().references(Invoices, #id)();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get doneAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_attachments_entity', columns: {#entityType, #entityId})
class Attachments extends Table with SyncedColumns {
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get kind => text()();
  TextColumn get fileName => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  TextColumn get caption => text().nullable()();

  /// Path in Supabase Storage once uploaded (null = not yet uploaded).
  TextColumn get storagePath => text().nullable()();

  /// Device-specific file location. Local only, never synced.
  TextColumn get localPath => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

@DataClassName('AuditEntry')
@TableIndex(name: 'idx_audit_entity', columns: {#entityType, #entityId})
class AuditLog extends Table with SyncedColumns {
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  TextColumn get summary => text().nullable()();

  /// JSON object: {"field": {"from": .., "to": ..}}
  TextColumn get changes => text().nullable()();
  TextColumn get actor => text().nullable()();
}

// ---------------------------------------------------------------------------
// Local-only tables
// ---------------------------------------------------------------------------

/// One entry per locally changed row that still has to be pushed. Repeated
/// edits of the same row coalesce into one entry with a fresh [opId].
@DataClassName('OutboxEntry')
class SyncOutbox extends Table {
  TextColumn get tableName_ => text().named('table_name')();
  TextColumn get rowId => text()();
  TextColumn get opId => text()();
  DateTimeColumn get queuedAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {tableName_, rowId};
}

/// Local edits that lost against a newer server version. Kept for review so
/// nothing is silently discarded.
class SyncConflicts extends Table {
  TextColumn get id => text()();
  TextColumn get tableName_ => text().named('table_name')();
  TextColumn get rowId => text()();
  TextColumn get localData => text()();
  TextColumn get serverData => text()();
  DateTimeColumn get detectedAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
