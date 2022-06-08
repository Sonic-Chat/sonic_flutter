import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:sonic_flutter/dtos/credentials/delete_credentials/delete_credentials.dto.dart';
import 'package:sonic_flutter/dtos/credentials/search_credentials/search_credentials.dto.dart';
import 'package:sonic_flutter/dtos/credentials/update_credentials.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class CredentialsService {
  final String apiUrl;
  final String rawApiUrl;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;

  final AuthService authService;

  CredentialsService({
    required this.apiUrl,
    required this.rawApiUrl,
    required this.authService,
  });

  /*
   * Service Implementation for searching users.
   * @param searchCredentialsDto DTO Implementation for searching users.
   */
  Future<List<PublicCredentials>> searchCredentials(
    SearchCredentialsDto searchCredentialsDto,
  ) async {
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

      // Prepare URL and the auth header.
      Uri url = Uri.parse(
          "$apiUrl/api/v1/credentials/filter/:${searchCredentialsDto.search}");

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Search for users on the server
      http.Response response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      // Handling Errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw AuthException(
            message: AuthError.values.firstWhere((error) =>
                error.toString().substring("AuthError.".length) ==
                body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Getting list of public credentials.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<PublicCredentials> credentials = jsonResponse
          .map((credentialsJson) => PublicCredentials.fromJson(credentialsJson))
          .toList();

      // Return results.
      return credentials;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Throw offline error.
      throw GeneralException(
        message: GeneralError.OFFLINE,
      );
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Throw offline error.
      throw GeneralException(
        message: GeneralError.OFFLINE,
      );
    } on FA.FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        log.wtf("Firebase Server Offline");

        // Throw offline error.
        throw GeneralException(
          message: GeneralError.OFFLINE,
        );
      } else {
        rethrow;
      }
    }
  }

  /*
   * Service Implementation for credentials update.
   * @param updateCredentialsDto DTO Implementation for credentials update.
   */
  Future<void> updateCredentials(
    UpdateCredentialsDto updateCredentialsDto,
  ) async {
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

      // Preparing the URL for the server request.
      Uri url = Uri.parse("$apiUrl/api/v1/credentials");

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Preparing the body for the request
      String body = json.encode(updateCredentialsDto.toJson());

      // Updating account on the server.
      http.Response response = await http
          .put(
            url,
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      // Handling Errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw AuthException(
            message: AuthError.values.firstWhere((error) =>
                error.toString().substring("AuthError.".length) ==
                body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Re-authenticate with an updated token.
      String updatedToken = json.decode(response.body)['token'];
      await _firebaseAuth.signInWithCustomToken(updatedToken);

      // Saving updated account details to device.
      await authService.getUser();
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
   * Service Implementation account delete.
   */
  Future<void> deleteCredential(
    DeleteCredentialsDto deleteCredentialsDto,
  ) async {
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

      // Preparing the URL for the server request.
      Uri url = Uri.parse("$apiUrl/api/v1/account");

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Preparing body for the request.
      String body = json.encode(deleteCredentialsDto.toJson());

      // Updating account on the server.
      http.Response response = await http
          .delete(
            url,
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      // Handling Errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw AuthException(
            message: AuthError.values.firstWhere((error) =>
                error.toString().substring("AuthError.".length) ==
                body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Saving dummy account details to device.
      authService.syncAccountToOfflineDb(
        Account(
          id: '',
          imageUrl: '',
          fullName: '',
          status: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Logging out of the account.
      await authService.logOut();
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
