import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sonic_flutter/dtos/auth/login_account/login_account.dto.dart';
import 'package:sonic_flutter/dtos/auth/register_account/register_account.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;

class AuthService {
  final String apiUrl;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;

  AuthService({
    required this.apiUrl,
  });

  /*
   * Service Implementation for fetching logged in account.
   */
  Future<Account> getUser() async {
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
      Uri url = Uri.parse("$apiUrl/api/v1/auth/identity");

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Fetch user details from the server
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
            message: AuthError.values
                .firstWhere((error) => error.toString() == body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding account from JSON.
      Account account = Account.fromJson(json.decode(response.body));

      // Returning account.
      return account;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      throw GeneralException(
        message: GeneralError.SOMETHING_WENT_WRONG,
      );
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      throw GeneralException(
        message: GeneralError.SOMETHING_WENT_WRONG,
      );
    } on FA.FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        log.wtf("Firebase Server Offline");
        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      } else {
        rethrow;
      }
    }
  }

  /*
   * Service Implementation account registration.
   * @param registerAccountDto DTO Implementation for account registration.
   */
  Future<Account> registerAccount(
    RegisterAccountDto registerAccountDto,
  ) async {
    try {
      // Preparing the URL for the server request.
      Uri url = Uri.parse("$apiUrl/api/v1/auth/credential");

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      // Preparing the body for the request
      String body = json.encode(registerAccountDto.toJson());

      // Registering account on the server.
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
        throw AuthException(
            message: AuthError.values
                .firstWhere((error) => error.toString() == body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding account from JSON.
      Account account = Account.fromJson(json.decode(response.body));

      // Returning account.
      return account;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      throw GeneralException(
        message: GeneralError.SOMETHING_WENT_WRONG,
      );
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      throw GeneralException(
        message: GeneralError.SOMETHING_WENT_WRONG,
      );
    } on FA.FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        log.wtf("Firebase Server Offline");
        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      } else {
        rethrow;
      }
    }
  }

  /*
   * Service Implementation account login.
   * @param registerAccountDto DTO Implementation for account login.
   */
  Future<void> loginAccount(
    LoginAccountDto loginAccountDto,
  ) async {
    try {
      // Preparing the URL for the server request.
      Uri url = Uri.parse("$apiUrl/api/v1/auth/token");

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      // Preparing the body for the request
      String body = json.encode(loginAccountDto.toJson());

      // Fetching token from the server.
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
        throw AuthException(
            message: AuthError.values
                .firstWhere((error) => error.toString() == body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Getting token from response
      String token = json.decode(response.body)['token'];

      await _firebaseAuth.signInWithCustomToken(token);
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      throw GeneralException(
        message: GeneralError.SOMETHING_WENT_WRONG,
      );
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      throw GeneralException(
        message: GeneralError.SOMETHING_WENT_WRONG,
      );
    } on FA.FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        log.wtf("Firebase Server Offline");
        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      } else {
        rethrow;
      }
    }
  }
}
