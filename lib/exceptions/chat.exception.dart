import 'package:sonic_flutter/enum/chat_error.enum.dart';

class ChatException implements Exception {
  List<ChatError> messages;

  ChatException({
    required this.messages,
  });

  @override
  String toString() {
    return messages.toString();
  }
}
