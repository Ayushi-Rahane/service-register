import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../services/notification_service.dart';

/// First-run setup for builds without cloud backup (with cloud backup the
/// sign-in / create-account screen collects these details instead).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _form = GlobalKey<FormState>();
  final _business = TextEditingController();
  final _owner = TextEditingController();
  final _phone = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _business.dispose();
    _owner.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final s = ref
        .read(settingsProvider)
        .copyWith(
          businessName: _business.text.trim(),
          ownerName: _owner.text.trim(),
          technicianName: _owner.text.trim(),
          phone: _phone.text.trim(),
          onboarded: true,
        );
    final ok = await runGuarded(
      context,
      () => ref.read(settingsProvider.notifier).save(s),
    );
    if (!ok || !mounted) {
      setState(() => _saving = false);
      return;
    }
    await NotificationService.instance.requestPermission();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(Gap.xl),
            children: [
              const SizedBox(height: Gap.xl),
              CircleAvatar(
                radius: 40,
                backgroundColor: context.colors.primaryContainer,
                child: Icon(
                  Icons.handyman,
                  size: 40,
                  color: context.colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: Gap.lg),
              Text(
                'Welcome to Service Register',
                textAlign: TextAlign.center,
                style: context.text.headlineSmall,
              ),
              const SizedBox(height: Gap.sm),
              Text(
                'Keep every company, machine, service visit, invoice and payment in one place — even without internet.',
                textAlign: TextAlign.center,
                style: context.text.bodyLarge,
              ),
              const SizedBox(height: Gap.xl),
              AppTextField(
                controller: _business,
                label: 'Business name',
                required: true,
                capitalization: TextCapitalization.words,
                hint: 'Printed on invoices',
              ),
              AppTextField(
                controller: _owner,
                label: 'Your name',
                capitalization: TextCapitalization.words,
              ),
              AppTextField(
                controller: _phone,
                label: 'Business phone',
                keyboardType: TextInputType.phone,
              ),
              Text(
                'You can change these later in Settings.',
                style: context.text.bodySmall,
              ),
              const SizedBox(height: Gap.xl),
              FilledButton(
                onPressed: _saving ? null : _finish,
                child: const Text('Start using the app'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
