import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/env.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/form_fields.dart';
import '../../services/auth_service.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _create = false, _busy = false, _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final auth = ref.read(authServiceProvider);
    try {
      if (_create) {
        final needsConfirm = await auth.signUp(
          email: _email.text,
          password: _password.text,
          fullName: _name.text.trim(),
          businessName: ref.read(settingsProvider).businessName,
        );
        if (!mounted) return;
        if (needsConfirm) {
          showMessage(
            context,
            'Account created. Open the link in the email we sent, then sign in.',
          );
          setState(() => _create = false);
          return;
        }
      } else {
        await auth.signIn(_email.text, _password.text);
      }
      if (!mounted) return;
      showMessage(context, 'Signed in. Your records will now be backed up.');
      context.pop();
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
    appBar: AppBar(title: Text(_create ? 'Create account' : 'Sign in')),
    body: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(Gap.lg),
        children: [
          Text(
            _create
                ? 'Create an account to back up your records. Records already on $thisDevice will be uploaded.'
                : 'Sign in to back up and sync your records.',
            style: context.text.bodyLarge,
          ),
          const SizedBox(height: Gap.lg),
          if (_create)
            AppTextField(
              controller: _name,
              label: 'Your name',
              capitalization: TextCapitalization.words,
            ),
          AppTextField(
            controller: _email,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            capitalization: TextCapitalization.none,
            required: true,
            validator: (v) =>
                RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())
                ? null
                : 'Enter a valid email',
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.md),
            child: TextFormField(
              controller: _password,
              obscureText: _hide,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                labelText: 'Password *',
                helperText: _create ? 'At least 8 characters' : null,
                suffixIcon: IconButton(
                  icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _hide = !_hide),
                ),
              ),
              validator: (v) => (v ?? '').length < (_create ? 8 : 1)
                  ? (_create ? 'At least 8 characters' : 'Enter your password')
                  : null,
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
          const SizedBox(height: Gap.sm),
          TextButton(
            onPressed: () => setState(() => _create = !_create),
            child: Text(
              _create
                  ? 'I already have an account'
                  : 'New here? Create an account',
            ),
          ),
          if (!_create)
            TextButton(
              onPressed: _forgot,
              child: const Text('Forgot password?'),
            ),
        ],
      ),
    ),
  );
}
