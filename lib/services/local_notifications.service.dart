import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sonic_flutter/constants/notification_payload.constant.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  static final LocalNotificationsService _localNotificationsService =
      LocalNotificationsService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory LocalNotificationsService() {
    return _localNotificationsService;
  }

  LocalNotificationsService._internal();

  Future<void> initializeLocalNotifications() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(
      tz.getLocation(
        "Asia/Colombo",
      ),
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: null,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: handleSelectNotification,
    );
  }

  Future<void> handleSelectNotification(String? payload) async {
    log.i("Notification Payload: $payload");
  }

  Future<NotificationAppLaunchDetails?> get notificationAppLaunchDetails =>
      flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  Future<void> instantNotification(Map<String, dynamic> fcmData) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      "id",
      "channel",
    );

    const iosNotificationDetails = IOSNotificationDetails();

    const platform = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    String payload = DEFAULT;

    switch (fcmData['type']) {
      case NEW_REQUEST:
        {
          payload = NEW_REQUEST;
          break;
        }
      case REQUEST_ACCEPTED:
        {
          payload = REQUEST_ACCEPTED;
          break;
        }
      case CREATE_MESSAGE:
        {
          payload = "${CREATE_MESSAGE}_${fcmData["chatId"]}";
          break;
        }
      default:
        {
          payload = DEFAULT;
          break;
        }
    }

    await flutterLocalNotificationsPlugin.show(
      0,
      fcmData["title"],
      fcmData["body"],
      platform,
      payload: payload,
    );
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
