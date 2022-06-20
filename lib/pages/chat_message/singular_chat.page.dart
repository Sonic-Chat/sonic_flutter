import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/singular_chat.argument.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/enum/chat_field_type.enum.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/models/message/message.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/chat_message/chat_field.widget.dart';
import 'package:sonic_flutter/widgets/chat_message/message_list.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

class SingularChat extends StatefulWidget {
  static const route = "/singular-chat";

  const SingularChat({Key? key}) : super(key: key);

  @override
  State<SingularChat> createState() => _SingularChatState();
}

class _SingularChatState extends State<SingularChat> {
  late final ChatService _chatService;
  late final AccountProvider _accountProvider;
  Account? _friendAccount;
  String? _chatId;

  ChatFieldType _chatFieldType = ChatFieldType.Create;
  bool _messageSelected = false;
  Message? _message;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _chatService = Provider.of<ChatService>(
      context,
      listen: false,
    );
    _accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );
  }

  void _selectMessage(Message message) {
    setState(() {
      _messageSelected = true;
      _message = message;
    });
  }

  void _editMessage() {
    setState(() {
      _messageSelected = false;
      _chatFieldType = ChatFieldType.Update;
    });
  }

  void _cancelEditMessage() {
    setState(() {
      _messageSelected = false;
      _message = null;
      _chatFieldType = ChatFieldType.Create;
    });
  }

  void _unselectMessage() {
    setState(() {
      _messageSelected = false;
      _message = null;
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: !_loading
            ? [
                TextButton(
                  onPressed: _onDeleteMessage,
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
              ]
            : [
                const CircularProgressIndicator(),
              ],
      ),
    );
  }

  Future<void> _onDeleteMessage() async {
    setState(() {
      _loading = true;
    });

    try {
      await _chatService.deleteMessage(
        messageId: _message!.id,
      );

      Navigator.of(context).pop();

      _unselectMessage();
    } catch (error, stackTrace) {
      log.e(
        'Send Image Page Error',
        error,
        stackTrace,
      );
      displaySnackBar(
        'Something went wrong, please try again later',
        context,
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_chatId == null) {
      SingularChatArgument singularChatArgument =
          ModalRoute.of(context)!.settings.arguments as SingularChatArgument;

      _chatId = singularChatArgument.chatId;

      _chatService
          .markSeen(
            chatId: _chatId!,
          )
          .then((value) => log.i("Marked chat $_chatId seen."))
          .catchError((error, stackTrace) =>
              log.e("Singular Chat page Error", error, stackTrace));
    }

    return ValueListenableBuilder<Box<Chat>>(
      valueListenable: Hive.box<Chat>(CHAT_BOX).listenable(),
      builder: (BuildContext context, Box<Chat> box, Widget? widget) {
        Chat chat = _chatService.fetchChatFromOfflineDb(_chatId!)!;

        _friendAccount = chat.participants.firstWhere(
            (element) => element.id != _accountProvider.getAccount()!.id);

        bool seen = chat.seen
                .indexWhere((element) => element.id == _friendAccount!.id) >
            0;

        bool delivered = chat.delivered
                .indexWhere((element) => element.id == _friendAccount!.id) >
            0;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: null,
            automaticallyImplyLeading: false,
            title: _messageSelected
                ? const Text('Message Selected')
                : ListTile(
                    leading: ProfilePicture(
                      imageUrl: _friendAccount!.imageUrl,
                      size: MediaQuery.of(context).size.width * 0.1,
                    ),
                    title: Text(
                      _friendAccount!.fullName,
                    ),
                  ),
            toolbarHeight: MediaQuery.of(context).size.height * 0.1,
            actions: _messageSelected
                ? (_message!.type == MessageType.TEXT ||
                        _message!.type == MessageType.IMAGE_TEXT)
                    ? [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _editMessage,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: _confirmDelete,
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: _unselectMessage,
                        ),
                      ]
                    : [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: _confirmDelete,
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: _unselectMessage,
                        ),
                      ]
                : [],
          ),
          body: Container(
            margin: EdgeInsets.only(
              bottom: _message != null
                  ? MediaQuery.of(context).size.height * 0.2
                  : MediaQuery.of(context).size.height * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MessageList(
                  chat: chat,
                  onLongPress: _selectMessage,
                  selectedMessage: _message,
                ),
                if (seen)
                  Container(
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: const Text('Seen'),
                  ),
                if (delivered)
                  Container(
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: const Text('Delivered'),
                  ),
              ],
            ),
          ),
          bottomSheet: ChatField(
            chatId: chat.id,
            type: _chatFieldType,
            message: _message,
            cancelEditMessage: _cancelEditMessage,
          ),
        );
      },
    );
  }
}
