import 'package:flutter/material.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';
import 'package:sonic_flutter/widgets/user_account/user_details_alert.widget.dart';

class UserListItem extends StatelessWidget {
  final PublicCredentials publicCredentials;
  final bool disableAlert;

  const UserListItem({
    Key? key,
    required this.publicCredentials,
    this.disableAlert = false,
  }) : super(key: key);

  void _handleClick(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: UserDetailsAlert(
            publicCredentials: publicCredentials,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfilePicture(
        imageUrl: publicCredentials.account.imageUrl,
        size: MediaQuery.of(context).size.shortestSide * 0.1,
      ),
      title: Text(publicCredentials.account.fullName),
      subtitle: Text(publicCredentials.username),
      onTap: disableAlert
          ? null
          : () {
              _handleClick(context);
            },
    );
  }
}
