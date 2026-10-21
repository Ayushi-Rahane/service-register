import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../services/auth_service.dart';

/// First screen: sign in, or create an account (with the business details
/// printed on invoices). After success the router opens the home screen.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});
  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _business = TextEditingController();
  bool _create = false, _busy = false, _hide = true;

  @override
  void dispose() {
    for (final c in [_email, _password, _name, _business]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final auth = ref.read(authServiceProvider);
    final gate = ref.read(accountGateProvider);
    try {
      var settings = ref.read(settingsProvider);
      if (_create) {
        final needsConfirm = await auth.signUp(
          email: _email.text,
          password: _password.text,
          fullName: _name.text.trim(),
          businessName: _business.text.trim(),
        );
        settings = settings.copyWith(
          businessName: _business.text.trim(),
          ownerName: _name.text.trim(),
          technicianName: _name.text.trim(),
        );
        if (needsConfirm) {
          await ref.read(settingsProvider.notifier).save(settings);
          if (!mounted) return;
          setState(() {
            _create = false;
            _password.clear();
          });
          showMessage(
            context,
            'Account created. Open the link in the email we sent, then sign in here.',
          );
          return;
        }
      } else {
        await auth.signIn(_email.text, _password.text);
        // New device: bring back the business details saved with the account.
        final info = await auth.accountInfo();
        settings = settings.copyWith(
          businessName: settings.businessName.isEmpty
              ? info.businessName
              : null,
          ownerName: settings.ownerName.isEmpty ? info.fullName : null,
          technicianName: settings.technicianName.isEmpty
              ? info.fullName
              : null,
        );
      }
      await ref
          .read(settingsProvider.notifier)
          .save(settings.copyWith(onboarded: true));
      // Opens the home screen (the router watches the gate).
      await gate.markSignedIn();
    } catch (e) {
      if (mounted) showMessage(context, AuthService.describe(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgot() async {
    final email = await promptText(
      context,
      title: 'Reset password',
      label: 'Email',
      initial: _email.text,
      required: true,
      confirmLabel: 'Send link',
    );
    if (email == null || !mounted) return;
    await runGuarded(
      context,
      () => ref.read(authServiceProvider).resetPassword(email),
      success: 'If the email is registered, a reset link has been sent.',
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Gap.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Form(
              key: _form,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: context.colors.primaryContainer,
                      child: Icon(
                        Icons.handyman,
                        size: 36,
                        color: context.colors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: Gap.lg),
                    Text(
                      'Service Register',
                      textAlign: TextAlign.center,
                      style: context.text.headlineSmall,
                    ),
                    const SizedBox(height: Gap.xs),
                    Text(
                      'Service visits, invoices and payments — backed up to your account.',
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Gap.xl),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('Sign in')),
                        ButtonSegment(
                          value: true,
                          label: Text('Create account'),
                        ),
                      ],
                      selected: {_create},
                      onSelectionChanged: (v) =>
                          setState(() => _create = v.first),
                    ),
                    const SizedBox(height: Gap.xl),
                    if (_create) ...[
                      AppTextField(
                        controller: _name,
                        label: 'Your name',
                        required: true,
                        capitalization: TextCapitalization.words,
                      ),
                      AppTextField(
                        controller: _business,
                        label: 'Business name',
                        required: true,
                        hint: 'Printed on invoices',
                        capitalization: TextCapitalization.words,
                      ),
                    ],
                    AppTextField(
                      controller: _email,
                      label: 'Email',
                      required: true,
                      keyboardType: TextInputType.emailAddress,
                      capitalization: TextCapitalization.none,
                      validator: (v) =>
                          RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(v.trim())
                          ? null
                          : 'Enter a valid email',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: TextFormField(
                        controller: _password,
                        obscureText: _hide,
                        autofillHints: [
                          _create
                              ? AutofillHints.newPassword
                              : AutofillHints.password,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          helperText: _create ? 'At least 8 characters' : null,
                          suffixIcon: IconButton(
                            tooltip: _hide ? 'Show password' : 'Hide password',
                            icon: Icon(
                              _hide ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () => setState(() => _hide = !_hide),
                          ),
                        ),
                        validator: (v) {
                          final p = v ?? '';
                          if (_create && p.length < 8) {
                            return 'At least 8 characters';
                          }
                          if (p.isEmpty) return 'Enter your password';
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    ),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_create ? 'Create account' : 'Sign in'),
                    ),
                    if (!_create) ...[
                      const SizedBox(height: Gap.sm),
                      TextButton(
                        onPressed: _forgot,
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
