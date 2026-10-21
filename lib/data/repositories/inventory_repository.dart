import 'package:drift/drift.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/ids.dart';
import '../../domain/enums.dart';
import '../local/app_database.dart';
import 'base_repository.dart';
import 'sql.dart';

class PartWithStock {
  const PartWithStock(this.part, this.stockMilli);
  final Part part;
  final int stockMilli;
  bool get isLow =>
      stockMilli <= part.minStockMilli && part.minStockMilli > 0 ||
      stockMilli < 0;
}

class MovementRow {
  const MovementRow(this.movement, this.visitNo);
  final StockMovement movement;
  final String? visitNo;
}

/// Spare-parts catalogue and stock. Stock is never stored as a counter: it is
/// always the sum of the (append-only, uniquely identified) stock movements.
/// Usage on a visit maps to exactly one movement whose id is derived from the
/// visit-part id, so re-saving or re-syncing a visit can never deduct twice.
class InventoryRepository extends BaseRepository {
  InventoryRepository(super.db);

  static String visitPartMovementId(String visitPartId) =>
      Ids.derived('visit-part-stock:$visitPartId');

  Set<ResultSetImplementation<dynamic, dynamic>> get _reads => {
    db.parts,
    db.stockMovements,
  };

  Stream<List<PartWithStock>> watchParts({
    String query = '',
    bool archived = false,
    bool lowOnly = false,
  }) {
    final q = query.trim().toLowerCase();
    final where = StringBuffer(
      archived ? 'p.archived_at IS NOT NULL' : 'p.archived_at IS NULL',
    );
    final vars = <Variable<Object>>[];
    if (q.isNotEmpty) {
      where.write(
        " AND (LOWER(p.name) LIKE ? OR LOWER(COALESCE(p.part_number, '')) LIKE ?"
        " OR LOWER(COALESCE(p.category, '')) LIKE ?)",
      );
      vars.addAll([for (var i = 0; i < 3; i++) Variable.withString('%$q%')]);
    }
    if (lowOnly) {
      where.write(
        ' AND (COALESCE(s.stock, 0) < 0 OR (p.min_stock_milli > 0'
        ' AND COALESCE(s.stock, 0) <= p.min_stock_milli))',
      );
    }
    return db
        .customSelect(
          'SELECT p.*, COALESCE(s.stock, 0) AS stock FROM parts p '
          'LEFT JOIN (${Sql.stockByPart}) s ON s.part_id = p.id '
          'WHERE $where ORDER BY p.name COLLATE NOCASE',
          variables: vars,
          readsFrom: _reads,
        )
        .watch()
        .map(
          (rows) => [
            for (final r in rows)
              PartWithStock(db.parts.map(r.data), r.read<int>('stock')),
          ],
        );
  }

  Stream<PartWithStock?> watchPart(String id) => db
      .customSelect(
        'SELECT p.*, COALESCE(s.stock, 0) AS stock FROM parts p '
        'LEFT JOIN (${Sql.stockByPart}) s ON s.part_id = p.id WHERE p.id = ?',
        variables: [Variable.withString(id)],
        readsFrom: _reads,
      )
      .watchSingleOrNull()
      .map(
        (r) => r == null
            ? null
            : PartWithStock(db.parts.map(r.data), r.read<int>('stock')),
      );

  Future<int> stockOf(String partId) async {
    final r = await db
        .customSelect(
          'SELECT COALESCE(SUM(qty_milli), 0) AS s FROM stock_movements '
          'WHERE part_id = ? AND deleted_at IS NULL',
          variables: [Variable.withString(partId)],
        )
        .getSingle();
    return r.read<int>('s');
  }

  Future<Part?> getPart(String id) =>
      (db.select(db.parts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Part>> activeParts() =>
      (db.select(db.parts)
            ..where((t) => t.archivedAt.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.name.lower())]))
          .get();

