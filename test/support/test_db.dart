import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:service_register/core/utils/dates.dart';
import 'package:service_register/data/local/app_database.dart';
import 'package:service_register/data/repositories/billing_repository.dart';
import 'package:service_register/data/repositories/company_repository.dart';
import 'package:service_register/data/repositories/inventory_repository.dart';
import 'package:service_register/data/repositories/machine_repository.dart';
import 'package:service_register/data/repositories/visit_repository.dart';
import 'package:service_register/domain/app_settings.dart';

/// In-memory database with all repositories wired up.
class TestEnv {
  TestEnv([AppDatabase? database])
    : db = database ?? AppDatabase(NativeDatabase.memory()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    companies = CompanyRepository(db);
    machines = MachineRepository(db);
    inventory = InventoryRepository(db);
    visits = VisitRepository(db, inventory, machines);
    billing = BillingRepository(db, visits);
  }

  final AppDatabase db;
  late final CompanyRepository companies;
  late final MachineRepository machines;
  late final InventoryRepository inventory;
  late final VisitRepository visits;
  late final BillingRepository billing;

  BusinessSettings settings = const BusinessSettings();

  Future<String> addCompany(String name, {String? phone}) => companies.save(
    CompaniesCompanion(name: Value(name), phone: Value(phone)),
  );

  Future<String> addMachine(
    String companyId,
    String name, {
    String category = 'pcb',
  }) => machines.save(
    MachinesCompanion(
      companyId: Value(companyId),
      name: Value(name),
      category: Value(category),
    ),
  );

  Future<String> addPart(
    String name, {
    int stockMilli = 0,
    int sellingPaise = 0,
  }) => inventory.savePart(
    PartsCompanion(name: Value(name), sellingPaise: Value(sellingPaise)),
    openingStockMilli: stockMilli,
  );

  Future<void> close() => db.close();
}

void fixToday(String iso) {
  final d = Dates.parse(iso);
  Dates.clock = () => DateTime(d.year, d.month, d.day, 10);
}
