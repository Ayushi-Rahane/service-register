import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/stream_body.dart';
import '../../data/repositories/billing_repository.dart';
import '../../domain/enums.dart';
import '../companies/company_picker.dart';
import '../providers.dart';
import '../sync/sync_badge.dart';
import 'billing_tiles.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});
  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(dashboardStatsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments & invoices'),
        actions: [
          IconButton(
            tooltip: 'Reports',
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/reports'),
          ),
          const SyncBadge(),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Invoices'),
            Tab(text: 'Payments received'),
          ],
        ),
      ),
      floatingActionButton: _tabs.index == 0
          ? FloatingActionButton.extended(
              heroTag: 'billing-invoice',
              onPressed: () => context.push('/invoice/new'),
              icon: const Icon(Icons.receipt_long),
              label: const Text('New invoice'),
            )
          : FloatingActionButton.extended(
              heroTag: 'billing-payment',
              onPressed: () => context.push('/payment/new'),
              icon: const Icon(Icons.currency_rupee),
              label: const Text('Record payment'),
            ),
      body: Column(
        children: [
          if (stats != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _Mini(
                      'Outstanding',
                      Money.short(stats.outstanding),
                      context.status.onWarning,
                    ),
                  ),
                  Expanded(
                    child: _Mini(
                      'Overdue',
                      Money.short(stats.overdueAmount),
                      context.colors.error,
                    ),
                  ),
                  Expanded(
                    child: _Mini(
                      'Received this month',
                      Money.short(stats.collectedMonth),
                      context.status.onSuccess,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: const [_InvoicesTab(), _PaymentsTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini(this.label, this.value, this.color);
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: context.text.labelSmall),
      FittedBox(
        child: Text(
          value,
          style: context.text.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}

enum _InvFilter { open, overdue, partial, unpaid, paid, cancelled, all }

class _InvoicesTab extends ConsumerStatefulWidget {
  const _InvoicesTab();
  @override
  ConsumerState<_InvoicesTab> createState() => _InvoicesTabState();
}

class _InvoicesTabState extends ConsumerState<_InvoicesTab> {
  _InvFilter _f = _InvFilter.open;
  final _q = TextEditingController();
  late Stream<List<InvoiceListItem>> _stream = _load();

  Stream<List<InvoiceListItem>> _load() {
    final statuses = switch (_f) {
      _InvFilter.open => {
        PaymentStatus.unpaid,
        PaymentStatus.partiallyPaid,
        PaymentStatus.overdue,
      },
      _InvFilter.overdue => {PaymentStatus.overdue},
      _InvFilter.partial => {PaymentStatus.partiallyPaid},
      _InvFilter.unpaid => {PaymentStatus.unpaid},
      _InvFilter.paid => {PaymentStatus.paid},
      _InvFilter.cancelled => {PaymentStatus.cancelled},
      _InvFilter.all => <PaymentStatus>{},
    };
    return ref
        .read(billingRepositoryProvider)
        .watchInvoices(
          InvoiceFilter(
            statuses: statuses,
            query: _q.text,
            includeCancelled:
                _f == _InvFilter.cancelled || _f == _InvFilter.all,
          ),
        );
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const labels = {
      _InvFilter.open: 'Not fully paid',
      _InvFilter.overdue: 'Overdue',
      _InvFilter.partial: 'Partially paid',
      _InvFilter.unpaid: 'Unpaid',
      _InvFilter.paid: 'Paid',
      _InvFilter.cancelled: 'Cancelled',
      _InvFilter.all: 'All',
    };
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 0),
          child: TextField(
            controller: _q,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Invoice no. or company',
            ),
            onChanged: (_) => setState(() => _stream = _load()),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.sm,
            ),
            children: [
              for (final f in _InvFilter.values)
                Padding(
                  padding: const EdgeInsets.only(right: Gap.sm),
                  child: ChoiceChip(
                    label: Text(labels[f]!),
                    selected: _f == f,
                    onSelected: (_) => setState(() {
                      _f = f;
                      _stream = _load();
                    }),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: StreamBody(
            stream: _stream,
            builder: (context, list) {
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: _f == _InvFilter.open
                      ? 'No pending invoices'
                      : 'No invoices',
                  message:
                      'Invoices are created when you complete a visit, or with the New invoice button.',
                );
              }
              final due = list.fold(0, (s, i) => s + i.balance.outstanding);
              return ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  ListHeader(
                    '${list.length} invoice${list.length == 1 ? '' : 's'}',
                    trailing: due > 0
                        ? Text('Balance ${Money.format(due)}  ')
                        : null,
                  ),
                  for (final i in list) InvoiceTile(i),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PaymentsTab extends ConsumerStatefulWidget {
  const _PaymentsTab();
  @override
  ConsumerState<_PaymentsTab> createState() => _PaymentsTabState();
}

class _PaymentsTabState extends ConsumerState<_PaymentsTab> {
  PaymentMethod? _method;
  String? _companyId;
  String? _companyName;
  DateTimeRange? _range;
  bool _voided = false;
  late Stream<List<PaymentListItem>> _stream = _load();

  Stream<List<PaymentListItem>> _load() => ref
      .read(billingRepositoryProvider)
      .watchPayments(
        PaymentFilter(
          companyId: _companyId,
          method: _method,
          from: _range == null ? null : Dates.iso(_range!.start),
          to: _range == null ? null : Dates.iso(_range!.end),
          includeVoided: _voided,
        ),
      );

  void _set(VoidCallback f) => setState(() {
    f();
    _stream = _load();
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 0),
          children: [
            FilterChip(
              avatar: const Icon(Icons.date_range, size: 18),
              label: Text(
                _range == null
                    ? 'Any date'
                    : '${Dates.displayDate(_range!.start)} – ${Dates.displayDate(_range!.end)}',
              ),
              selected: _range != null,
              onSelected: (_) async {
                if (_range != null) return _set(() => _range = null);
                final r = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (r != null) _set(() => _range = r);
              },
            ),
            const SizedBox(width: Gap.sm),
            FilterChip(
              avatar: const Icon(Icons.apartment, size: 18),
              label: Text(_companyName ?? 'All companies'),
              selected: _companyId != null,
              onSelected: (_) async {
                if (_companyId != null) {
                  return _set(() {
                    _companyId = null;
                    _companyName = null;
                  });
                }
                final id = await pickCompany(context);
                if (id == null) return;
                final c = await ref.read(companyRepositoryProvider).get(id);
                _set(() {
                  _companyId = id;
                  _companyName = c?.name;
                });
              },
            ),
            const SizedBox(width: Gap.sm),
            PopupMenuButton<PaymentMethod?>(
              onSelected: (m) => _set(() => _method = m),
              itemBuilder: (_) => [
                const PopupMenuItem(value: null, child: Text('All methods')),
                for (final m in PaymentMethod.values)
                  PopupMenuItem(value: m, child: Text(m.label)),
              ],
              child: Chip(
                avatar: const Icon(Icons.payments_outlined, size: 18),
                label: Text(_method?.label ?? 'All methods'),
              ),
            ),
            const SizedBox(width: Gap.sm),
            FilterChip(
              label: const Text('Show void'),
              selected: _voided,
              onSelected: (v) => _set(() => _voided = v),
            ),
          ],
        ),
      ),
      Expanded(
        child: StreamBody(
          stream: _stream,
          builder: (context, list) {
            if (list.isEmpty) {
              return const EmptyState(
                icon: Icons.payments_outlined,
                title: 'No payments found',
              );
            }
            final total = list
                .where((p) => p.payment.voidedAt == null)
                .fold(0, (s, p) => s + p.payment.amountPaise);
            return ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                ListHeader(
                  '${list.length} payment${list.length == 1 ? '' : 's'}',
                  trailing: Text('Total ${Money.format(total)}  '),
                ),
                for (final p in list) PaymentTile(p),
              ],
            );
          },
        ),
      ),
    ],
  );
}
