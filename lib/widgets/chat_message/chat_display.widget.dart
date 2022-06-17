import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/models/message/message.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

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

      switch (lastMessage.type) {
        case MessageType.IMAGE:
          {
            body = '📸 Image';
            break;
          }
        case MessageType.IMAGE_TEXT:
          {
            body = '📸 ${lastMessage.message!}';
            break;
          }
        case MessageType.TEXT:
          {
            body = lastMessage.message!;
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
      leading: ProfilePicture(
        imageUrl: _friendAccount.imageUrl,
        size: MediaQuery.of(context).size.width * 0.1,
      ),
      title: Text(
        _friendAccount.fullName,
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
    );
  }
}
