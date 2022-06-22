import 'package:flutter/material.dart';
import 'package:sonic_flutter/enum/chat_field_type.enum.dart';
import 'package:sonic_flutter/models/message/message.model.dart';

class SingularChatProvider with ChangeNotifier {
  String chatId;
  ChatFieldType chatFieldType = ChatFieldType.Create;
  bool messageSelected = false;
  Message? message;

  SingularChatProvider({
    required this.chatId,
  });

  void selectMessage(Message message) {
    messageSelected = true;
    this.message = message;

    notifyListeners();
  }

  void editMessage() {
    messageSelected = false;
    chatFieldType = ChatFieldType.Update;

    notifyListeners();
  }

  void cancelEditMessage() {
    messageSelected = false;
    message = null;
    chatFieldType = ChatFieldType.Create;

    notifyListeners();
  }

  void unselectMessage() {
    messageSelected = false;
    message = null;

    notifyListeners();
  }
}
