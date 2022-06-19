import 'package:flutter/material.dart';
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
    List<Message> chatMessages = List.from(chat.messages.reversed);

    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.1,
      ),
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        itemCount: chat.messages.length,
        itemBuilder: (context, index) {
          Message message = chatMessages[index];
          return MessageBubble(
            chat: chat,
            message: message,
          );
        },
      ),
    );
  }
}
