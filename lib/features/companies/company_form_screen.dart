import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/base_repository.dart';
import '../../data/repositories/company_repository.dart';

class CompanyFormScreen extends ConsumerStatefulWidget {
  const CompanyFormScreen({super.key, this.id, this.returnResult = false});
  final String? id;

  /// When opened from a picker, pop with the new company id.
  final bool returnResult;

  @override
  ConsumerState<CompanyFormScreen> createState() => _CompanyFormScreenState();
}

class _CompanyFormScreenState extends ConsumerState<CompanyFormScreen> {
  final _form = GlobalKey<FormState>();
  final _c = <String, TextEditingController>{
    for (final k in [
      'name',
      'code',
      'contact',
      'phone',
      'alt',
      'email',
      'address',
      'city',
      'state',
      'pincode',
      'gstin',
      'notes',
    ])
      k: TextEditingController(),
  };
  bool _loading = true;
  bool _saving = false;
  Company? _existing;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(companyRepositoryProvider);
    if (widget.id != null) {
      final c = await repo.get(widget.id!);
      if (c != null) {
        _existing = c;
        _c['name']!.text = c.name;
        _c['code']!.text = c.code ?? '';
        _c['contact']!.text = c.contactPerson ?? '';
        _c['phone']!.text = c.phone ?? '';
        _c['alt']!.text = c.altPhone ?? '';
        _c['email']!.text = c.email ?? '';
        _c['address']!.text = c.address ?? '';
        _c['city']!.text = c.city ?? '';
        _c['state']!.text = c.state ?? '';
        _c['pincode']!.text = c.pincode ?? '';
        _c['gstin']!.text = c.gstin ?? '';
        _c['notes']!.text = c.notes ?? '';
      }
    } else {
      _c['code']!.text = await repo.nextCode();
      _c['state']!.text = 'Maharashtra';
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? _v(String k) => emptyToNull(_c[k]!.text);

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(companyRepositoryProvider);
    try {
      final dups = await repo.findPossibleDuplicates(
        name: _c['name']!.text,
        phone: _v('phone'),
        altPhone: _v('alt'),
        excludeId: widget.id,
      );
      if (dups.isNotEmpty && mounted) {
        final proceed = await _confirmDuplicates(dups);
        if (!proceed) {
          setState(() => _saving = false);
          return;
        }
      }
      final id = await repo.save(
        CompaniesCompanion(
          name: Value(_c['name']!.text.trim()),
          code: Value(_v('code')),
          contactPerson: Value(_v('contact')),
          phone: Value(_v('phone')),
          altPhone: Value(_v('alt')),
          email: Value(_v('email')),
          address: Value(_v('address')),
          city: Value(_v('city')),
          state: Value(_v('state')),
          pincode: Value(_v('pincode')),
          gstin: Value(_v('gstin')?.toUpperCase()),
          notes: Value(_v('notes')),
        ),
        id: widget.id,
      );
      if (!mounted) return;
      showMessage(
        context,
        widget.id == null ? 'Company added' : 'Changes saved',
      );
      if (widget.returnResult) {
        context.pop(id);
      } else if (widget.id == null) {
        context.pushReplacement('/company/$id');
      } else {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, errorText(e), error: true);
        setState(() => _saving = false);
      }
    }
  }

  Future<bool> _confirmDuplicates(List<DuplicateMatch> dups) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Possible duplicate'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'These companies look similar. Check that you are not adding the same company twice.',
              ),
              const SizedBox(height: Gap.md),
              for (final d in dups.take(5))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.apartment),
                  title: Text(d.company.name),
                  subtitle: Text(
                    [d.reason, ?d.company.phone, ?d.company.city].join(' • '),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Go back'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save anyway'),
          ),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.id == null ? 'Add company' : 'Edit company'),
    ),
    bottomNavigationBar: BottomActionBar(
      child: FilledButton.icon(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: Text(widget.id == null ? 'Save company' : 'Save changes'),
      ),
    ),
    body: _loading
        ? const LoadingView()
        : Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(Gap.lg),
              children: [
                if (_existing?.archivedAt != null) ...[
                  const NoticeBanner(message: 'This company is archived.'),
                  const SizedBox(height: Gap.md),
                ],
                AppTextField(
                  controller: _c['name']!,
                  label: 'Company name',
                  required: true,
                  capitalization: TextCapitalization.words,
                  autofocus: widget.id == null,
                ),
                AppTextField(
                  controller: _c['code']!,
                  label: 'Customer code',
                  helper: 'Generated automatically; you can change it',
                  capitalization: TextCapitalization.characters,
                ),
                AppTextField(
                  controller: _c['contact']!,
                  label: 'Contact person',
                  capitalization: TextCapitalization.words,
                ),
                AppTextField(
                  controller: _c['phone']!,
                  label: 'Phone number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                  validator: _phone,
                ),
                AppTextField(
                  controller: _c['alt']!,
                  label: 'Alternate phone',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_forwarded,
                  validator: _phone,
                ),
                AppTextField(
                  controller: _c['email']!,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  capitalization: TextCapitalization.none,
                  prefixIcon: Icons.email_outlined,
                  validator: _email,
                ),
                AppTextField(
                  controller: _c['address']!,
                  label: 'Address',
                  maxLines: 3,
                  minLines: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _c['city']!,
                        label: 'City',
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: AppTextField(
                        controller: _c['pincode']!,
                        label: 'PIN code',
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v.isEmpty || RegExp(r'^\d{6}$').hasMatch(v.trim())
                            ? null
                            : 'Enter 6 digits',
                      ),
                    ),
                  ],
                ),
                AppTextField(
                  controller: _c['state']!,
                  label: 'State',
                  capitalization: TextCapitalization.words,
                ),
                AppTextField(
                  controller: _c['gstin']!,
                  label: 'GSTIN (if registered)',
                  capitalization: TextCapitalization.characters,
                  validator: (v) =>
                      v.isEmpty ||
                          RegExp(r'^[0-9A-Za-z]{15}$').hasMatch(v.trim())
                      ? null
                      : 'GSTIN has 15 letters/digits',
                ),
                AppTextField(
                  controller: _c['notes']!,
                  label: 'Notes',
                  maxLines: 4,
                  minLines: 2,
                  hint: 'Gate timings, payment habits, special instructions…',
                ),
              ],
            ),
          ),
  );

  static String? _phone(String v) {
    if (v.trim().isEmpty) return null;
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length < 6 || digits.length > 13
        ? 'Enter a valid phone number'
        : null;
  }

  static String? _email(String v) {
    if (v.trim().isEmpty) return null;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())
        ? null
        : 'Enter a valid email';
  }
}
