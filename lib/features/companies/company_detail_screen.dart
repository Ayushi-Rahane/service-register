import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/billing_repository.dart';
import '../../data/repositories/company_repository.dart';
import '../../data/repositories/visit_repository.dart';
import '../../domain/enums.dart';
import '../../services/external_actions.dart';
import '../billing/billing_tiles.dart';
import '../providers.dart';
import '../visits/visit_tile.dart';

class CompanyDetailScreen extends ConsumerWidget {
  const CompanyDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(companyProvider(id));
    return AsyncBody(
      value: company,
      builder: (c) => c == null
          ? Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                icon: Icons.search_off,
                title: 'Company not found',
              ),
            )
          : _CompanyView(company: c),
    );
  }
}

class _CompanyView extends ConsumerWidget {
  const _CompanyView({required this.company});
  final Company company;

  Future<void> _menu(BuildContext context, WidgetRef ref, String action) async {
    final repo = ref.read(companyRepositoryProvider);
    switch (action) {
      case 'edit':
        await context.push('/company/${company.id}/edit');
      case 'reminder':
        await context.push('/reminder/new?companyId=${company.id}');
      case 'report':
        await context.push('/reports/companyHistory?companyId=${company.id}');
      case 'archive':
        final ok = await confirmDialog(
          context,
          title: 'Archive company?',
          message:
              'It will be hidden from lists. All visits, invoices and payments are kept. You can restore it later.',
          confirmLabel: 'Archive',
        );
        if (ok && context.mounted) {
          await runGuarded(
            context,
            () => repo.setArchived(company.id, true),
            success: 'Company archived',
          );
        }
      case 'restore':
        if (context.mounted) {
          await runGuarded(
            context,
            () => repo.setArchived(company.id, false),
            success: 'Company restored',
          );
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTabController(
    length: 4,
    child: Scaffold(
      appBar: AppBar(
        title: Text(company.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/company/${company.id}/edit'),
          ),
          PopupMenuButton<String>(
            onSelected: (a) => _menu(context, ref, a),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'reminder',
                child: Text('Add follow-up reminder'),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Text('Service history report'),
              ),
              if (company.archivedAt == null)
                const PopupMenuItem(
                  value: 'archive',
                  child: Text('Archive company'),
                )
              else
                const PopupMenuItem(
                  value: 'restore',
                  child: Text('Restore company'),
                ),
            ],
          ),
        ],
        bottom: const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Machines'),
            Tab(text: 'Visits'),
            Tab(text: 'Billing'),
          ],
        ),
      ),
      floatingActionButton: company.archivedAt != null
          ? null
          : FloatingActionButton.extended(
              heroTag: 'company-visit',
              onPressed: () =>
                  context.push('/visit/new?companyId=${company.id}'),
              icon: const Icon(Icons.add),
              label: const Text('New visit'),
            ),
      body: TabBarView(
        children: [
          _Overview(company: company),
          _Machines(company: company),
          _Visits(companyId: company.id),
          _Billing(companyId: company.id),
        ],
      ),
    ),
  );
}

