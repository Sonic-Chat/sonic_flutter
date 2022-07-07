import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/group_chat_participants.argument.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/pages/chat_message/name_photo_group_chat.page.dart';
import 'package:sonic_flutter/providers/select_participants.provider.dart';
import 'package:sonic_flutter/services/friend_request.service.dart';
import 'package:sonic_flutter/widgets/friend_request/select_friends_list.widget.dart';

class SelectParticipants extends StatefulWidget {
  static const String route = "/select-participants";

  const SelectParticipants({Key? key}) : super(key: key);

  @override
  State<SelectParticipants> createState() => _SelectParticipantsState();
}

class _SelectParticipantsState extends State<SelectParticipants> {
  late final FriendRequestService _friendRequestService;

  List<FriendRequest> friends = [];

  @override
  void initState() {
    super.initState();

    // Fetching service from the providers.
    _friendRequestService = context.read<FriendRequestService>();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectParticipantsProvider>(
      create: (_) => SelectParticipantsProvider(),
      child: Consumer<SelectParticipantsProvider>(
        builder: (
          BuildContext context,
          SelectParticipantsProvider provider,
          Widget? child,
        ) =>
            Scaffold(
          appBar: AppBar(
            title: const Text('Select Participants'),
          ),
          body: ValueListenableBuilder<Box<List<dynamic>>>(
            valueListenable:
                Hive.box<List<dynamic>>(FRIEND_REQUESTS_BOX).listenable(),
            builder:
                (BuildContext context, Box<List<dynamic>> box, Widget? widget) {
              return SelectFriendsList(
                friends: _friendRequestService.fetchRequestsFromOfflineDb(
                  FriendStatus.ACCEPTED.toString(),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                NamePhotoGroupChat.route,
                arguments: GroupChatParticipantsArgument(
                  participants: provider.selectedFriends,
                ),
              );
            },
            child: const Icon(
              Icons.check,
            ),
          ),
        ),
      ),
    );
  }
}
