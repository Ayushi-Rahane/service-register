/// User-editable business settings, stored as key/value pairs on the device and
/// included in backups.
class BusinessSettings {
  const BusinessSettings({
    this.businessName = '',
    this.ownerName = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.gstin = '',
    this.upiId = '',
    this.bankDetails = '',
    this.invoicePrefix = 'INV',
    this.visitPrefix = 'SV',
    this.receiptPrefix = 'RCPT',
    this.taxEnabled = false,
    this.taxLabel = 'GST',
    this.defaultTaxRateBp = 1800,
    this.defaultDueDays = 15,
    this.inventoryEnabled = true,
    this.technicianName = '',
    this.themeMode = 'light',
    this.invoiceTerms = 'Thank you for your business.',
    this.paymentReminderTemplate = defaultReminderTemplate,
    this.remindersEnabled = true,
    this.onboarded = false,
  });

  static const defaultReminderTemplate =
      'Dear {contact},\n\nThis is a gentle reminder that invoice {invoice_no} '
      'dated {invoice_date} for {amount} is pending. The balance due is '
      '{balance}{due_text}.\n\nKindly arrange the payment at your earliest '
      'convenience. Please ignore this message if already paid.\n\n'
      'Thank you,\n{business}';

  final String businessName;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final String gstin;
  final String upiId;
  final String bankDetails;
  final String invoicePrefix;
  final String visitPrefix;
  final String receiptPrefix;
  final bool taxEnabled;
  final String taxLabel;
  final int defaultTaxRateBp;
  final int defaultDueDays;
  final bool inventoryEnabled;
  final String technicianName;

  /// 'light' | 'dark' | 'system'
  final String themeMode;
  final String invoiceTerms;
  final String paymentReminderTemplate;
  final bool remindersEnabled;
  final bool onboarded;

  String get displayBusinessName =>
      businessName.isEmpty ? 'My Service Business' : businessName;

  Map<String, String> toMap() => {
    'business_name': businessName,
    'owner_name': ownerName,
    'phone': phone,
    'email': email,
    'address': address,
    'gstin': gstin,
    'upi_id': upiId,
    'bank_details': bankDetails,
    'invoice_prefix': invoicePrefix,
    'visit_prefix': visitPrefix,
    'receipt_prefix': receiptPrefix,
    'tax_enabled': '$taxEnabled',
    'tax_label': taxLabel,
    'default_tax_rate_bp': '$defaultTaxRateBp',
    'default_due_days': '$defaultDueDays',
    'inventory_enabled': '$inventoryEnabled',
    'technician_name': technicianName,
    'theme_mode': themeMode,
    'invoice_terms': invoiceTerms,
    'payment_reminder_template': paymentReminderTemplate,
    'reminders_enabled': '$remindersEnabled',
    'onboarded': '$onboarded',
  };

  factory BusinessSettings.fromMap(Map<String, String> m) {
    const d = BusinessSettings();
    bool b(String k, bool def) => m[k] == null ? def : m[k] == 'true';
    int i(String k, int def) => int.tryParse(m[k] ?? '') ?? def;
    String s(String k, String def) => m[k] ?? def;
    return BusinessSettings(
      businessName: s('business_name', d.businessName),
      ownerName: s('owner_name', d.ownerName),
      phone: s('phone', d.phone),
      email: s('email', d.email),
      address: s('address', d.address),
      gstin: s('gstin', d.gstin),
      upiId: s('upi_id', d.upiId),
      bankDetails: s('bank_details', d.bankDetails),
      invoicePrefix: s('invoice_prefix', d.invoicePrefix),
      visitPrefix: s('visit_prefix', d.visitPrefix),
      receiptPrefix: s('receipt_prefix', d.receiptPrefix),
      taxEnabled: b('tax_enabled', d.taxEnabled),
      taxLabel: s('tax_label', d.taxLabel),
      defaultTaxRateBp: i('default_tax_rate_bp', d.defaultTaxRateBp),
      defaultDueDays: i('default_due_days', d.defaultDueDays),
      inventoryEnabled: b('inventory_enabled', d.inventoryEnabled),
      technicianName: s('technician_name', d.technicianName),
      themeMode: s('theme_mode', d.themeMode),
      invoiceTerms: s('invoice_terms', d.invoiceTerms),
      paymentReminderTemplate: s(
        'payment_reminder_template',
        d.paymentReminderTemplate,
      ),
      remindersEnabled: b('reminders_enabled', d.remindersEnabled),
      onboarded: b('onboarded', d.onboarded),
    );
  }

  BusinessSettings copyWith({
    String? businessName,
    String? ownerName,
    String? phone,
    String? email,
    String? address,
    String? gstin,
    String? upiId,
    String? bankDetails,
    String? invoicePrefix,
    String? visitPrefix,
    String? receiptPrefix,
    bool? taxEnabled,
    String? taxLabel,
    int? defaultTaxRateBp,
    int? defaultDueDays,
    bool? inventoryEnabled,
    String? technicianName,
    String? themeMode,
    String? invoiceTerms,
    String? paymentReminderTemplate,
    bool? remindersEnabled,
    bool? onboarded,
  }) => BusinessSettings(
    businessName: businessName ?? this.businessName,
    ownerName: ownerName ?? this.ownerName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    address: address ?? this.address,
    gstin: gstin ?? this.gstin,
    upiId: upiId ?? this.upiId,
    bankDetails: bankDetails ?? this.bankDetails,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    visitPrefix: visitPrefix ?? this.visitPrefix,
    receiptPrefix: receiptPrefix ?? this.receiptPrefix,
    taxEnabled: taxEnabled ?? this.taxEnabled,
    taxLabel: taxLabel ?? this.taxLabel,
    defaultTaxRateBp: defaultTaxRateBp ?? this.defaultTaxRateBp,
    defaultDueDays: defaultDueDays ?? this.defaultDueDays,
    inventoryEnabled: inventoryEnabled ?? this.inventoryEnabled,
    technicianName: technicianName ?? this.technicianName,
    themeMode: themeMode ?? this.themeMode,
    invoiceTerms: invoiceTerms ?? this.invoiceTerms,
    paymentReminderTemplate:
        paymentReminderTemplate ?? this.paymentReminderTemplate,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    onboarded: onboarded ?? this.onboarded,
  );
}
