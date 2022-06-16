import 'package:sonic_flutter/enum/chat_error.enum.dart';

class ChatException implements Exception {
  ChatError message;

  ChatException({
    required this.message,
  });

  @override
  String toString() {
    return message.toString();
  }
}
