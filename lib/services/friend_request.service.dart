import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/dtos/friend_request/create_friend_request/create_friend_request.dto.dart';
import 'package:sonic_flutter/dtos/friend_request/fetch_friend_request/fetch_friend_request.dto.dart';
import 'package:sonic_flutter/dtos/friend_request/fetch_friend_requests/fetch_friend_requests.dto.dart';
import 'package:sonic_flutter/dtos/friend_request/update_friend_request/update_friend_request.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/friends_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/friend_request.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class FriendRequestService {
  final String apiUrl;
  final String rawApiUrl;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;

  final Box<List<dynamic>> _friendRequestDb =
      Hive.box<List<dynamic>>(FRIEND_REQUESTS_BOX);

  FriendRequestService({
    required this.apiUrl,
    required this.rawApiUrl,
  });

  /*
   * Service Implementation for fetching friend requests.
   */
  Future<List<FriendRequest>> fetchFriendRequests(
    FetchFriendRequestsDto fetchFriendRequestDto,
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
      Uri url = fetchFriendRequestDto.status == null
          ? Uri.parse("$apiUrl/api/v1/friends")
          : Uri.http(
              rawApiUrl,
              'api/v1/friends',
              fetchFriendRequestDto.toJson(),
            );

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Fetch requests from the server
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

      // Decoding requests from JSON.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<FriendRequest> requests = jsonResponse
          .map((requestsJson) => FriendRequest.fromJson(requestsJson))
          .toList();

      // Saving requests to storage.
      _syncRequestsToOfflineDb(requests);

      // Returning requests.
      return requests;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch requests from Offline Storage.
      return fetchRequestsFromOfflineDb();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch requests from Offline Storage.
      return fetchRequestsFromOfflineDb();
    } on FA.FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        log.wtf("Firebase Server Offline");

        // Fetch requests from Offline Storage.
        return fetchRequestsFromOfflineDb();
      } else {
        rethrow;
      }
    }
  }

  /*
   * Service Implementation for fetching friend request for a particular account.
   */
  Future<FriendRequest> fetchFriendRequest(
    FetchFriendRequestDto fetchFriendRequestDto,
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
      Uri url = Uri.http(
        rawApiUrl,
        'api/v1/friends/account',
        fetchFriendRequestDto.toJson(),
      );

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Fetch requests from the server
      http.Response response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      // Handling Errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw FriendRequestException(
            message: FriendError.values.firstWhere((error) =>
                error.toString().substring("FriendError.".length) ==
                body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding requests from JSON.
      FriendRequest request =
          FriendRequest.fromJson(json.decode(response.body));

      // Returning requests.
      return request;
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
   * Service Implementation for creating friend requests.
   * @param createFriendRequestDto DTO Implementation for creating friend requests.
   */
  Future<FriendRequest> createFriendRequest(
    CreateFriendRequestDto createFriendRequestDto,
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
      Uri url = Uri.parse("$apiUrl/api/v1/friends");

      // Preparing body for the request.
      String body = json.encode(createFriendRequestDto.toJson());

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
        "Content-Type": "application/json",
      };

      // Posting new request from the server
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
        throw FriendRequestException(
            message: FriendError.values.firstWhere((error) =>
                error.toString().substring("FriendError.".length) ==
                body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding request from JSON.
      FriendRequest request =
          FriendRequest.fromJson(json.decode(response.body));

      // Refreshing offline DB.
      await fetchFriendRequests(
        FetchFriendRequestsDto(
          status: null,
        ),
      );

      // Returning request.
      return request;
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
   * Service Implementation for updating friend requests.
   * @param updateFriendRequestDto DTO Implementation for updating friend requests.
   */
  Future<FriendRequest> updateFriendRequest(
    UpdateFriendRequestDto updateFriendRequestDto,
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
      Uri url = Uri.parse("$apiUrl/api/v1/friends");

      // Preparing body for the request.
      String body = json.encode(updateFriendRequestDto.toJson());

      // Preparing the headers for the request.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
        "Content-Type": "application/json",
      };

      // Updating request from the server
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
        throw FriendRequestException(
            message: FriendError.values.firstWhere((error) =>
                error.toString().substring("FriendError.".length) ==
                body['message']));
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding request from JSON.
      FriendRequest request =
          FriendRequest.fromJson(json.decode(response.body));

      // Refreshing offline DB.
      await fetchFriendRequests(
        FetchFriendRequestsDto(
          status: null,
        ),
      );

      // Returning request.
      return request;
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
   * Service implementation for saving requests in offline storage.
   */
  void _syncRequestsToOfflineDb(List<FriendRequest> requests) {
    log.i("Saving requests to Hive DB");
    _friendRequestDb.put(LOGGED_IN_USER_REQUESTS, requests);
    log.i("Saved requests to Hive DB");
  }

  /*
   * Service implementation for fetching requests from offline storage.
   */
  List<FriendRequest> fetchRequestsFromOfflineDb() {
    log.i("Fetching requests from Hive DB");
    return _friendRequestDb
        .get(LOGGED_IN_USER_REQUESTS, defaultValue: [])!.cast<FriendRequest>();
  }
}
