import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/singular_chat.argument.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/enum/chat_error.enum.dart';
import 'package:sonic_flutter/enum/chat_type.enum.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/pages/chat_message/group_chat_details.page.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/providers/singular_chat.provider.dart';
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

    _chatService.chatErrorsStreams.stream.listen((event) {
      for (var element in event) {
        String errorString = chatErrorStrings(element);
        displaySnackBar(errorString, context);
      }
    });
  }

  void _confirmDelete(SingularChatProvider singularChatProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: !_loading
            ? [
                TextButton(
                  onPressed: () async => _onDeleteMessage(
                    singularChatProvider,
                  ),
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

  Future<void> _onDeleteMessage(
    SingularChatProvider singularChatProvider,
  ) async {
    setState(() {
      _loading = true;
    });

    try {
      await _chatService.deleteMessage(
        messageId: singularChatProvider.message!.id,
      );

      Navigator.of(context).pop();

      singularChatProvider.unselectMessage();
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
    SingularChatArgument singularChatArgument =
        ModalRoute.of(context)!.settings.arguments as SingularChatArgument;

    String chatId = singularChatArgument.chatId;

    _chatService
        .markSeen(
          chatId: chatId,
        )
        .then((value) => log.i("Marked chat $chatId seen."))
        .catchError((error, stackTrace) =>
            log.e("Singular Chat page Error", error, stackTrace));

    return ChangeNotifierProvider<SingularChatProvider>(
      create: (_) => SingularChatProvider(
        chatId: chatId,
        type: singularChatArgument.type,
      ),
      child: ValueListenableBuilder<Box<Chat>>(
        valueListenable: Hive.box<Chat>(CHAT_BOX).listenable(),
        builder: (BuildContext context, Box<Chat> box, Widget? widget) {
          Chat chat = _chatService.fetchChatFromOfflineDb(chatId)!;

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
              title: context.watch<SingularChatProvider>().messageSelected
                  ? const Text('Message Selected')
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          GroupChatDetails.route,
                          arguments: chat,
                        );
                      },
                      child: ListTile(
                        tileColor: Colors.transparent,
                        selectedTileColor: Colors.transparent,
                        leading: ProfilePicture(
                          imageUrl: chat.type == ChatType.SINGLE
                              ? _friendAccount!.imageUrl
                              : chat.imageUrl,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                        title: Text(
                          chat.type == ChatType.SINGLE
                              ? _friendAccount!.fullName
                              : chat.name,
                        ),
                      ),
                    ),
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              actions: context.watch<SingularChatProvider>().messageSelected
                  ? (context.watch<SingularChatProvider>().message!.type ==
                              MessageType.TEXT ||
                          context.watch<SingularChatProvider>().message!.type ==
                              MessageType.IMAGE_TEXT)
                      ? [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: context
                                .read<SingularChatProvider>()
                                .editMessage,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmDelete(
                              context.read<SingularChatProvider>(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: context
                                .read<SingularChatProvider>()
                                .unselectMessage,
                          ),
                        ]
                      : [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmDelete(
                              context.read<SingularChatProvider>(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: context
                                .read<SingularChatProvider>()
                                .editMessage,
                          ),
                        ]
                  : [],
            ),
            body: Container(
              margin: EdgeInsets.only(
                bottom: context.watch<SingularChatProvider>().message != null
                    ? MediaQuery.of(context).size.height * 0.2
                    : MediaQuery.of(context).size.height * 0.15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MessageList(
                    chat: chat,
                  ),
                  if (seen && !delivered)
                    Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: const Text('Seen'),
                    ),
                  if (!seen && delivered)
                    Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: const Text('Delivered'),
                    ),
                  if (seen && delivered)
                    Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: const Text('Seen'),
                    ),
                ],
              ),
            ),
            bottomSheet: const ChatField(),
          );
        },
      ),
    );
  }
}
