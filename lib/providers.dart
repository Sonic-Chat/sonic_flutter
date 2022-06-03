import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/services/auth.service.dart';

class Providers extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(
            apiUrl: apiUrl,
          ),
        ),
      ],
      child: child,
    );
  }
}
