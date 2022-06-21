import 'package:sonic_flutter/services/local_notifications.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

Future<LocalNotificationsService> localNotificationSetup() async {
  log.i("Initializing Local Notifications");

  // Creating a local notification service singleton.
  LocalNotificationsService localNotificationsService =
      LocalNotificationsService();

  // Initializing local notifications.
  await localNotificationsService.initializeLocalNotifications();
  log.i("Initialized Local Notifications");

  // Return the service object.
  return localNotificationsService;
}
