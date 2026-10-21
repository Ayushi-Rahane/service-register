import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/billing/billing_screen.dart';
import '../../features/billing/invoice_detail_screen.dart';
import '../../features/billing/invoice_form_screen.dart';
import '../../features/billing/payment_detail_screen.dart';
import '../../features/billing/payment_form_screen.dart';
import '../../features/billing/payment_reminder_screen.dart';
import '../../features/companies/companies_screen.dart';
import '../../features/companies/company_detail_screen.dart';
import '../../features/companies/company_form_screen.dart';
import '../../features/documents/pdf_preview_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/inventory/inventory_screen.dart';
import '../../features/inventory/part_detail_screen.dart';
import '../../features/inventory/part_form_screen.dart';
import '../../features/machines/machine_detail_screen.dart';
import '../../features/machines/machine_form_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/reports/report_view_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/schedule/reminder_form_screen.dart';
import '../../features/schedule/schedule_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/more_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/templates_screen.dart';
import '../../features/shell/home_shell.dart';
import '../../features/sync/backup_sync_screen.dart';
import '../../features/sync/conflicts_screen.dart';
import '../../features/sync/sign_in_screen.dart';
import '../../features/visits/schedule_visit_screen.dart';
import '../../features/visits/visit_detail_screen.dart';
import '../../features/visits/visit_form_screen.dart';
import '../../features/visits/visits_screen.dart';
import '../../services/document_service.dart';
import '../../services/web_url.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

const _tabs = {'/home', '/companies', '/visits', '/billing', '/more'};

String _tabFor(String path) {
  if (path.startsWith('/company') || path.startsWith('/machine')) {
    return '/companies';
  }
  if (path.startsWith('/visit')) return '/visits';
  if (path.startsWith('/invoice') || path.startsWith('/payment')) {
    return '/billing';
  }
  if (path == '/' || path.startsWith('/search')) return '/home';
  return '/more';
}

GoRouter buildRouter({required bool onboarded}) {
  // Website: opening or refreshing the browser on an inner page has no page
  // history behind it (so no back button). Start from its tab instead.
  final start = currentWebRoute();
  final String initial;
  if (!onboarded) {
    initial = '/onboarding';
  } else if (start != null && !_tabs.contains(start)) {
    initial = _tabFor(start);
  } else {
    initial = start ?? '/home';
  }

  String? q(GoRouterState s, String k) {
    final v = s.uri.queryParameters[k];
    return (v == null || v.isEmpty) ? null : v;
  }

  GoRoute page(String path, Widget Function(GoRouterState s) build) => GoRoute(
    path: path,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, s) => build(s),
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initial,
    overridePlatformDefaultLocation: start != null,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/companies',
                builder: (_, _) => const CompaniesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/visits', builder: (_, _) => const VisitsScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/billing',
                builder: (_, _) => const BillingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/more', builder: (_, _) => const MoreScreen()),
            ],
          ),
        ],
      ),
      page('/onboarding', (_) => const OnboardingScreen()),
      page('/company/new', (_) => const CompanyFormScreen()),
      page(
        '/company/:id',
        (s) => CompanyDetailScreen(id: s.pathParameters['id']!),
      ),
      page(
        '/company/:id/edit',
        (s) => CompanyFormScreen(id: s.pathParameters['id']),
      ),
      page(
        '/machine/new',
        (s) => MachineFormScreen(companyId: q(s, 'companyId')),
      ),
      page(
        '/machine/:id',
        (s) => MachineDetailScreen(id: s.pathParameters['id']!),
      ),
      page(
        '/machine/:id/edit',
        (s) => MachineFormScreen(id: s.pathParameters['id']),
      ),
      page(
        '/visit/new',
        (s) => VisitFormScreen(
          companyId: q(s, 'companyId'),
          machineId: q(s, 'machineId'),
        ),
      ),
      page(
        '/visit/schedule',
        (s) => ScheduleVisitScreen(
          companyId: q(s, 'companyId'),
          machineId: q(s, 'machineId'),
          date: q(s, 'date'),
        ),
      ),
      page(
        '/visit/:id',
        (s) => VisitDetailScreen(
          id: s.pathParameters['id']!,
          justCompleted: q(s, 'completed') == '1',
        ),
      ),
      page(
        '/visit/:id/edit',
        (s) => VisitFormScreen(id: s.pathParameters['id']),
      ),
      page(
        '/invoice/new',
        (s) => InvoiceFormScreen(
          companyId: q(s, 'companyId'),
          visitIds: q(s, 'visitIds')?.split(',') ?? const [],
        ),
      ),
      page(
        '/invoice/:id',
        (s) => InvoiceDetailScreen(id: s.pathParameters['id']!),
      ),
      page(
        '/invoice/:id/edit',
        (s) => InvoiceFormScreen(id: s.pathParameters['id']),
      ),
      page(
        '/invoice/:id/reminder',
        (s) => PaymentReminderScreen(invoiceId: s.pathParameters['id']!),
      ),
      page(
        '/payment/new',
        (s) => PaymentFormScreen(
          companyId: q(s, 'companyId'),
          invoiceId: q(s, 'invoiceId'),
        ),
      ),
      page(
        '/payment/:id',
        (s) => PaymentDetailScreen(id: s.pathParameters['id']!),
      ),
      page('/inventory', (_) => const InventoryScreen()),
      page('/part/new', (_) => const PartFormScreen()),
      page('/part/:id', (s) => PartDetailScreen(id: s.pathParameters['id']!)),
      page('/part/:id/edit', (s) => PartFormScreen(id: s.pathParameters['id'])),
      page('/schedule', (_) => const ScheduleScreen()),
      page(
        '/reminder/new',
        (s) => ReminderFormScreen(
          companyId: q(s, 'companyId'),
          invoiceId: q(s, 'invoiceId'),
          kind: q(s, 'kind'),
        ),
      ),
      page(
        '/reminder/:id/edit',
        (s) => ReminderFormScreen(id: s.pathParameters['id']),
      ),
      page('/reports', (_) => const ReportsScreen()),
      page(
        '/reports/:type',
        (s) => ReportViewScreen(
          typeName: s.pathParameters['type']!,
          companyId: q(s, 'companyId'),
          machineId: q(s, 'machineId'),
        ),
      ),
      page('/search', (_) => const SearchScreen()),
      page('/settings', (_) => const SettingsScreen()),
      page('/settings/templates', (_) => const TemplatesScreen()),
      page('/backup', (_) => const BackupSyncScreen()),
      page('/backup/conflicts', (_) => const ConflictsScreen()),
      page('/sign-in', (_) => const SignInScreen()),
      page('/pdf', (s) => PdfPreviewScreen(doc: s.extra! as GeneratedDoc)),
    ],
    // Notification payloads use short paths; map them to routes.
    redirect: (context, state) {
      final path = state.uri.path;
      if (path.startsWith('/visits/')) return '/visit/${path.substring(8)}';
      if (path.startsWith('/invoices/')) {
        return '/invoice/${path.substring(10)}';
      }
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
}
