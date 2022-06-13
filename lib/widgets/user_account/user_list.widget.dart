import 'package:flutter/material.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/widgets/user_account/user_list_item.widget.dart';

class UserList extends StatelessWidget {
  final List<PublicCredentials> users;

  const UserList({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        PublicCredentials publicCredentials = users[index];

        return UserListItem(
          publicCredentials: publicCredentials,
        );
      },
    );
  }
}
