import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/widgets/friend_request/select_friends_list_item.widget.dart';

class SelectFriendsList extends StatelessWidget {
  final List<FriendRequest> friends;

  const SelectFriendsList({
    Key? key,
    required this.friends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        FriendRequest friendRequest = friends[index];

        Account friendAccount = friendRequest.accounts
            .where((element) =>
                element.id != context.read<AccountProvider>().getAccount()!.id)
            .first;

        return SelectFriendListItem(
          friendAccount: friendAccount,
        );
      },
    );
  }
}
