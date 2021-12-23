import 'dart:convert';
import 'dart:io';

import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/screens/task_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init(BuildContext context, Function refresh) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notif_icon');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) =>
          selectNotification(payload, context, refresh),
    );

    tz.initializeTimeZones();
  }

  void selectNotification(
      String? payload, BuildContext context, Function refresh) async {
    if (payload != null) {
      Map<String, Object?> map = jsonDecode(payload);
      Task task = Task.fromMap(map);

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => TaskDetailScreen(
            task: task,
            refresh: refresh,
          ),
        ),
      );
      // Figure out a way to open the correct page from here

      cancelScheduledNotification(task);
    }
  }

  void scheduleNotification(Task task) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      packageInfo.appName,
      task.title,
      tz.TZDateTime.from(task.startTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          task.id!.toString(),
          packageInfo.appName,
        ),
      ),
      payload: jsonEncode(task.toMap(withId: true)),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void cancelScheduledNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }

  void handleApplicationWasLaunchedFromNotification(
    String? payload,
    BuildContext context,
    Function refresh,
  ) async {
    if (Platform.isIOS) {
      selectNotification(payload, context, refresh);
      return;
    }

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      selectNotification(
          notificationAppLaunchDetails.payload, context, refresh);
    }
  }
}
