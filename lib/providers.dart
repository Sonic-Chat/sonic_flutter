import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/notification_action.argument.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/providers/notification_action.provider.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/services/credentials.service.dart';
import 'package:sonic_flutter/services/friend_request.service.dart';
import 'package:sonic_flutter/services/token.service.dart';
import 'package:sonic_flutter/services/user_account.service.dart';

class Providers extends StatefulWidget {
  final NotificationAction action;
  final Widget child;
  final String rawApiUrl;
  final String apiUrl;

  const Providers({
    Key? key,
    required this.action,
    required this.child,
    required this.apiUrl,
    required this.rawApiUrl,
  }) : super(key: key);

  @override
  State<Providers> createState() => _ProvidersState();
}

class _ProvidersState extends State<Providers> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();

    _authService = AuthService(
      apiUrl: widget.apiUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountProvider>(
          create: (context) => AccountProvider(),
        ),
        ChangeNotifierProvider<NotificationActionProvider>(
          create: (context) => NotificationActionProvider(
            action: widget.action,
          ),
        ),
        Provider<AuthService>(
          create: (context) => _authService,
        ),
        Provider<UserAccountService>(
          create: (context) => UserAccountService(
            apiUrl: widget.apiUrl,
            authService: _authService,
          ),
        ),
        Provider<CredentialsService>(
          create: (context) => CredentialsService(
            apiUrl: widget.apiUrl,
            rawApiUrl: widget.rawApiUrl,
            authService: _authService,
          ),
        ),
        Provider<FriendRequestService>(
          create: (context) => FriendRequestService(
            apiUrl: widget.apiUrl,
            rawApiUrl: widget.rawApiUrl,
          ),
        ),
        Provider<ChatService>(
          create: (context) => ChatService(
            apiUrl: widget.apiUrl,
            rawApiUrl: widget.rawApiUrl,
            authService: _authService,
          ),
        ),
        Provider<TokenService>(
          create: (context) => TokenService(
            apiUrl: widget.apiUrl,
          ),
        ),
      ],
      child: widget.child,
    );
  }
}
