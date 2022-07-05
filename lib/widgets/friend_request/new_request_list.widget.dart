import 'package:flutter/material.dart';
import 'package:sonic_flutter/animations/not_found.animation.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/widgets/friend_request/new_request.widget.dart';

class NewRequestList extends StatelessWidget {
  final List<FriendRequest> users;
  final VoidCallback refreshStatus;

  const NewRequestList({
    Key? key,
    required this.users,
    required this.refreshStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return users.isNotEmpty
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              FriendRequest friendRequest = users[index];

              return NewRequest(
                  friendRequest: friendRequest, refreshStatus: refreshStatus);
            },
          )
        : const NotFound(
            message: 'No requests found.',
          );
  }
}
