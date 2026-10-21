import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../domain/app_settings.dart';
import '../../domain/billing.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _form = GlobalKey<FormState>();
  late BusinessSettings _s = ref.read(settingsProvider);
  late final _c = <String, TextEditingController>{
    'businessName': TextEditingController(text: _s.businessName),
    'ownerName': TextEditingController(text: _s.ownerName),
    'phone': TextEditingController(text: _s.phone),
    'email': TextEditingController(text: _s.email),
    'address': TextEditingController(text: _s.address),
    'gstin': TextEditingController(text: _s.gstin),
    'upi': TextEditingController(text: _s.upiId),
    'bank': TextEditingController(text: _s.bankDetails),
    'tech': TextEditingController(text: _s.technicianName),
    'invPrefix': TextEditingController(text: _s.invoicePrefix),
    'visitPrefix': TextEditingController(text: _s.visitPrefix),
    'rcptPrefix': TextEditingController(text: _s.receiptPrefix),
    'taxLabel': TextEditingController(text: _s.taxLabel),
    'taxRate': TextEditingController(
      text: Billing.rateLabel(_s.defaultTaxRateBp),
    ),
    'dueDays': TextEditingController(text: '${_s.defaultDueDays}'),
    'terms': TextEditingController(text: _s.invoiceTerms),
  };
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _t(String k) => _c[k]!.text.trim();

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final next = _s.copyWith(
      businessName: _t('businessName'),
      ownerName: _t('ownerName'),
      phone: _t('phone'),
      email: _t('email'),
      address: _t('address'),
      gstin: _t('gstin').toUpperCase(),
      upiId: _t('upi'),
      bankDetails: _t('bank'),
      technicianName: _t('tech'),
      invoicePrefix: _t('invPrefix').toUpperCase(),
      visitPrefix: _t('visitPrefix').toUpperCase(),
      receiptPrefix: _t('rcptPrefix').toUpperCase(),
      taxLabel: _t('taxLabel'),
      defaultTaxRateBp: Billing.parseRate(_t('taxRate')) ?? _s.defaultTaxRateBp,
      defaultDueDays: int.tryParse(_t('dueDays')) ?? 15,
      invoiceTerms: _t('terms'),
    );
    final ok = await runGuarded(
      context,
      () => ref.read(settingsProvider.notifier).save(next),
      success: 'Settings saved',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) context.pop();
  }

  String? _prefix(String v) => RegExp(r'^[A-Za-z]{1,6}$').hasMatch(v.trim())
      ? null
      : '1–6 letters, e.g. INV';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
        child: FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: const Icon(Icons.check),
          label: const Text('Save settings'),
        ),
      ),
    ),
    body: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(Gap.lg),
        children: [
          SectionCard(
            title: 'Your business (printed on invoices)',
            icon: Icons.storefront_outlined,
            child: Column(
              children: [
                AppTextField(
                  controller: _c['businessName']!,
                  label: 'Business name',
                  capitalization: TextCapitalization.words,
                ),
                AppTextField(
                  controller: _c['ownerName']!,
                  label: 'Owner name',
                  capitalization: TextCapitalization.words,
                ),
                AppTextField(
                  controller: _c['phone']!,
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
                ),
                AppTextField(
                  controller: _c['email']!,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  capitalization: TextCapitalization.none,
                ),
                AppTextField(
                  controller: _c['address']!,
                  label: 'Address',
                  maxLines: 3,
                  minLines: 1,
                ),
                AppTextField(
                  controller: _c['gstin']!,
                  label: 'Your GSTIN (if registered)',
                  capitalization: TextCapitalization.characters,
                  validator: (v) =>
                      v.isEmpty ||
                          RegExp(r'^[0-9A-Za-z]{15}$').hasMatch(v.trim())
                      ? null
                      : 'GSTIN has 15 letters/digits',
                ),
                AppTextField(
                  controller: _c['upi']!,
                  label: 'UPI ID for payments',
                  capitalization: TextCapitalization.none,
                  hint: 'name@bank',
                ),
                AppTextField(
                  controller: _c['bank']!,
                  label: 'Bank details (optional)',
                  maxLines: 3,
                  minLines: 1,
                  hint: 'A/c name, number, IFSC',
                ),
                AppTextField(
                  controller: _c['tech']!,
                  label: 'Technician name (default on visits)',
                  capitalization: TextCapitalization.words,
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'Invoices & numbering',
            icon: Icons.receipt_long_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _c['invPrefix']!,
                        label: 'Invoice',
                        validator: _prefix,
                        capitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(width: Gap.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _c['visitPrefix']!,
                        label: 'Visit',
                        validator: _prefix,
                        capitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(width: Gap.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _c['rcptPrefix']!,
                        label: 'Receipt',
                        validator: _prefix,
                        capitalization: TextCapitalization.characters,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Numbers look like ${_c['invPrefix']!.text.toUpperCase()}-2627-0001 (financial year + running number). '
                  'If you use two phones, give each a different prefix.',
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: Gap.md),
                AppTextField(
                  controller: _c['dueDays']!,
                  label: 'Payment due after (days)',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (int.tryParse(v) ?? -1) >= 0 ? null : 'Enter days',
                ),
                AppTextField(
                  controller: _c['terms']!,
                  label: 'Default note on invoices',
                  maxLines: 3,
                  minLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'Tax',
            icon: Icons.percent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _s.taxEnabled,
                  title: const Text('Show tax option on visits and invoices'),
                  subtitle: const Text(
                    'Tax is added only when you switch it on for a visit / invoice',
                  ),
                  onChanged: (v) =>
                      setState(() => _s = _s.copyWith(taxEnabled: v)),
                ),
                if (_s.taxEnabled) ...[
                  AppTextField(
                    controller: _c['taxLabel']!,
                    label: 'Tax name',
                    hint: 'GST',
                  ),
                  AppTextField(
                    controller: _c['taxRate']!,
                    label: 'Default rate (%)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) =>
                        Billing.parseRate(v) == null ? 'Enter 0–100' : null,
                  ),
                ],
                const NoticeBanner(
                  message:
                      'This app calculates a single tax rate on the bill. It does not certify GST compliance '
                      '(e.g. CGST/SGST split, HSN codes). Confirm requirements with your accountant.',
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'Spare parts stock',
            icon: Icons.inventory_2_outlined,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _s.inventoryEnabled,
              title: const Text('Track stock quantities'),
              subtitle: const Text(
                'When off, parts are still recorded on visits but stock is not deducted',
              ),
              onChanged: (v) =>
                  setState(() => _s = _s.copyWith(inventoryEnabled: v)),
            ),
          ),
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'App',
            icon: Icons.phone_android,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _s.remindersEnabled,
                  title: const Text('Reminder notifications'),
                  subtitle: const Text(
                    'Visits, follow-ups and overdue invoices. Delivery depends on phone battery settings.',
                  ),
                  onChanged: (v) async {
                    if (v) {
                      await NotificationService.instance.requestPermission();
                    }
                    setState(() => _s = _s.copyWith(remindersEnabled: v));
                  },
                ),
                const SizedBox(height: Gap.sm),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'light',
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                    ButtonSegment(value: 'system', label: Text('Auto')),
                  ],
                  selected: {_s.themeMode},
                  onSelectionChanged: (v) =>
                      setState(() => _s = _s.copyWith(themeMode: v.first)),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
