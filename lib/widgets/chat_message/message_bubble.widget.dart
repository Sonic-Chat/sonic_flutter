import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/models/message/message.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class MessageBubble extends StatelessWidget {
  final Chat chat;
  final Message message;
  final Message? selectedMessage;
  final Function onLongPress;

  const MessageBubble({
    Key? key,
    required this.chat,
    required this.message,
    required this.onLongPress,
    required this.selectedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (BuildContext context, AccountProvider state, _) {
        bool userCheck = message.sentBy.id == state.getAccount()!.id;
        return InkWell(
          onLongPress: userCheck
              ? () {
                  onLongPress(message);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(
              10.0,
            ),
            color: selectedMessage != null
                ? selectedMessage!.id == message.id
                    ? Colors.lightBlue.withOpacity(0.5)
                    : Colors.white
                : Colors.white,
            alignment: userCheck ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment:
                  userCheck ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  decoration: BoxDecoration(
                    color: userCheck ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: message.type == MessageType.TEXT
                      ? Text(
                          message.message!,
                          style: TextStyle(
                            color: userCheck ? Colors.white : Colors.black,
                          ),
                        )
                      : message.type == MessageType.IMAGE_TEXT
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: message.image!.imageUrl,
                                    fit: BoxFit.fill,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      log.e(error);
                                      return const Icon(Icons.error);
                                    },
                                    imageBuilder: (context, imageProvider) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        20.0,
                                      ),
                                      child: Image(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      message.message!,
                                      style: TextStyle(
                                        color: userCheck
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: message.image!.imageUrl,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                log.e(error);
                                return const Icon(Icons.error);
                              },
                              imageBuilder: (context, imageProvider) =>
                                  ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  child: Text(
                    DateFormat.yMd()
                        .add_jm()
                        .format(
                          message.createdAt.toLocal(),
                        )
                        .toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
