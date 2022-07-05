import 'package:flutter/material.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';
import 'package:sonic_flutter/widgets/friend_request/friend_list_tab.widget.dart';

class FriendRequest extends StatelessWidget {
  static const route = "/friends";

  const FriendRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Friends',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Your Friends',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Sent Requests',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Friend Requests',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SingleChildScrollView(
              child: FriendListTab(
                status: FriendStatus.ACCEPTED,
              ),
            ),
            SingleChildScrollView(
              child: FriendListTab(
                status: FriendStatus.REQUESTED,
              ),
            ),
            SingleChildScrollView(
              child: FriendListTab(
                status: FriendStatus.REQUESTED_TO_YOU,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
