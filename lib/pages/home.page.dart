import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/friend_request/fetch_friend_requests/fetch_friend_requests.dto.dart';
import 'package:sonic_flutter/pages/account/account_update.page.dart';
import 'package:sonic_flutter/pages/account/search.page.dart';
import 'package:sonic_flutter/services/friend_request.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String route = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    Provider.of<FriendRequestService>(
      context,
      listen: false,
    )
        .fetchFriendRequests(
          FetchFriendRequestsDto(
            status: null,
          ),
        )
        .then((value) => log.i('Friend Requests Fetched'))
        .catchError(
          (error, stackTrace) => log.e(
            'Home Page Error',
            error,
            stackTrace,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sonic Chat"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hello from Home Page',
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AccountUpdate.route,
                );
              },
              child: const Text('Update Account'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Search.route,
                );
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
