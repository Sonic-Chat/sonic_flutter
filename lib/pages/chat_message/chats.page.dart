import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/enum/chat_error.enum.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/widgets/chat_message/chat_list.widget.dart';

class Chats extends StatefulWidget {
  static const route = "/chats";

  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late final ChatService _chatService;
  List<Chat> chats = [];

  @override
  void initState() {
    super.initState();

    _chatService = Provider.of(context, listen: false);

    _chatService.chatErrorsStreams.stream.listen((event) {
      for (var element in event) {
        String errorString = chatErrorStrings(element);
        displaySnackBar(errorString, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonic Chat 🚀'),
      ),
      body: ValueListenableBuilder<Box<Chat>>(
        valueListenable: Hive.box<Chat>(CHAT_BOX).listenable(),
        builder: (BuildContext context, Box<Chat> box, Widget? widget) {
          chats.clear();
          for (var key in box.keys) {
            chats.add(
              _chatService.fetchChatFromOfflineDb(key)!,
            );
          }

          return ChatList(
            chats: chats,
          );
        },
      ),
    );
  }
}
