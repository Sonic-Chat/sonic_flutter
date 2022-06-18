import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/models/message/message.model.dart';
import 'package:sonic_flutter/widgets/chat_message/message_bubble.widget.dart';

class MessageList extends StatelessWidget {
  final Chat chat;

  const MessageList({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.jumpTo(controller.position.maxScrollExtent);
    });

    return Expanded(
      child: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: chat.messages.length,
        itemBuilder: (context, index) {
          Message message = chat.messages[index];
          return MessageBubble(
            chat: chat,
            message: message,
          );
        },
      ),
    );
  }
}
