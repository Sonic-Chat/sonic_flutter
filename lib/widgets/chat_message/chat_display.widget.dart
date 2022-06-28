import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/singular_chat.argument.dart';
import 'package:sonic_flutter/enum/chat_type.enum.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/models/message/message.model.dart';
import 'package:sonic_flutter/pages/chat_message/singular_chat.page.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';
import 'package:intl/intl.dart';

class ChatDisplay extends StatefulWidget {
  final Chat chat;

  const ChatDisplay({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<ChatDisplay> createState() => _ChatDisplayState();
}

class _ChatDisplayState extends State<ChatDisplay> {
  late final AccountProvider _accountProvider;
  late final Account _friendAccount;

  bool _isSeen = false;
  String body = '';
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();

    _accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );

    _friendAccount = widget.chat.participants.firstWhere(
        (element) => element.id != _accountProvider.getAccount()!.id);
  }

  @override
  Widget build(BuildContext context) {
    _isSeen = widget.chat.seen
        .where((element) => element.id == _accountProvider.getAccount()!.id)
        .isNotEmpty;

    if (widget.chat.messages.isNotEmpty) {
      Message lastMessage = widget.chat.messages.last;
      Account account = lastMessage.sentBy;

      dateTime = lastMessage.createdAt;

      switch (lastMessage.type) {
        case MessageType.IMAGE:
          {
            body = widget.chat.type == ChatType.GROUP
                ? '${account.fullName.split(" ")[0]}: 📸 Image'
                : '📸 Image';
            break;
          }
        case MessageType.IMAGE_TEXT:
          {
            body = widget.chat.type == ChatType.GROUP
                ? '${account.fullName.split(" ")[0]}: 📸 ${lastMessage.message!}'
                : '📸 ${lastMessage.message!}';
            break;
          }
        case MessageType.TEXT:
          {
            body = widget.chat.type == ChatType.GROUP
                ? '${account.fullName.split(" ")[0]}: ${lastMessage.message!}'
                : lastMessage.message!;
            break;
          }
        default:
          {
            body = 'New message';
            break;
          }
      }
    } else {
      body = '';
    }

    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          SingularChat.route,
          arguments: SingularChatArgument(
            chatId: widget.chat.id,
            type: widget.chat.type,
          ),
        );
      },
      leading: ProfilePicture(
        imageUrl: widget.chat.type == ChatType.SINGLE
            ? _friendAccount.imageUrl
            : widget.chat.imageUrl,
        size: MediaQuery.of(context).size.width * 0.1,
      ),
      title: Text(
        widget.chat.type == ChatType.SINGLE
            ? _friendAccount.fullName
            : widget.chat.name,
        style: TextStyle(
          fontWeight: _isSeen ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        body,
        style: TextStyle(
          fontWeight: _isSeen ? FontWeight.normal : FontWeight.bold,
          color: _isSeen ? Colors.grey : Colors.black,
        ),
      ),
      trailing: Text(
        dateTime != null
            ? DateFormat.yMd().add_jm().format(dateTime!.toLocal())
            : '',
      ),
    );
  }
}
