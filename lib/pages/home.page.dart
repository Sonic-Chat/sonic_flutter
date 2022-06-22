import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/notification_action.argument.dart';
import 'package:sonic_flutter/arguments/singular_chat.argument.dart';
import 'package:sonic_flutter/constants/notification_payload.constant.dart';
import 'package:sonic_flutter/dtos/friend_request/fetch_friend_requests/fetch_friend_requests.dto.dart';
import 'package:sonic_flutter/dtos/notifications/save_token/save_token.dto.dart';
import 'package:sonic_flutter/pages/account/account_update.page.dart';
import 'package:sonic_flutter/pages/account/search.page.dart';
import 'package:sonic_flutter/pages/chat_message/chats.page.dart';
import 'package:sonic_flutter/pages/chat_message/singular_chat.page.dart';
import 'package:sonic_flutter/pages/friend_request/friend_request.page.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/services/friend_request.service.dart';
import 'package:sonic_flutter/services/token.service.dart';
import 'package:sonic_flutter/utils/check_connectivity.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String route = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ChatService _chatService;
  late final TokenService _tokenService;
  late final FirebaseMessaging _messaging;

  NotificationAction? notificationAction;

  @override
  void initState() {
    super.initState();

    _messaging = FirebaseMessaging.instance;

    _chatService = Provider.of<ChatService>(
      context,
      listen: false,
    );

    _tokenService = Provider.of<TokenService>(
      context,
      listen: false,
    );

    checkConnectivity().then((value) {
      if (value) {
        _messaging
            .getToken()
            .then(
              (token) => _tokenService.saveToken(
                SaveTokenDto(token: token!),
              ),
            )
            .then(
              (_) => FirebaseMessaging.instance.onTokenRefresh.listen(
                (token) => _tokenService.saveToken(
                  SaveTokenDto(
                    token: token,
                  ),
                ),
              ),
            )
            .then(
              (value) => log.i(
                "FCM Token Generated and Saved",
              ),
            )
            .catchError(
              (error, stackTrace) => log.e(
                "Home Page Error",
                error,
                stackTrace,
              ),
            );
      } else {
        log.i(
            "Device offline, suspending FCM Token Generation and Topic Subscription");
      }
    }).catchError((error, stackTrace) {
      log.e("Home Page Error", error, stackTrace);
    });

    Provider.of<FriendRequestService>(
      context,
      listen: false,
    )
        .fetchFriendRequests(
          FetchFriendRequestsDto(
            status: null,
          ),
        )
        .then((value) => log.i('Friend Requests Fetched'))
        .catchError(
          (error, stackTrace) => log.e(
            'Home Page Error',
            error,
            stackTrace,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    notificationAction ??=
        ModalRoute.of(context)!.settings.arguments as NotificationAction;

    if (notificationAction!.action.startsWith(CREATE_MESSAGE)) {
      Navigator.of(context).pushNamed(
        SingularChat.route,
        arguments: SingularChatArgument(
          chatId: notificationAction!.chatId,
        ),
      );
    } else if (notificationAction!.action == NEW_REQUEST) {
      Navigator.of(context).pushNamed(
        FriendRequest.route,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sonic Chat"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hello from Home Page',
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AccountUpdate.route,
                );
              },
              child: const Text('Update Account'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Search.route,
                );
              },
              child: const Text('Search'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  FriendRequest.route,
                );
              },
              child: const Text('Friends'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Chats.route,
                );
              },
              child: const Text('Chats'),
            ),
          ],
        ),
      ),
    );
  }
}
