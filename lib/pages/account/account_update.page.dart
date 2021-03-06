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
            'Update Your Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            indicatorColor: Colors.white10,
            tabs: [
              Tab(
                child: Text(
                  'Account Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Email Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Password Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.longestSide * 0.02,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Delete Account',
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
