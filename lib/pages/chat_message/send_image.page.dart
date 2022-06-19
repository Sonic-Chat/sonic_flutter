import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sonic_flutter/arguments/send_image.argument.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/widgets/chat_message/chat_field.widget.dart';

class SendImage extends StatefulWidget {
  static const route = "/send-image";

  const SendImage({Key? key}) : super(key: key);

  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  SendImageArgument? _sendImageArgument;

  @override
  Widget build(BuildContext context) {
    _sendImageArgument ??=
        ModalRoute.of(context)!.settings.arguments as SendImageArgument;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Image',
        ),
      ),
      bottomSheet: ChatField(
        chatId: _sendImageArgument!.chatId,
        messageType: MessageType.IMAGE,
        imageFile: _sendImageArgument!.file,
      ),
      body: Center(
        child: Image.file(
          _sendImageArgument!.file,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
