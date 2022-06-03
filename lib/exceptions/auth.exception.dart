import 'package:sonic_flutter/enum/auth_error.enum.dart';

class AuthException implements Exception {
  AuthError message;

  AuthException({
    required this.message,
  });

  @override
  String toString() {
    return message.toString();
  }
}
