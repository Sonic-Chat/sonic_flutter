import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sonic_flutter/app.dart';
import 'package:sonic_flutter/arguments/notification_action.argument.dart';
import 'package:sonic_flutter/constants/notification_payload.constant.dart';
import 'package:sonic_flutter/dtos/chat_message/mark_delivered/mark_delivered.dto.dart';
import 'package:sonic_flutter/providers.dart';
import 'package:sonic_flutter/services/local_notifications.service.dart';
import 'package:sonic_flutter/utils/check_notification.util.dart';
import 'package:sonic_flutter/utils/firebase_startup.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/utils/mark_delivery.util.dart';
import 'package:sonic_flutter/utils/startup.util.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await firebaseStartup();

  LocalNotificationsService localNotificationsService =
  LocalNotificationsService();

  Map<String, dynamic> fcmData = message.data;

  localNotificationsService.instantNotification(
    fcmData,
  );

  if (fcmData['type'] == CREATE_MESSAGE) {
    try {
      await httpMarkDelivered(
        MarkDeliveredDto(
          chatId: fcmData['chatId'],
        ),
        "http://10.0.2.2:5000",
      );
    } catch (error, stackTrace) {
      log.e("FCM Error", error, stackTrace);
    }
  }
}

Future<void> main() async {
  await startup();

  String action = await checkNotification(
    LocalNotificationsService(),
    DEFAULT,
  );

  log.i("Setting Firebase Messaging");

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  log.i("Firebase Messaging Has Been Setup");

  runApp(
    Root(
      notificationAction: NotificationAction(
        chatId: action.startsWith(CREATE_MESSAGE)
            ? action.substring("${CREATE_MESSAGE}_".length)
            : "",
        action: action.startsWith(CREATE_MESSAGE) ? CREATE_MESSAGE : action,
      ),
    ),
  );
}

class Root extends StatelessWidget {
  final NotificationAction notificationAction;

  const Root({
    Key? key,
    required this.notificationAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Providers(
      child: const App(),
      apiUrl: "https://sonic-chat.herokuapp.com",
      rawApiUrl: "sonic-chat.herokuapp.com",
      action: notificationAction,
    );
  }
}
