import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../data/local/app_database.dart';
import '../data/repositories/billing_repository.dart';
import '../data/repositories/company_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/machine_repository.dart';
import '../data/sync/sync_controller.dart';
import '../services/backup_service.dart';
import '../services/document_service.dart';

// Detail-screen streams keyed by record id.

final companyProvider = StreamProvider.autoDispose.family<Company?, String>(
  (ref, id) => ref.watch(companyRepositoryProvider).watch(id),
);
final companySummaryProvider = StreamProvider.autoDispose
    .family<CompanySummary, String>(
      (ref, id) => ref.watch(companyRepositoryProvider).watchSummary(id),
    );
final companyMachinesProvider = StreamProvider.autoDispose
    .family<List<MachineListItem>, String>(
      (ref, id) => ref.watch(machineRepositoryProvider).watchForCompany(id),
    );
final machineProvider = StreamProvider.autoDispose.family<Machine?, String>(
  (ref, id) => ref.watch(machineRepositoryProvider).watch(id),
);
final machineStatsProvider = StreamProvider.autoDispose
    .family<MachineStats, String>(
      (ref, id) => ref.watch(machineRepositoryProvider).watchStats(id),
    );
final visitProvider = StreamProvider.autoDispose.family<ServiceVisit?, String>(
  (ref, id) => ref.watch(visitRepositoryProvider).watch(id),
);
final visitPartsProvider = StreamProvider.autoDispose
    .family<List<VisitPart>, String>(
      (ref, id) => ref.watch(visitRepositoryProvider).watchParts(id),
    );
final historyProvider = StreamProvider.autoDispose
    .family<List<AuditEntry>, (String, String)>(
      (ref, key) =>
          ref.watch(visitRepositoryProvider).watchHistory(key.$1, key.$2),
    );
final invoiceProvider = StreamProvider.autoDispose
    .family<InvoiceListItem?, String>(
      (ref, id) => ref.watch(billingRepositoryProvider).watchInvoice(id),
    );
final invoiceItemsProvider = StreamProvider.autoDispose
    .family<List<InvoiceItem>, String>(
      (ref, id) => ref.watch(billingRepositoryProvider).watchItems(id),
    );
final invoiceAllocationsProvider = StreamProvider.autoDispose
    .family<List<AllocationRow>, String>(
      (ref, id) =>
          ref.watch(billingRepositoryProvider).watchInvoiceAllocations(id),
    );
final invoiceVisitsProvider = StreamProvider.autoDispose
    .family<List<ServiceVisit>, String>(
      (ref, id) => ref.watch(billingRepositoryProvider).watchInvoiceVisits(id),
    );
final paymentProvider = StreamProvider.autoDispose
    .family<PaymentListItem?, String>(
      (ref, id) => ref.watch(billingRepositoryProvider).watchPayment(id),
    );
final paymentAllocationsProvider = StreamProvider.autoDispose
    .family<List<AllocationRow>, String>(
      (ref, id) =>
          ref.watch(billingRepositoryProvider).watchPaymentAllocations(id),
    );
final partProvider = StreamProvider.autoDispose.family<PartWithStock?, String>(
  (ref, id) => ref.watch(inventoryRepositoryProvider).watchPart(id),
);
final partMovementsProvider = StreamProvider.autoDispose
    .family<List<MovementRow>, String>(
      (ref, id) => ref.watch(inventoryRepositoryProvider).watchMovements(id),
    );
final attachmentsProvider = StreamProvider.autoDispose
    .family<List<Attachment>, (String, String)>(
      (ref, key) =>
          ref.watch(attachmentRepositoryProvider).watchFor(key.$1, key.$2),
    );

final dashboardStatsProvider = StreamProvider.autoDispose<DashboardStats>(
  (ref) => ref.watch(dashboardRepositoryProvider).watchStats(),
);
final topBalancesProvider = StreamProvider.autoDispose<List<CompanyBalance>>(
  (ref) => ref.watch(dashboardRepositoryProvider).watchTopBalances(),
);

final documentServiceProvider = Provider(
  (ref) => DocumentService(
    db: ref.watch(databaseProvider),
    billing: ref.watch(billingRepositoryProvider),
    visits: ref.watch(visitRepositoryProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
    cloudBytes: (a) async {
      final sync = ref.read(syncControllerProvider.notifier).service;
      return sync?.downloadAttachmentBytes(a);
    },
  ),
);
final backupServiceProvider = Provider(
  (ref) => BackupService(
    ref.watch(databaseProvider),
    ref.watch(documentsDirProvider),
  ),
);
