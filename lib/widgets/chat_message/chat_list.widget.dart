import 'package:flutter/material.dart';
import 'package:sonic_flutter/animations/not_found.animation.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/widgets/chat_message/chat_display.widget.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats;

  const ChatList({
    Key? key,
    required this.chats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: chats.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                Chat chat = chats[index];

                return ChatDisplay(
                  chat: chat,
                );
              },
            )
          : const NotFound(
              message: 'No chats present.',
            ),
    );
  }
}
