import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/animations/error_occured.animation.dart';
import 'package:sonic_flutter/animations/loading.animation.dart';
import 'package:sonic_flutter/dtos/credentials/search_credentials/search_credentials.dto.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/services/credentials.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/user_account/user_list.widget.dart';

class UserSearch extends StatefulWidget {
  final String query;

  const UserSearch({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  late final CredentialsService _credentialsService;

  List<PublicCredentials>? _credentials;

  @override
  void initState() {
    super.initState();

    _credentialsService =
        Provider.of<CredentialsService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _credentialsService.searchCredentials(
        SearchCredentialsDto(
          search: widget.query,
        ),
      ),
      builder: (BuildContext context,
          AsyncSnapshot<List<PublicCredentials>> snapshot) {
        if (snapshot.hasError) {
          log.e(snapshot.error, snapshot.error, snapshot.stackTrace);

          return const ErrorOccurred(
            message: 'Something went wrong, please try again later',
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _credentials = snapshot.data!;

          return _buildUserList();
        }

        return _credentials == null
            ? const Loading(
                message: 'Searching for users',
              )
            : _buildUserList();
      },
    );
  }

  Widget _buildUserList() {
    return UserList(
      users: _credentials!,
    );
  }
}
