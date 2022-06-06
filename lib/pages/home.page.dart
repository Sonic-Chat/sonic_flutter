import 'package:flutter/material.dart';
import 'package:sonic_flutter/pages/account/account_update.page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static const String route = "/home";

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
          ],
        ),
      ),
    );
  }
}
