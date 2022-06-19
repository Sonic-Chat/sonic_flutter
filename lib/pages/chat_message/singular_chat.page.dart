import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/singular_chat.argument.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/chat.service.dart';
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

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: null,
            automaticallyImplyLeading: false,
            title: ListTile(
              leading: ProfilePicture(
                imageUrl: _friendAccount!.imageUrl,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
              title: Text(
                _friendAccount!.fullName,
              ),
            ),
            toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          ),
          body: MessageList(
            chat: chat,
          ),
          bottomSheet: ChatField(
            chatId: chat.id,
          ),
        );
      },
    );
  }
}
