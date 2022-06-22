import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/notification_action.argument.dart';
import 'package:sonic_flutter/arguments/singular_chat.argument.dart';
import 'package:sonic_flutter/constants/notification_payload.constant.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/pages/auth/login.page.dart';
import 'package:sonic_flutter/pages/chat_message/singular_chat.page.dart';
import 'package:sonic_flutter/pages/friend_request/friend_request.page.dart';
import 'package:sonic_flutter/pages/home.page.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/providers/notification_action.provider.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class Splash extends StatefulWidget {
  const Splash({
    Key? key,
  }) : super(key: key);

  static const String route = "/splash";

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  StreamSubscription? _streamSubscription;

  late final AuthService _authService;
  late final ChatService _chatService;
  late final NotificationActionProvider _notificationActionProvider;

  @override
  void initState() {
    super.initState();

    _notificationActionProvider = Provider.of<NotificationActionProvider>(
      context,
      listen: false,
    );

    _authService = Provider.of<AuthService>(
      context,
      listen: false,
    );
    _chatService = Provider.of<ChatService>(
      context,
      listen: false,
    );

    setState(() {
      /*
         * Listen for logged in user using firebase auth changes.
         * If the user exists, fetch details from server and save
         * it in provider and route the user to home page.
         *
         * Otherwise, route them to Auth page.
         */
      _streamSubscription = FA.FirebaseAuth.instance.authStateChanges().listen(
            _handleFirebaseAuthEvents,
            onError: _handleFirebaseStreamError,
          );
    });
  }

  void _handleFirebaseAuthEvents(FA.User? user) {
    if (user != null) {
      log.i("Firebase Logged In User");
      _handleServerAuthStatus();
    } else {
      log.i("No Firebase User Found");
      Navigator.of(context).pushReplacementNamed(Login.route);
    }
  }

  void _handleServerAuthStatus() {
    _authService
        .getUser()
        .then(_handleServerAuthSuccess)
        .catchError(_handleServerAuthError);
  }

  _handleServerAuthError(error, stackTrace) {
    if (error.runtimeType == FA.FirebaseAuthException) {
      FA.FirebaseAuthException exception = error as FA.FirebaseAuthException;

      log.e(exception.code, exception.code, exception.stackTrace);
    } else {
      log.e(error.toString(), error, stackTrace);
      Navigator.of(context).pushReplacementNamed(Login.route);
    }
  }

  FutureOr<void> _handleServerAuthSuccess(Account account) {
    log.i("Server Logged In User");

    Provider.of<AccountProvider>(context, listen: false).saveAccount(account);

    log.i("Connecting to WebSocket Server");
    _chatService
        .connectServer()
        .then((_) => log.i("Connected to WebSocket Server"))
        .then((_) => _chatService.syncMessage())
        .then((_) => log.i("Synced all chats."))
        .catchError((error, stackTrace) =>
            log.e("Splash Page Error", error, stackTrace));

    NotificationAction notificationAction = _notificationActionProvider.action;

    switch (notificationAction.action) {
      case CREATE_MESSAGE:
        {
          Navigator.of(context).pushReplacementNamed(
            SingularChat.route,
            arguments: SingularChatArgument(
              chatId: notificationAction.chatId,
            ),
          );
          break;
        }
      case NEW_REQUEST:
        {
          Navigator.of(context).pushReplacementNamed(
            FriendRequest.route,
          );
          break;
        }
      case REQUEST_ACCEPTED:
        {
          Navigator.of(context).pushReplacementNamed(
            FriendRequest.route,
          );
          break;
        }
      case DEFAULT:
        {
          Navigator.of(context).pushReplacementNamed(Home.route);
          break;
        }
      default:
        {
          Navigator.of(context).pushReplacementNamed(Home.route);
          break;
        }
    }
  }

  _handleFirebaseStreamError(error, stackTrace) {
    log.e(error.toString(), error, stackTrace);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/img/app-icon.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
