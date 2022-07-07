import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/enum/home_popup.enum.dart';
import 'package:sonic_flutter/enum/chat_error.enum.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/pages/account/account_update.page.dart';
import 'package:sonic_flutter/pages/account/search.page.dart';
import 'package:sonic_flutter/pages/auth/login.page.dart';
import 'package:sonic_flutter/pages/chat_message/select_participants.page.dart';
import 'package:sonic_flutter/pages/friend_request/friend_request.page.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/widgets/chat_message/chat_list.widget.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late final ChatService _chatService;
  late final AuthService _authService;
  List<Chat> chats = [];

  @override
  void initState() {
    super.initState();

    // Fetching service from the providers.
    _chatService = Provider.of(context, listen: false);
    _authService = Provider.of(context, listen: false);

    // Listen for chat error streams.
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
        title: const Text(
          'Sonic Chat 🚀',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Search.route,
              );
            },
          ),
          PopupMenuButton<HomePopup>(
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text(
                  "Create Group Chat",
                ),
                value: HomePopup.createGroupChat,
              ),
              const PopupMenuItem(
                child: Text(
                  "Settings",
                ),
                value: HomePopup.settings,
              ),
              const PopupMenuItem(
                child: Text("Log Out"),
                value: HomePopup.logOut,
              ),
            ],
            onSelected: (HomePopup? selected) async {
              if (selected == HomePopup.settings) {
                Navigator.of(context).pushNamed(
                  AccountUpdate.route,
                );
              }
              if (selected == HomePopup.logOut) {
                await _authService.logOut();
                Navigator.of(context).pushReplacementNamed(
                  Login.route,
                );
              }
              if (selected == HomePopup.createGroupChat) {
                Navigator.of(context).pushNamed(
                  SelectParticipants.route,
                );
              }
            },
          )
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            FriendRequest.route,
          );
        },
        child: const Icon(
          Icons.message,
        ),
      ),
    );
  }
}
