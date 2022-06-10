import 'package:flutter/material.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

class UserDetailsAlert extends StatefulWidget {
  final PublicCredentials publicCredentials;

  const UserDetailsAlert({
    Key? key,
    required this.publicCredentials,
  }) : super(key: key);

  @override
  State<UserDetailsAlert> createState() => _UserDetailsAlertState();
}

class _UserDetailsAlertState extends State<UserDetailsAlert> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: Column(
          children: [
            ProfilePicture(
              imageUrl: widget.publicCredentials.account.imageUrl,
              size: MediaQuery.of(context).size.shortestSide * 0.3,
            ),
            Text(
              widget.publicCredentials.account.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.longestSide * 0.05,
              ),
            ),
            Text(
              widget.publicCredentials.username,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.longestSide * 0.02,
              ),
            ),
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.longestSide * 0.02,
              ),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Send Friend Request',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
