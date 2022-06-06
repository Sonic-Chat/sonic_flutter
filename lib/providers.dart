import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:sonic_flutter/services/credentials.service.dart';
import 'package:sonic_flutter/services/user_account.service.dart';

class Providers extends StatefulWidget {
  final Widget child;
  final String rawApiUrl;
  final String apiUrl;

  const Providers({
    Key? key,
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
            authService: _authService,
          ),
        ),
      ],
      child: widget.child,
    );
  }
}
