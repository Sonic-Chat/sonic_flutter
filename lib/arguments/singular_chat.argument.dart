import 'package:sonic_flutter/enum/chat_type.enum.dart';

class SingularChatArgument {
  final String chatId;
  final ChatType type;

  SingularChatArgument({
    required this.chatId,
    required this.type,
  });
}
