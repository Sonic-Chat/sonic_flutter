import 'dart:io';

class SendImageArgument {
  final String chatId;
  final File file;

  SendImageArgument({
    required this.chatId,
    required this.file,
  });
}
