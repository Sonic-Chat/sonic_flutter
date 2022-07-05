import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/providers/select_participants.provider.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

class SelectFriendListItem extends StatelessWidget {
  const SelectFriendListItem({
    Key? key,
    required this.friendAccount,
  }) : super(key: key);

  final Account friendAccount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfilePicture(
        imageUrl: friendAccount.imageUrl,
        size: MediaQuery.of(context).size.shortestSide * 0.1,
      ),
      title: Text(
        friendAccount.fullName,
      ),
      trailing: Checkbox(
        value: context
            .watch<SelectParticipantsProvider>()
            .selectedFriends
            .where((element) => element.id == friendAccount.id)
            .isNotEmpty,
        onChanged: (_) {
          context
              .read<SelectParticipantsProvider>()
              .selectOrUnselectFriend(friendAccount);
        },
      ),
    );
  }
}
