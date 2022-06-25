import 'package:flutter/material.dart';
import 'package:sonic_flutter/animations/not_found.animation.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/widgets/user_account/user_friend_list_item.dart';

class UserFriendList extends StatelessWidget {
  final List<FriendRequest> users;

  const UserFriendList({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: users.isNotEmpty
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                FriendRequest friendRequest = users[index];

                return UserFriendListItem(
                  friendRequest: friendRequest,
                );
              },
            )
          : const NotFound(
              message: 'No requests found.',
            ),
    );
  }
}
