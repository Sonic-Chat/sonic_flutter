import 'package:sonic_flutter/enum/friends_error.enum.dart';

class FriendRequestException implements Exception {
  FriendError message;

  FriendRequestException({
    required this.message,
  });

  @override
  String toString() {
    return message.toString();
  }
}
