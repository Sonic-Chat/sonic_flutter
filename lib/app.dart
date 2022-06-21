import 'package:flutter/material.dart';
import 'package:sonic_flutter/arguments/notification_action.argument.dart';
import 'package:sonic_flutter/pages/account/account_update.page.dart';
import 'package:sonic_flutter/pages/account/search.page.dart';
import 'package:sonic_flutter/pages/auth/login.page.dart';
import 'package:sonic_flutter/pages/auth/register.page.dart';
import 'package:sonic_flutter/pages/chat_message/chats.page.dart';
import 'package:sonic_flutter/pages/chat_message/send_image.page.dart';
import 'package:sonic_flutter/pages/chat_message/singular_chat.page.dart';
import 'package:sonic_flutter/pages/friend_request/friend_request.page.dart';
import 'package:sonic_flutter/pages/home.page.dart';
import 'package:sonic_flutter/pages/splash.page.dart';

class App extends StatelessWidget {
  final NotificationAction action;

  const App({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonic Chat Dev',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        Splash.route: (BuildContext context) => Splash(
              action: action,
            ),
        Register.route: (BuildContext context) => const Register(),
        Login.route: (BuildContext context) => const Login(),
        Home.route: (BuildContext context) => const Home(),
        AccountUpdate.route: (BuildContext context) => const AccountUpdate(),
        Search.route: (BuildContext context) => const Search(),
        FriendRequest.route: (BuildContext context) => const FriendRequest(),
        Chats.route: (BuildContext context) => const Chats(),
        SingularChat.route: (BuildContext context) => const SingularChat(),
        SendImage.route: (BuildContext context) => const SendImage(),
      },
      initialRoute: Splash.route,
    );
  }
}
