import 'package:flutter/material.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';
import 'package:sonic_flutter/widgets/user_account/user_details_alert.widget.dart';

class UserSearchResult extends StatelessWidget {
  final PublicCredentials publicCredentials;

  const UserSearchResult({
    Key? key,
    required this.publicCredentials,
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
      onTap: () {
        _handleClick(context);
      },
    );
  }
}
