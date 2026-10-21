import '../core/utils/ids.dart';
import 'billing.dart';
import 'enums.dart';

/// Mutable form state for a service visit. Ids are generated when the form
/// opens, so pressing Save twice updates the same record instead of creating
/// a duplicate.
class VisitDraft {
  VisitDraft({
    String? id,
    required this.companyId,
    this.machineId,
    required this.visitDate,
    this.arrivalTime,
    this.departureTime,
    this.serviceType = ServiceType.routineMaintenance,
    this.status = VisitStatus.inProgress,
    this.technicianName,
    this.reportedProblem,
    this.symptoms,
    this.diagnosis,
    this.rootCause,
    this.workDone,
    this.actionsTaken,
    this.testsPerformed,
    this.machineStatusAfter,
    this.recommendations,
    this.labourPaise = 0,
    this.travelPaise = 0,
    this.discountPaise = 0,
    this.taxRateBp = 0,
    this.onsitePaymentPaise = 0,
    this.onsitePaymentMethod = PaymentMethod.cash,
    this.customerFeedback,
    this.signedBy,
    this.nextServiceDate,
    this.internalNotes,
    List<VisitPartDraft>? parts,
  }) : id = id ?? Ids.newId(),
       parts = parts ?? [];

  final String id;
  String companyId;
  String? machineId;
  String visitDate;
  String? arrivalTime;
  String? departureTime;
  ServiceType serviceType;
  VisitStatus status;
  String? technicianName;
  String? reportedProblem;
  String? symptoms;
  String? diagnosis;
  String? rootCause;
  String? workDone;
  String? actionsTaken;
  String? testsPerformed;
  MachineStatus? machineStatusAfter;
  String? recommendations;
  int labourPaise;
  int travelPaise;
  int discountPaise;
  int taxRateBp;
  int onsitePaymentPaise;
  PaymentMethod onsitePaymentMethod;
  String? customerFeedback;
  String? signedBy;
  String? nextServiceDate;
  String? internalNotes;
  final List<VisitPartDraft> parts;

  int get partsTotal => parts.fold(0, (s, p) => s + p.lineTotal);

  ChargeBreakdown get charges => ChargeBreakdown(
    labour: labourPaise,
    parts: partsTotal,
    travel: travelPaise,
    other: 0,
    discount: discountPaise,
    taxRateBp: taxRateBp,
  );
}

class VisitPartDraft {
  VisitPartDraft({
    String? id,
    this.partId,
    required this.partName,
    this.partNumber,
    this.qtyMilli = 1000,
    this.unitCostPaise,
    this.unitPricePaise = 0,
    this.addToCatalogue = false,
  }) : id = id ?? Ids.newId();

  final String id;
  String? partId;
  String partName;
  String? partNumber;
  int qtyMilli;
  int? unitCostPaise;
  int unitPricePaise;

  /// For unlisted parts: create a catalogue entry when saving.
  bool addToCatalogue;

  int get lineTotal => Billing.lineTotal(qtyMilli, unitPricePaise);
}

class InvoiceLineDraft {
  InvoiceLineDraft({
    String? id,
    this.kind = InvoiceItemKind.other,
    required this.description,
    this.qtyMilli = 1000,
    this.unitPricePaise = 0,
    this.visitId,
  }) : id = id ?? Ids.newId();

  final String id;
  InvoiceItemKind kind;
  String description;
  int qtyMilli;
  int unitPricePaise;
  String? visitId;

  int get amount => Billing.lineTotal(qtyMilli, unitPricePaise);
}

class InvoiceDraft {
  InvoiceDraft({
    String? id,
    required this.companyId,
    required this.invoiceDate,
    this.dueDate,
    this.discountPaise = 0,
    this.taxLabel,
    this.taxRateBp = 0,
    this.notes,
    List<InvoiceLineDraft>? lines,
    Set<String>? visitIds,
  }) : id = id ?? Ids.newId(),
       lines = lines ?? [],
       visitIds = visitIds ?? {};

  final String id;
  String companyId;
  String invoiceDate;
  String? dueDate;
  int discountPaise;
  String? taxLabel;
  int taxRateBp;
  String? notes;
  final List<InvoiceLineDraft> lines;
  final Set<String> visitIds;

  ChargeBreakdown get charges => ChargeBreakdown.fromLines(
    lines.map((l) => (kind: l.kind, amount: l.amount)),
    discount: discountPaise,
    taxRateBp: taxRateBp,
  );
}

class PaymentDraft {
  PaymentDraft({
    String? id,
    required this.companyId,
    required this.paidOn,
    required this.amountPaise,
    this.method = PaymentMethod.cash,
    this.reference,
    this.notes,
    Map<String, int>? allocations,
  }) : id = id ?? Ids.newId(),
       allocations = allocations ?? {};

  final String id;
  String companyId;
  String paidOn;
  int amountPaise;
  PaymentMethod method;
  String? reference;
  String? notes;

  /// invoiceId -> amount applied to that invoice.
  final Map<String, int> allocations;
}
