import 'package:sonic_flutter/enum/general_error.enum.dart';

class GeneralException implements Exception {
  GeneralError message;

  GeneralException({
    required this.message,
  });

  @override
  String toString() {
    return message.toString();
  }
}
