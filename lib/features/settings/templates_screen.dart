import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../domain/app_settings.dart';
import '../../domain/templates.dart';

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({super.key});
  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  late final _c = TextEditingController(
    text: ref.read(settingsProvider).paymentReminderTemplate,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider);
    final preview = MessageTemplates.paymentReminder(
      template: _c.text,
      companyName: 'Shree Electronics',
      contactPerson: 'Mr. Patil',
      invoiceNo: '${s.invoicePrefix}-2627-0012',
      invoiceDate: Dates.addDays(Dates.today(), -20),
      totalPaise: 1250000,
      balancePaise: 450000,
      dueDate: Dates.addDays(Dates.today(), -5),
      today: Dates.today(),
      businessName: s.displayBusinessName,
      upiId: s.upiId,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment reminder message'),
        actions: [
          TextButton(
            onPressed: () => setState(
              () => _c.text = BusinessSettings.defaultReminderTemplate,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
          child: FilledButton(
            onPressed: () async {
              final ok = await runGuarded(
                context,
                () => ref
                    .read(settingsProvider.notifier)
                    .save(s.copyWith(paymentReminderTemplate: _c.text)),
                success: 'Template saved',
              );
              if (ok && context.mounted) context.pop();
            },
            child: const Text('Save template'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Gap.lg),
        children: [
          TextField(
            controller: _c,
            maxLines: 12,
            minLines: 6,
            decoration: const InputDecoration(labelText: 'Message'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'You can use',
            icon: Icons.data_object,
            child: Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: [
                for (final e in MessageTemplates.placeholders.entries)
                  Tooltip(
                    message: e.value,
                    child: ActionChip(
                      label: Text(e.key),
                      onPressed: () {
                        final sel = _c.selection;
                        final pos = sel.isValid ? sel.start : _c.text.length;
                        _c.text = _c.text.replaceRange(
                          pos,
                          sel.isValid ? sel.end : pos,
                          e.key,
                        );
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'Preview',
            icon: Icons.visibility_outlined,
            child: Text(preview),
          ),
        ],
      ),
    );
  }
}
