import 'package:flutter/material.dart';
import 'package:sonic_flutter/pages/account/account_update.page.dart';
import 'package:sonic_flutter/pages/account/search.page.dart';
import 'package:sonic_flutter/pages/auth/login.page.dart';
import 'package:sonic_flutter/pages/auth/register.page.dart';
import 'package:sonic_flutter/pages/chat_message/chat_details.page.dart';
import 'package:sonic_flutter/pages/chat_message/send_image.page.dart';
import 'package:sonic_flutter/pages/chat_message/singular_chat.page.dart';
import 'package:sonic_flutter/pages/friend_request/friend_request.page.dart';
import 'package:sonic_flutter/pages/home.page.dart';
import 'package:sonic_flutter/pages/splash.page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonic Chat Dev',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          )),
      debugShowCheckedModeBanner: false,
      routes: {
        Splash.route: (BuildContext context) => const Splash(),
        Register.route: (BuildContext context) => const Register(),
        Login.route: (BuildContext context) => const Login(),
        Home.route: (BuildContext context) => const Home(),
        AccountUpdate.route: (BuildContext context) => const AccountUpdate(),
        Search.route: (BuildContext context) => const Search(),
        FriendRequest.route: (BuildContext context) => const FriendRequest(),
        SingularChat.route: (BuildContext context) => const SingularChat(),
        SendImage.route: (BuildContext context) => const SendImage(),
        ChatDetails.route: (BuildContext context) =>
            const ChatDetails(),
      },
      initialRoute: Splash.route,
    );
  }
}