  Stream<List<MovementRow>> watchMovements(String partId) => db
      .customSelect(
        'SELECT m.*, v.visit_no AS visit_no FROM stock_movements m '
        'LEFT JOIN service_visits v ON v.id = m.visit_id '
        'WHERE m.part_id = ? AND m.deleted_at IS NULL '
        'ORDER BY m.occurred_on DESC, m.created_at DESC',
        variables: [Variable.withString(partId)],
        readsFrom: {db.stockMovements, db.serviceVisits},
      )
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            MovementRow(
              db.stockMovements.map(r.data),
              r.readNullable<String>('visit_no'),
            ),
        ],
      );

  /// Creates or updates a part. [openingStockMilli] is only used for new parts.
  Future<String> savePart(
    PartsCompanion data, {
    String? id,
    int openingStockMilli = 0,
  }) {
    return write(() async {
      if (data.name.present && data.name.value.trim().isEmpty) {
        throw BusinessRuleException('Part name is required');
      }
      final now = nowUtc();
      final existing = id == null ? null : await getPart(id);
      final rowId = id ?? Ids.newId();
      if (existing == null) {
        await db
            .into(db.parts)
            .insert(
              data.copyWith(
                id: Value(rowId),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
        if (openingStockMilli != 0) {
          await _insertMovement(
            partId: rowId,
            kind: StockMovementKind.opening,
            qtyMilli: openingStockMilli,
            unitCostPaise: data.purchasePaise.present
                ? data.purchasePaise.value
                : null,
            occurredOn: Dates.today(),
          );
        }
      } else {
        await (db.update(db.parts)..where((t) => t.id.equals(rowId))).write(
          data.copyWith(updatedAt: Value(now)),
        );
      }
      await markChanged('parts', rowId);
      return rowId;
    });
  }

  Future<void> setArchived(String id, bool archived) => write(() async {
    final now = nowUtc();
    await (db.update(db.parts)..where((t) => t.id.equals(id))).write(
      PartsCompanion(
        archivedAt: Value(archived ? now : null),
        updatedAt: Value(now),
      ),
    );
    await markChanged('parts', id);
  });

  /// Records a purchase (positive) or adjustment (signed) movement.
  Future<String> recordMovement({
    required String partId,
    required StockMovementKind kind,
    required int qtyMilli,
    int? unitCostPaise,
    String? occurredOn,
    String? notes,
    String? id,
  }) {
    if (qtyMilli == 0) {
      throw BusinessRuleException('Quantity cannot be zero');
    }
    if (kind == StockMovementKind.purchase && qtyMilli < 0) {
      throw BusinessRuleException('Purchased quantity must be positive');
    }
    if (kind == StockMovementKind.visitUsage) {
      throw BusinessRuleException('Visit usage is recorded from the visit');
    }
    return write(() async {
      final rowId = id ?? Ids.newId();
      // Idempotent: a retried submit with the same id is a no-op.
      final exists = await (db.select(
        db.stockMovements,
      )..where((t) => t.id.equals(rowId))).getSingleOrNull();
      if (exists != null) return rowId;
      await _insertMovement(
        id: rowId,
        partId: partId,
        kind: kind,
        qtyMilli: qtyMilli,
        unitCostPaise: unitCostPaise,
        occurredOn: occurredOn ?? Dates.today(),
        notes: notes,
      );
      if (kind == StockMovementKind.purchase && unitCostPaise != null) {
        await (db.update(db.parts)..where((t) => t.id.equals(partId))).write(
          PartsCompanion(
            purchasePaise: Value(unitCostPaise),
            updatedAt: Value(nowUtc()),
          ),
        );
        await markChanged('parts', partId);
      }
      return rowId;
    });
  }

  Future<void> _insertMovement({
    String? id,
    required String partId,
    required StockMovementKind kind,
    required int qtyMilli,
    int? unitCostPaise,
    required String occurredOn,
    String? notes,
    String? visitId,
    String? visitPartId,
  }) async {
    final now = nowUtc();
    final rowId = id ?? Ids.newId();
    await db
        .into(db.stockMovements)
        .insert(
          StockMovementsCompanion.insert(
            id: rowId,
            createdAt: now,
            updatedAt: now,
            partId: partId,
            kind: kind.db,
            qtyMilli: qtyMilli,
            unitCostPaise: Value(unitCostPaise),
            occurredOn: occurredOn,
            notes: Value(notes),
            visitId: Value(visitId),
            visitPartId: Value(visitPartId),
          ),
        );
    await markChanged('stock_movements', rowId);
  }

  /// Brings the stock movements for a visit in line with its parts. Must be
  /// called inside the transaction that saved the visit. Safe to call any
  /// number of times.
  Future<void> syncVisitStock(
    String visitId, {
    required bool inventoryEnabled,
  }) async {
    final visit = await (db.select(
      db.serviceVisits,
    )..where((t) => t.id.equals(visitId))).getSingle();
    final parts = await (db.select(
      db.visitParts,
    )..where((t) => t.visitId.equals(visitId))).get();
    final visitFinal =
        visit.status == VisitStatus.completed.db && visit.archivedAt == null;

    for (final vp in parts) {
      final movementId = visitPartMovementId(vp.id);
      final existing = await (db.select(
        db.stockMovements,
      )..where((t) => t.id.equals(movementId))).getSingleOrNull();
      final lineActive =
          visitFinal && vp.deletedAt == null && vp.partId != null;

      if (lineActive && inventoryEnabled) {
        final desired = -vp.qtyMilli;
        if (existing == null) {
          await _insertMovement(
            id: movementId,
            partId: vp.partId!,
            kind: StockMovementKind.visitUsage,
            qtyMilli: desired,
            unitCostPaise: vp.unitCostPaise,
            occurredOn: visit.visitDate,
            visitId: visitId,
            visitPartId: vp.id,
          );
        } else if (existing.qtyMilli != desired ||
            existing.partId != vp.partId ||
            existing.deletedAt != null ||
            existing.occurredOn != visit.visitDate) {
          await (db.update(
            db.stockMovements,
          )..where((t) => t.id.equals(movementId))).write(
            StockMovementsCompanion(
              partId: Value(vp.partId!),
              qtyMilli: Value(desired),
              occurredOn: Value(visit.visitDate),
              deletedAt: const Value(null),
              updatedAt: Value(nowUtc()),
            ),
          );
          await markChanged('stock_movements', movementId);
        }
      } else if (!lineActive &&
          existing != null &&
          existing.deletedAt == null) {
        // Line removed / visit reopened: give the stock back.
        await (db.update(
          db.stockMovements,
        )..where((t) => t.id.equals(movementId))).write(
          StockMovementsCompanion(
            deletedAt: Value(nowUtc()),
            updatedAt: Value(nowUtc()),
          ),
        );
        await markChanged('stock_movements', movementId);
      }
    }
  }
}
