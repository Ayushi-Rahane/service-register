import 'package:flutter/material.dart';

import '../../data/repositories/base_repository.dart';
import '../theme/app_theme.dart';

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: ctx.colors.error,
                  foregroundColor: ctx.colors.onError,
                )
              : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Asks for a line of text (e.g. a reason). Returns null when cancelled.
Future<String?> promptText(
  BuildContext context, {
  required String title,
  String? message,
  String label = 'Reason',
  String confirmLabel = 'OK',
  bool required = false,
  String initial = '',
  bool destructive = false,
}) {
  final controller = TextEditingController(text: initial);
  final formKey = GlobalKey<FormState>();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message != null) ...[
              Text(message),
              const SizedBox(height: Gap.md),
            ],
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: label),
              validator: (v) => required && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: ctx.colors.error,
                  foregroundColor: ctx.colors.onError,
                )
              : null,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(ctx, controller.text.trim());
            }
          },
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

void showMessage(BuildContext context, String message, {bool error = false}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? context.colors.error : null,
        duration: Duration(seconds: error ? 5 : 3),
      ),
    );
}

/// User-facing text for an exception.
String errorText(Object e) {
  if (e is BusinessRuleException) return e.message;
  if (e is FormatException) return e.message;
  if (e is StateError) return e.message;
  return 'Could not complete the action. $e';
}

/// Runs [action] and reports failures with a snackbar. Returns success.
Future<bool> runGuarded(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (success != null && context.mounted) showMessage(context, success);
    return true;
  } catch (e) {
    if (context.mounted) showMessage(context, errorText(e), error: true);
    return false;
  }
}

/// Bottom sheet with a list of actions.
Future<T?> showActionSheet<T>(
  BuildContext context, {
  String? title,
  required List<({IconData icon, String label, T value})> actions,
}) => showModalBottomSheet<T>(
  context: context,
  showDragHandle: true,
  builder: (ctx) => SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.sm),
            child: Text(title, style: ctx.text.titleMedium),
          ),
        for (final a in actions)
          ListTile(
            leading: Icon(a.icon),
            title: Text(a.label),
            onTap: () => Navigator.pop(ctx, a.value),
          ),
        const SizedBox(height: Gap.sm),
      ],
    ),
  ),
);
