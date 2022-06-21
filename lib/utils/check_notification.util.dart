import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sonic_flutter/services/local_notifications.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

/*
 * Method to check if the app was launched due to a local notification.
 * @param localNotificationsService Local Notification Service Singleton
 * @param action Default action to perform.
 */
Future<String> checkNotification(
  LocalNotificationsService localNotificationsService,
  String action,
) async {
  log.i("Checking Notification Triggered App Launch");

  // Getting app launch details.
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await localNotificationsService.notificationAppLaunchDetails;

  // Check if notification launched the app.
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    log.i("Notification Triggered App Launch: TRUE");

    // Set action as payload from the notification.
    action = notificationAppLaunchDetails!.payload!;
  } else {
    log.i("Notification Triggered App Launch: FALSE");
  }

  // Return action to perform.
  return action;
}
