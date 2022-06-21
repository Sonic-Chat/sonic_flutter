import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/notification_action.argument.dart';
import 'package:sonic_flutter/constants/notification_payload.constant.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/pages/auth/login.page.dart';
import 'package:sonic_flutter/pages/home.page.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:sonic_flutter/utils/logger.util.dart';

class Splash extends StatefulWidget {
  final NotificationAction action;

  const Splash({
    Key? key,
    required this.action,
  }) : super(key: key);

  static const String route = "/splash";

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  StreamSubscription? _streamSubscription;

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();

    _authService = Provider.of<AuthService>(
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

    log.i(widget.action);

    Navigator.of(context).pushReplacementNamed(Home.route);
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
