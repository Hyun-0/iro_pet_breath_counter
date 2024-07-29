import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._();

  static Future sendLocalNotificationDateTime({
    required int idx,
    required DateTime date,
    required String title,
    required String content,
    required bool isWeek,
  }) async {
    bool? result;
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isAndroid) {
      result = true;
    } else {
      result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    var android = AndroidNotificationDetails(
      'iro_pet_breath_counter_id',
      title,
      channelDescription: content,
      importance: Importance.max,
      priority: Priority.max,
      color: const Color.fromARGB(255, 255, 0, 0),
    );

    var ios = const DarwinNotificationDetails();
    var detail = NotificationDetails(
      android: android,
      iOS: ios,
    );
    if (result == true) {
      int duration = (isWeek) ? 7 : 1;
      DateTimeComponents dateTimeComponents = (isWeek)
          ? DateTimeComponents.dayOfWeekAndTime
          : DateTimeComponents.time;

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannelGroup('iro_pet_breath_counter_id');
      clear();
      await flutterLocalNotificationsPlugin.zonedSchedule(
        idx,
        title,
        content,
        _setNotiTime(date: date).add(Duration(
          days: duration,
        )),
        detail,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '',
        matchDateTimeComponents: dateTimeComponents,
      );
    }
  }

  static tz.TZDateTime _setNotiTime({
    required DateTime date,
  }) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    var scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
    );
    return scheduledDate;
  }

  static clear() {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
