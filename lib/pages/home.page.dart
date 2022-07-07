import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/friend_request/fetch_friend_requests/fetch_friend_requests.dto.dart';
import 'package:sonic_flutter/dtos/notifications/save_token/save_token.dto.dart';
import 'package:sonic_flutter/pages/chat_message/chats.page.dart';
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
  late final TokenService _tokenService;
  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();

    // Get the FCM Messaging instance
    _messaging = FirebaseMessaging.instance;

    // Fetching service from the providers.
    _tokenService = Provider.of<TokenService>(
      context,
      listen: false,
    );

    // Check for internet connectivity.
    checkConnectivity().then((value) {
      if (value) {

        // Generate token and save it in the server.
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

    // Fetch friend requests from the server and save it to the database.
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
    return const Chats();
  }
}
