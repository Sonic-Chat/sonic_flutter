import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:sonic_flutter/dtos/chat_message/connect_server/connect_server.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/send_image/send_image.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/send_message/send_message.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/send_message_image/send_message_image.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/sync_message/sync_message.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class ChatService {
  final String rawApiUrl;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;

  ChatService({
    required this.rawApiUrl,
  });

  /*
   * Service Implementation for connecting to the server.
   */
  Future<String> connectServer() async {
    try {
      // Get the logged in user details.
      FA.User? firebaseUser = _firebaseAuth.currentUser;

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

      // Preparing DTO for the request.
      ConnectServerDto connectServerDto = ConnectServerDto(
        authorization: firebaseAuthToken,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "connect",
        "data": connectServerDto.toJson(),
      };

      // Returning JSON format of the body.
      return json.encode(body);
    } on FA.FirebaseAuthException catch (error) {
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

  /*
   * Service Implementation for syncing messages.
   */
  Future<String> syncMessage() async {
    try {
      // Get the logged in user details.
      FA.User? firebaseUser = _firebaseAuth.currentUser;

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

      // Preparing DTO for the request.
      SyncMessageDto syncMessageDto = SyncMessageDto(
        authorization: firebaseAuthToken,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "sync-message",
        "data": syncMessageDto.toJson(),
      };

      // Returning JSON format of the body.
      return json.encode(body);
    } on FA.FirebaseAuthException catch (error) {
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

  /*
   * Service Implementation for sending text message.
   */
  Future<String> sendTextMessage({
    required String message,
    required String chatId,
  }) async {
    try {
      // Get the logged in user details.
      FA.User? firebaseUser = _firebaseAuth.currentUser;

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

      // Preparing DTO for the request.
      SendMessageDto sendMessageDto = SendMessageDto(
        authorization: firebaseAuthToken,
        message: message,
        chatId: chatId,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "create-message",
        "data": sendMessageDto.toJson(),
      };

      // Returning JSON format of the body.
      return json.encode(body);
    } on FA.FirebaseAuthException catch (error) {
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

  /*
   * Service Implementation for sending image.
   */
  Future<String> sendImage({
    required String firebaseId,
    required String imageUrl,
    required String chatId,
  }) async {
    try {
      // Get the logged in user details.
      FA.User? firebaseUser = _firebaseAuth.currentUser;

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

      // Preparing DTO for the request.
      SendImageDto sendImageDto = SendImageDto(
        authorization: firebaseAuthToken,
        firebaseId: firebaseId,
        imageUrl: imageUrl,
        chatId: chatId,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "create-message",
        "data": sendImageDto.toJson(),
      };

      // Returning JSON format of the body.
      return json.encode(body);
    } on FA.FirebaseAuthException catch (error) {
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

  /*
   * Service Implementation for sending image message.
   */
  Future<String> sendMessageImage({
    required String message,
    required String firebaseId,
    required String imageUrl,
    required String chatId,
  }) async {
    try {
      // Get the logged in user details.
      FA.User? firebaseUser = _firebaseAuth.currentUser;

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

      // Preparing DTO for the request.
      SendMessageImageDto sendMessageImageDto = SendMessageImageDto(
        authorization: firebaseAuthToken,
        message: message,
        chatId: chatId,
        firebaseId: firebaseId,
        imageUrl: imageUrl,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "create-message",
        "data": sendMessageImageDto.toJson(),
      };

      // Returning JSON format of the body.
      return json.encode(body);
    } on FA.FirebaseAuthException catch (error) {
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
}
