import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:hive/hive.dart';
import 'package:sonic_flutter/constants/events.constant.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/dtos/chat_message/connect_server/connect_server.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/delete_message/delete_message.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/disconnect_server/disconnect_server.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/mark_seen/mark_seen.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/send_image/send_image.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/send_message/send_message.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/send_message_image/send_message_image.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/sync_message/sync_message.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/update_message/update_message.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/chat_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/chat.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/models/message/message.model.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatService {
  final String rawApiUrl;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;
  final Box<Chat> _chatDb = Hive.box<Chat>(CHAT_BOX);
  final StreamController<List<ChatError>> chatErrorsStreams =
      StreamController();

  late final IOWebSocketChannel ioWebSocketChannel;

  ChatService({
    required this.rawApiUrl,
  });

  /*
   * Service Implementation for connecting to the server.
   */
  Future<void> connectServer() async {
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

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Connecting to the WS Server.
      ioWebSocketChannel = IOWebSocketChannel.connect(
        Uri.parse(
          "ws://$rawApiUrl",
        ),
      );

      // Send connection status to the server.
      ioWebSocketChannel.sink.add(encodedBody);

      // Listen for events and act on it accordingly.
      ioWebSocketChannel.stream.listen((event) {
        handleWSEvents(json.decode(event));
      }, onError: (error, stackTrace) {
        log.e("Chat Service Error", error, stackTrace);
        chatErrorsStreams.add(
          [
            ChatError.ILLEGAL_ACTION,
          ],
        );
      });
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
  Future<void> syncMessage() async {
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

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Send sync chat event to the server.
      ioWebSocketChannel.sink.add(encodedBody);
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
  Future<void> sendTextMessage({
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

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Send event to the server.
      ioWebSocketChannel.sink.add(encodedBody);
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
  Future<void> sendImage({
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

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Send event to the server.
      ioWebSocketChannel.sink.add(encodedBody);
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
  Future<void> sendMessageImage({
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

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Send event to the server.
      ioWebSocketChannel.sink.add(encodedBody);
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
   * Service Implementation for updating messages.
   */
  Future<void> updateMessage({
    required String message,
    required String messageId,
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
      UpdateMessageDto updateMessageDto = UpdateMessageDto(
        authorization: firebaseAuthToken,
        message: message,
        messageId: messageId,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "update-message",
        "data": updateMessageDto.toJson(),
      };

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Send event to the server.
      ioWebSocketChannel.sink.add(encodedBody);
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
   * Service Implementation for deleting messages.
   */
  Future<void> deleteMessage({
    required String messageId,
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
      DeleteMessageDto deleteMessageDto = DeleteMessageDto(
        authorization: firebaseAuthToken,
        messageId: messageId,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "delete-message",
        "data": deleteMessageDto.toJson(),
      };

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Send event to the server.
      ioWebSocketChannel.sink.add(encodedBody);
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
   * Service Implementation for marking chats seen.
   */
  Future<void> markSeen({
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
      MarkSeenDto markSeenDto = MarkSeenDto(
        authorization: firebaseAuthToken,
        chatId: chatId,
      );

      // Preparing body for the request.
      Map<String, dynamic> body = {
        "event": "mark-seen",
        "data": markSeenDto.toJson(),
      };

      // String version of JSON format of the body.
      String encodedBody = json.encode(body);

      // Send event to the server.
      ioWebSocketChannel.sink.add(encodedBody);
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

  void handleWSEvents(Map<String, dynamic> data) {
    String eventType = data['type'];

    switch (eventType) {
      case CREATE_MESSAGE_EVENT:
        {
          handleNewMessage(data['details']);
          break;
        }
      case UPDATE_MESSAGE_EVENT:
        {
          handleUpdateMessage(data['details']);
          break;
        }
      case DELETE_MESSAGE_EVENT:
        {
          handleDeleteMessage(data['details']);
          break;
        }
      case DELIVERY_EVENT:
        {
          handleDelivery(data['details']);
          break;
        }
      case SEEN_EVENT:
        {
          handleSeen(data['details']);
          break;
        }
      case ERROR_EVENT:
        {
          List<String> rawErrors = data['errors'];
          List<ChatError> errors = rawErrors
              .map((rawError) => ChatError.values.firstWhere((error) =>
                  error.toString().substring("ChatError.".length) == rawError))
              .toList();

          chatErrorsStreams.add(errors);
          break;
        }
      default:
        {
          log.e(data);
        }
    }
  }

  /*
   * Service Implementation for reacting to sync chat event.
   */
  void handleSyncChat(Map<String, dynamic> details) {
    // Converting JSON to objects.
    List<dynamic> chatDtos = details['chats'];
    List<Chat> chats = chatDtos.map((e) => Chat.fromJson(e)).toList();

    for (var chat in chats) {
      // Save the new chat to the device.
      syncChatToOfflineDb(chat);
    }
  }

  /*
   * Service Implementation for reacting to create message event.
   */
  void handleNewMessage(Map<String, dynamic> details) {
    // Get the message model from the details.
    Message newMessage = Message.fromJson(details['message']);

    // Fetch the chat from the device.
    Chat? chat = fetchChatFromOfflineDb(details['id']);

    // Throw an exception if chat does not exist.
    if (chat == null) {
      throw ChatException(
        messages: [ChatError.CHAT_UID_ILLEGAL],
      );
    }

    // Add new message.
    chat.messages.add(newMessage);

    // Save the new chat to the device.
    syncChatToOfflineDb(chat);
  }

  /*
   * Service Implementation for reacting to update message event.
   */
  void handleUpdateMessage(Map<String, dynamic> details) {
    // Get the message model from the details.
    Message updatedMessage = Message.fromJson(details['message']);

    // Fetch the chat from the device.
    Chat? chat = fetchChatFromOfflineDb(details['chatId']);

    // Throw an exception if chat does not exist.
    if (chat == null) {
      throw ChatException(
        messages: [ChatError.CHAT_UID_ILLEGAL],
      );
    }

    // Find the index of the message.
    int index =
        chat.messages.indexWhere((element) => element.id == updatedMessage.id);

    // Throw an exception if the message does not exist.
    if (index < 0) {
      throw ChatException(
        messages: [ChatError.CHAT_UID_ILLEGAL],
      );
    }

    // Update message.
    chat.messages[index] = updatedMessage;

    // Save the updated chat to the device.
    syncChatToOfflineDb(chat);
  }

  /*
   * Service Implementation for reacting to delete message event.
   */
  void handleDeleteMessage(Map<String, dynamic> details) {
    // Get the message id from the details.
    String messageId = details['messageId'];

    // Fetch the chat from the device.
    Chat? chat = fetchChatFromOfflineDb(details['chatId']);

    // Throw an exception if chat does not exist.
    if (chat == null) {
      throw ChatException(
        messages: [ChatError.CHAT_UID_ILLEGAL],
      );
    }

    // Remove message from the chat.
    chat.messages.removeWhere(
      (element) => element.id == messageId,
    );

    // Save the updated chat to the device.
    syncChatToOfflineDb(chat);
  }

  /*
   * Service Implementation for reacting to delivery event.
   */
  void handleDelivery(Map<String, dynamic> details) {
    // Fetch the chat from the device.
    Chat? chat = fetchChatFromOfflineDb(details['chatId']);

    // Throw an exception if chat does not exist.
    if (chat == null) {
      throw ChatException(
        messages: [ChatError.CHAT_UID_ILLEGAL],
      );
    }

    // Marking all as delivered.
    chat.delivered.clear();

    for (var account in chat.participants) {
      chat.delivered.add(account);
    }

    // Save the updated chat to the device.
    syncChatToOfflineDb(chat);
  }

  /*
   * Service Implementation for reacting to seen event.
   */
  void handleSeen(Map<String, dynamic> details) {
    // Fetch the chat from the device.
    Chat? chat = fetchChatFromOfflineDb(details['chatId']);

    // Throw an exception if chat does not exist.
    if (chat == null) {
      throw ChatException(
        messages: [ChatError.CHAT_UID_ILLEGAL],
      );
    }

    // Marking all as seen.
    chat.seen.clear();

    for (var account in chat.participants) {
      chat.seen.add(account);
    }

    // Save the updated chat to the device.
    syncChatToOfflineDb(chat);
  }

  /*
   * Service implementation for saving chat in offline storage.
   */
  void syncChatToOfflineDb(Chat chat) {
    log.i("Saving chat ${chat.id} to Hive DB");
    _chatDb.put(chat.id, chat);
    log.i("Saved chat ${chat.id} to Hive DB");
  }

  /*
   * Service implementation for fetching chat from offline storage.
   */
  Chat? fetchChatFromOfflineDb(String id) {
    log.i("Fetching chat $id from Hive DB");
    return _chatDb.get(id);
  }
}
