import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../data/local/app_database.dart';
import '../../domain/templates.dart';
import '../../services/document_service.dart';
import '../../services/external_actions.dart';
import '../providers.dart';

/// Prepares a polite payment reminder. Nothing is sent automatically: the user
/// reviews the text and chooses WhatsApp / SMS / share.
class PaymentReminderScreen extends ConsumerStatefulWidget {
  const PaymentReminderScreen({super.key, required this.invoiceId});
  final String invoiceId;
  @override
  ConsumerState<PaymentReminderScreen> createState() =>
      _PaymentReminderScreenState();
}

class _PaymentReminderScreenState extends ConsumerState<PaymentReminderScreen> {
  final _text = TextEditingController();
  Company? _company;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final inv = (await ref
        .read(billingRepositoryProvider)
        .getInvoice(widget.invoiceId))!;
    _company = await ref
        .read(companyRepositoryProvider)
        .get(inv.invoice.companyId);
    final s = ref.read(settingsProvider);
    _text.text = MessageTemplates.paymentReminder(
      template: s.paymentReminderTemplate,
      companyName: inv.companyName,
      contactPerson: _company?.contactPerson,
      invoiceNo: inv.invoice.invoiceNo,
      invoiceDate: inv.invoice.invoiceDate,
      totalPaise: inv.invoice.totalPaise,
      balancePaise: inv.balance.outstanding,
      dueDate: inv.invoice.dueDate,
      today: Dates.today(),
      businessName: s.displayBusinessName,
      upiId: s.upiId,
    );
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _do(Future<String?> f) async {
    final err = await f;
    if (err != null && mounted) showMessage(context, err, error: true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Payment reminder')),
    body: _loading
        ? const LoadingView()
        : ListView(
            padding: const EdgeInsets.all(Gap.lg),
            children: [
              const NoticeBanner(
                message:
                    'Check the message, edit it if needed, then choose how to send it. Nothing is sent automatically.',
              ),
              const SizedBox(height: Gap.md),
              TextField(
                controller: _text,
                maxLines: 14,
                minLines: 8,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
              const SizedBox(height: Gap.lg),
              FilledButton.icon(
                onPressed: () => _do(
                  ExternalActions.whatsapp(_text.text, phone: _company?.phone),
                ),
                icon: const Icon(Icons.chat),
                label: Text(
                  _company?.phone == null
                      ? 'Share on WhatsApp'
                      : 'WhatsApp ${_company!.phone}',
                ),
              ),
              const SizedBox(height: Gap.sm),
              OutlinedButton.icon(
                onPressed: () => _do(
                  ExternalActions.sms(_text.text, phone: _company?.phone),
                ),
                icon: const Icon(Icons.sms_outlined),
                label: const Text('Send as SMS'),
              ),
              const SizedBox(height: Gap.sm),
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final doc = await ref
                        .read(documentServiceProvider)
                        .invoice(widget.invoiceId, ref.read(settingsProvider));
                    await DocumentService.share(doc, text: _text.text);
                  } catch (e) {
                    if (context.mounted) {
                      showMessage(context, errorText(e), error: true);
                    }
                  }
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Share with invoice PDF'),
              ),
              const SizedBox(height: Gap.sm),
              TextButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: _text.text));
                  if (context.mounted) showMessage(context, 'Copied');
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy text'),
              ),
            ],
          ),
  );
}
