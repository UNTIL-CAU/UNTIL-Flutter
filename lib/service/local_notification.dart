import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

LocalNotification localNotification = LocalNotification();

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /**
   * initLocalNotificationPlugin()
   *
   * Notification 초기화
   */
  static initLocalNotificationPlugin() async {

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false);
    final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings(
      requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false);
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /**
   * requestPermission()
   *
   * 권한 요청
   */

  static void requestPermission() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /**
   * notificationNow(String title, String body, [String payload = ''])
   *
   * Notification 즉시 표시
   *
   * 호출 즉시 Notification 표시
   */

  static Future <void> notificationNow(String title, String body, [String payload = '']) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('notification', 'Notification',
        channelDescription: 'Notification',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails());
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  /**
   * setNotificationSchedule(int id, String title, String body, int year, int month, int day, int hour, int minute,
      [int second = 0, int millisecond = 0, int microsecond = 0, String payload = ''])
   *
   * Notification 스케줄 등록
   *
   * 특정 시점에 Notification 표시
   *
   * ex) LocalNotification.setNotificationSchedule(0,'test', 'test', 2022, 12, 5, 17, 55);
   */

  static Future <void> setNotificationSchedule(int id, String title, String body, int year, int month, int day, int hour, int minute,
      [int second = 0, int millisecond = 0, int microsecond = 0, String payload = '']) async {

    tz.TZDateTime zonedTime = tz.TZDateTime.local(year, month, day, hour, minute, second, millisecond, microsecond);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('notification', 'Notification',
    channelDescription: 'Notification',
    importance: Importance.max,
    priority: Priority.max,
    showWhen: true);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails());

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        zonedTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

  }

  /**
   * cancelNotificationSchedule(int id)
   *
   * 기존 등록한 특정 id Notification 스케줄 삭제
   *
   * ex) LocalNotification.cancelNotificationSchedule(0);
   */

  static Future <void> cancelNotificationSchedule(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /**
   * cancelAllNotificationSchedule()
   *
   * 기존 등록한 Notification 스케줄 전체 삭제
   */

  static Future <void> cancelAllNotificationSchedule() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }


}