import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sonic_flutter/dtos/chat_message/mark_delivered/mark_delivered.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:http/http.dart' as http;
import 'package:sonic_flutter/exceptions/chat.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

import '../enum/chat_error.enum.dart';

/*
 * Service Implementation of marking chat delivered.
 */
Future<void> httpMarkDelivered(
  MarkDeliveredDto markDeliveredDto,
  String apiUrl,
) async {
  try {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    // Get the logged in user details.
    User? firebaseUser = _firebaseAuth.currentUser;

    // Check if user is not null.
    if (firebaseUser == null) {
      // If there is no user logged is using firebase, throw an exception.
      throw AuthException(
        message: AuthError.UNAUTHENTICATED,
      );
    }
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await _firebaseAuth.currentUser!.getIdToken(true);

    // Preparing the URL for the server request.
    Uri url = Uri.parse("$apiUrl/api/v1/message/delivery");

    // Preparing the headers for the request.
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Preparing the body for the request
    String body = json.encode(markDeliveredDto.toJson());

    // Marking chat as delivered.
    http.Response response = await http
        .post(
          url,
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 10));

    // Handling Errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ChatException(
          messages: ChatError.values
              .where((error) =>
                  error.toString().substring("ChatError.".length) ==
                  body['message'])
              .toList());
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);

      log.e(body["message"]);

      throw GeneralException(
        message: GeneralError.SOMETHING_WENT_WRONG,
      );
    }
  } on SocketException {
    log.wtf("Dedicated Server Offline");
    throw GeneralException(
      message: GeneralError.OFFLINE,
    );
  } on TimeoutException {
    log.wtf("Dedicated Server Offline");
    throw GeneralException(
      message: GeneralError.OFFLINE,
    );
  } on FirebaseAuthException catch (error) {
    if (error.code == "network-request-failed") {
      log.wtf("Firebase Server Offline");
      throw GeneralException(
        message: GeneralError.OFFLINE,
      );
    } else {
      rethrow;
    }
  }
}
