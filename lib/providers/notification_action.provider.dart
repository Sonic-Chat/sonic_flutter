import 'package:flutter/material.dart';
import 'package:sonic_flutter/arguments/notification_action.argument.dart';
import 'package:sonic_flutter/constants/notification_payload.constant.dart';

class NotificationActionProvider with ChangeNotifier {
  NotificationAction action = NotificationAction(
    action: DEFAULT,
    chatId: '',
  );

  NotificationActionProvider({
    required this.action,
  }) {
    notifyListeners();
  }
}
