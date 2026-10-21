import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/notification_plan.dart';

/// Local notifications for scheduled visits, reminders and overdue invoices.
/// Uses inexact scheduling (no exact-alarm permission); the OS decides the
/// precise delivery time and may suppress notifications in battery saver.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Route payload of a tapped notification (consumed by the router).
  final tapped = StreamController<String>.broadcast();
  String? launchPayload;

  static const _channel = AndroidNotificationDetails(
    'reminders',
    'Visits & reminders',
    channelDescription:
        'Upcoming service visits, follow-ups and overdue payments',
    importance: Importance.high,
    priority: Priority.high,
  );

  Future<void> init() async {
    if (_ready || kIsWeb) return;
    try {
      tzdata.initializeTimeZones();
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(info.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      }
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (r) {
          if (r.payload != null) tapped.add(r.payload!);
        },
      );
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        launchPayload = launch!.notificationResponse?.payload;
      }
      _ready = true;
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
    }
  }

  /// Asks the user for permission (Android 13+, iOS). Returns whether granted.
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return false;
  }

  /// Replaces all pending notifications with [plans].
  Future<void> apply(List<PlannedNotification> plans) async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
      for (final p in plans) {
        await _plugin.zonedSchedule(
          id: p.id,
          scheduledDate: tz.TZDateTime.from(p.at, tz.local),
          notificationDetails: const NotificationDetails(
            android: _channel,
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          title: p.title,
          body: p.body,
          payload: p.payload,
        );
      }
    } catch (e) {
      debugPrint('Could not schedule notifications: $e');
    }
  }

  Future<void> cancelAll() async {
    if (_ready) await _plugin.cancelAll();
  }
}