class _Overview extends ConsumerWidget {
  const _Overview({required this.company});
  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(companySummaryProvider(company.id));
    final c = company;
    final address = [
      c.address,
      c.city,
      c.state,
      c.pincode,
    ].where((s) => s != null && s.isNotEmpty).join(', ');
    Future<void> report(Future<String?> f) async {
      final err = await f;
      if (err != null && context.mounted) {
        showMessage(context, err, error: true);
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, 96),
      children: [
        if (c.archivedAt != null) ...[
          const NoticeBanner(
            message:
                'Archived company. Restore it from the ⋮ menu to record new visits.',
          ),
          const SizedBox(height: Gap.md),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    report(ExternalActions.call(c.phone ?? c.altPhone)),
                icon: const Icon(Icons.call),
                label: const Text('Call'),
              ),
            ),
            const SizedBox(width: Gap.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => report(
                  ExternalActions.openMap(
                    address.isEmpty ? null : '${c.name}, $address',
                  ),
                ),
                icon: const Icon(Icons.directions),
                label: const Text('Map'),
              ),
            ),
            const SizedBox(width: Gap.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => report(
                  ExternalActions.whatsapp(
                    'Hello ${c.contactPerson ?? c.name},',
                    phone: c.phone,
                  ),
                ),
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Chat'),
              ),
            ),
          ],
        ),
        const SizedBox(height: Gap.lg),
        AsyncBody<CompanySummary>(
          value: summary,
          builder: (s) => SectionCard(
            title: 'Account',
            icon: Icons.account_balance_wallet_outlined,
            child: Column(
              children: [
                AmountLine('Total billed', Money.format(s.billed)),
                AmountLine('Payments received', Money.format(s.received)),
                AmountLine(
                  'Outstanding balance',
                  Money.format(s.outstanding),
                  bold: true,
                  color: s.outstanding > 0 ? context.status.onWarning : null,
                ),
                if (s.credit > 0)
                  AmountLine(
                    'Advance / credit not yet applied',
                    Money.format(s.credit),
                    color: context.status.onSuccess,
                  ),
                const Divider(height: Gap.xl),
                Row(
                  children: [
                    Expanded(
                      child: InfoRow(
                        'Last visit',
                        s.lastVisit == null
                            ? 'None yet'
                            : Dates.display(s.lastVisit),
                        showEmpty: true,
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        'Next visit',
                        s.nextVisit == null
                            ? 'Not scheduled'
                            : Dates.display(s.nextVisit),
                        showEmpty: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Gap.sm),
                Wrap(
                  spacing: Gap.sm,
                  runSpacing: Gap.sm,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          context.push('/payment/new?companyId=${c.id}'),
                      icon: const Icon(Icons.currency_rupee),
                      label: const Text('Record payment'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          context.push('/invoice/new?companyId=${c.id}'),
                      icon: const Icon(Icons.receipt_long),
                      label: const Text('Create invoice'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          context.push('/visit/schedule?companyId=${c.id}'),
                      icon: const Icon(Icons.event),
                      label: const Text('Schedule visit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Gap.md),
        SectionCard(
          title: 'Contact details',
          icon: Icons.contact_phone_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoRow('Customer code', c.code),
              InfoRow('Contact person', c.contactPerson),
              InfoRow('Phone', c.phone),
              InfoRow('Alternate phone', c.altPhone),
              InfoRow('Email', c.email),
              InfoRow('Address', address),
              InfoRow('GSTIN', c.gstin),
              InfoRow(
                'Customer since',
                Dates.displayDate(c.createdAt.toLocal()),
              ),
              if (c.phone == null && c.email == null && address.isEmpty)
                const Text('No contact details yet. Tap edit to add them.'),
            ],
          ),
        ),
        if (c.notes != null) ...[
          const SizedBox(height: Gap.md),
          SectionCard(
            title: 'Notes',
            icon: Icons.sticky_note_2_outlined,
            child: Text(c.notes!),
          ),
        ],
      ],
    );
  }
}

class _Machines extends ConsumerWidget {
  const _Machines({required this.company});
  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(companyMachinesProvider(company.id));
    return AsyncBody(
      value: machines,
      builder: (list) => ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.all(Gap.lg),
            child: OutlinedButton.icon(
              onPressed: () =>
                  context.push('/machine/new?companyId=${company.id}'),
              icon: const Icon(Icons.add),
              label: const Text('Add machine'),
            ),
          ),
          if (list.isEmpty)
            const EmptyState(
              icon: Icons.precision_manufacturing_outlined,
              title: 'No machines yet',
              message: 'Add the PCB / CBC machines installed at this company.',
            ),
          for (final m in list)
            ListTile(
              onTap: () => context.push('/machine/${m.machine.id}'),
              leading: CircleAvatar(
                child: Text(
                  MachineCategory.fromDb(
                    m.machine.category,
                  ).label.substring(0, 1),
                ),
              ),
              title: Text(m.machine.name),
              subtitle: Text(
                [
                  MachineCategory.fromDb(m.machine.category).label,
                  if (m.machine.serialNumber != null)
                    'S/N ${m.machine.serialNumber}',
                  if (m.machine.location != null) m.machine.location!,
                  m.lastVisit == null
                      ? 'Never serviced'
                      : 'Last ${Dates.display(m.lastVisit)}',
                ].join(' • '),
              ),
              trailing: StatusChip.machine(
                MachineStatus.fromDb(m.machine.status),
              ),
            ),
        ],
      ),
    );
  }
}

class _Visits extends ConsumerStatefulWidget {
  const _Visits({required this.companyId});
  final String companyId;
  @override
  ConsumerState<_Visits> createState() => _VisitsState();
}

class _VisitsState extends ConsumerState<_Visits> {
  late final Stream<List<VisitListItem>> _stream = ref
      .read(visitRepositoryProvider)
      .watchList(VisitFilter(companyId: widget.companyId));

  @override
  Widget build(BuildContext context) => StreamBody(
    stream: _stream,
    builder: (context, items) => items.isEmpty
        ? const EmptyState(
            icon: Icons.build_outlined,
            title: 'No service visits yet',
          )
        : ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(indent: Gap.lg),
            itemBuilder: (_, i) => VisitTile(items[i], showCompany: false),
          ),
  );
}

class _Billing extends ConsumerStatefulWidget {
  const _Billing({required this.companyId});
  final String companyId;
  @override
  ConsumerState<_Billing> createState() => _BillingState();
}

class _BillingState extends ConsumerState<_Billing> {
  late final _invoices = ref
      .read(billingRepositoryProvider)
      .watchInvoices(
        InvoiceFilter(companyId: widget.companyId, includeCancelled: true),
      );
  late final _payments = ref
      .read(billingRepositoryProvider)
      .watchPayments(
        PaymentFilter(companyId: widget.companyId, includeVoided: true),
      );

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.only(bottom: 96),
    children: [
      const ListHeader('Invoices'),
      StreamBody(
        stream: _invoices,
        builder: (context, list) => list.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: Gap.lg),
                child: Text('No invoices yet'),
              )
            : Column(
                children: [
                  for (final i in list) InvoiceTile(i, showCompany: false),
                ],
              ),
      ),
      const ListHeader('Payments'),
      StreamBody(
        stream: _payments,
        builder: (context, list) => list.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: Gap.lg),
                child: Text('No payments yet'),
              )
            : Column(
                children: [
                  for (final p in list) PaymentTile(p, showCompany: false),
                ],
              ),
      ),
    ],
  );
}
