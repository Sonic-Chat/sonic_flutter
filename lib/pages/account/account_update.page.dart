import 'package:flutter/material.dart';
import 'package:sonic_flutter/widgets/user_account/delete_account.widget.dart';
import 'package:sonic_flutter/widgets/user_account/update_email.widget.dart';
import 'package:sonic_flutter/widgets/user_account/update_password.widget.dart';
import 'package:sonic_flutter/widgets/user_account/update_profile.widget.dart';

class AccountUpdate extends StatelessWidget {
  const AccountUpdate({Key? key}) : super(key: key);

  static const route = "/account-update";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Your Profile'),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Account Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Email Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Password Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Delete Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProfileUpdateTab(),
            EmailUpdateTab(),
            PasswordUpdateTab(),
            DeleteAccountTab(),
          ],
        ),
      ),
    );
  }
}
