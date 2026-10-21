import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/sync/sync_controller.dart';
import 'l10n/generated/app_localizations.dart';
import 'services/notification_service.dart';
import 'services/reminder_scheduler.dart';

class ServiceApp extends ConsumerStatefulWidget {
  const ServiceApp({
    super.key,
    required this.onboarded,
    this.enableBackgroundServices = true,
  });

  final bool onboarded;

  /// Off in widget tests (no platform plugins there).
  final bool enableBackgroundServices;

  @override
  ConsumerState<ServiceApp> createState() => _ServiceAppState();
}

class _ServiceAppState extends ConsumerState<ServiceApp> {
  late final GoRouter _router = buildRouter(
    onboarded: widget.onboarded,
    gate: ref.read(accountGateProvider),
  );
  AppLifecycleListener? _lifecycle;
  ReminderScheduler? _scheduler;
  StreamSubscription<String>? _taps;

  @override
  void initState() {
    super.initState();
    if (!widget.enableBackgroundServices) return;
    final notifications = NotificationService.instance;
    _scheduler = ReminderScheduler(ref.read(databaseProvider), notifications)
      ..enabled = ref.read(settingsProvider).remindersEnabled
      ..start();
    _taps = notifications.tapped.stream.listen(_open);
    final launch = notifications.launchPayload;
    if (launch != null && widget.onboarded) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _open(launch));
    }
    _lifecycle = AppLifecycleListener(
      onHide: () => ref.read(syncControllerProvider.notifier).onBackground(),
      onResume: () {
        ref.read(syncControllerProvider.notifier).onResume();
        _scheduler?.schedule();
      },
    );
    // Start automatic sync.
    ref.read(syncControllerProvider);
  }

  static const _tabs = {'/home', '/companies', '/visits', '/billing', '/more'};

  /// Opens a notification target: tabs are switched to, other pages pushed.
  void _open(String location) =>
      _tabs.contains(location) ? _router.go(location) : _router.push(location);

  @override
  void dispose() {
    _lifecycle?.dispose();
    _scheduler?.dispose();
    unawaited(_taps?.cancel());
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    ref.listen(settingsProvider.select((s) => s.remindersEnabled), (
      _,
      enabled,
    ) {
      _scheduler
        ?..enabled = enabled
        ..schedule();
    });
    return MaterialApp.router(
      title: 'Service Register',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (settings.themeMode) {
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.light,
      },
      routerConfig: _router,
      locale: const Locale('en', 'IN'),
      supportedLocales: const [Locale('en', 'IN'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Respect the user's font size but cap extreme values so layouts hold.
        final mq = MediaQuery.of(context);
        // On laptops (web) keep pages at a readable width instead of
        // stretching forms across the whole screen.
        const maxWidth = 1180.0;
        final wide = mq.size.width > maxWidth;
        final content = MediaQuery(
          data: mq.copyWith(
            size: wide ? Size(maxWidth, mq.size.height) : mq.size,
            textScaler: mq.textScaler.clamp(
              minScaleFactor: 1,
              maxScaleFactor: 1.4,
            ),
          ),
          child: child!,
        );
        if (!wide) return content;
        return ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxWidth),
              child: Material(elevation: 2, child: ClipRect(child: content)),
            ),
          ),
        );
      },
    );
  }
}
