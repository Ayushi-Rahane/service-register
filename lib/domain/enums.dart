/// Enumerations stored as text in the database. `db` is the persisted value;
/// `label` is the English display text.
library;

abstract interface class Labeled {
  String get db;
  String get label;
}

T _fromDb<T extends Labeled>(List<T> values, String? db, T fallback) {
  for (final v in values) {
    if (v.db == db) return v;
  }
  return fallback;
}

enum MachineCategory implements Labeled {
  pcb('pcb', 'PCB'),
  cbc('cbc', 'CBC'),
  other('other', 'Other');

  const MachineCategory(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static MachineCategory fromDb(String? v) => _fromDb(values, v, other);
}

enum MachineStatus implements Labeled {
  operational('operational', 'Operational'),
  needsAttention('needs_attention', 'Needs attention'),
  underRepair('under_repair', 'Under repair'),
  decommissioned('decommissioned', 'Decommissioned');

  const MachineStatus(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static MachineStatus fromDb(String? v) => _fromDb(values, v, operational);
}

enum ServiceType implements Labeled {
  routineMaintenance('routine_maintenance', 'Routine maintenance'),
  breakdownRepair('breakdown_repair', 'Breakdown repair'),
  installation('installation', 'Installation'),
  inspection('inspection', 'Inspection'),
  emergency('emergency', 'Emergency visit'),
  other('other', 'Other');

  const ServiceType(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static ServiceType fromDb(String? v) =>
      _fromDb(values, v, routineMaintenance);
}

enum VisitStatus implements Labeled {
  scheduled('scheduled', 'Scheduled'),
  inProgress('in_progress', 'In progress'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const VisitStatus(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static VisitStatus fromDb(String? v) => _fromDb(values, v, inProgress);
}

enum PaymentMethod implements Labeled {
  cash('cash', 'Cash'),
  upi('upi', 'UPI'),
  bankTransfer('bank_transfer', 'Bank transfer'),
  cheque('cheque', 'Cheque'),
  other('other', 'Other');

  const PaymentMethod(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static PaymentMethod fromDb(String? v) => _fromDb(values, v, cash);
}

enum PaymentStatus implements Labeled {
  unpaid('unpaid', 'Unpaid'),
  partiallyPaid('partially_paid', 'Partially paid'),
  paid('paid', 'Paid'),
  overdue('overdue', 'Overdue'),
  cancelled('cancelled', 'Cancelled');

  const PaymentStatus(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static PaymentStatus fromDb(String? v) => _fromDb(values, v, unpaid);
}

enum InvoiceItemKind implements Labeled {
  labour('labour', 'Labour'),
  part('part', 'Spare part'),
  travel('travel', 'Travel / other charges'),
  other('other', 'Other');

  const InvoiceItemKind(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static InvoiceItemKind fromDb(String? v) => _fromDb(values, v, other);
}

enum StockMovementKind implements Labeled {
  opening('opening', 'Opening stock'),
  purchase('purchase', 'Purchase'),
  adjustment('adjustment', 'Adjustment'),
  visitUsage('visit_usage', 'Used in service visit');

  const StockMovementKind(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static StockMovementKind fromDb(String? v) => _fromDb(values, v, adjustment);
}

enum ReminderKind implements Labeled {
  followUp('follow_up', 'Customer follow-up'),
  payment('payment', 'Payment follow-up'),
  maintenance('maintenance', 'Maintenance due'),
  other('other', 'Other');

  const ReminderKind(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static ReminderKind fromDb(String? v) => _fromDb(values, v, followUp);
}

enum ReminderStatus implements Labeled {
  pending('pending', 'Pending'),
  done('done', 'Done'),
  cancelled('cancelled', 'Cancelled');

  const ReminderStatus(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static ReminderStatus fromDb(String? v) => _fromDb(values, v, pending);
}

enum AttachmentKind implements Labeled {
  photoBefore('photo_before', 'Before photo'),
  photoAfter('photo_after', 'After photo'),
  document('document', 'Document'),
  signature('signature', 'Customer signature');

  const AttachmentKind(this.db, this.label);
  @override
  final String db;
  @override
  final String label;
  static AttachmentKind fromDb(String? v) => _fromDb(values, v, document);
}
