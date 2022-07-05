import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/credentials/fetch_credentials/fetch_credentials.dto.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/credentials.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';
import 'package:sonic_flutter/widgets/user_account/user_list_item.widget.dart';

class UserFriendListItem extends StatefulWidget {
  final FriendRequest friendRequest;
  final bool disableAlert;

  const UserFriendListItem({
    Key? key,
    required this.friendRequest,
    this.disableAlert = false,
  }) : super(key: key);

  @override
  State<UserFriendListItem> createState() => _UserFriendListItemState();
}

class _UserFriendListItemState extends State<UserFriendListItem> {
  late final Account _account;
  late final Account _friendAccount;

  late final CredentialsService _credentialsService;

  PublicCredentials? _publicCredentials;

  @override
  void initState() {
    super.initState();

    _account =
        Provider.of<AccountProvider>(context, listen: false).getAccount()!;

    _friendAccount = widget.friendRequest.accounts.firstWhere(
      (element) => element.id != _account.id,
    );

    _credentialsService =
        Provider.of<CredentialsService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _credentialsService.fetchCredentials(
        FetchCredentialsDto(
          accountId: _friendAccount.id,
        ),
      ),
      builder:
          (BuildContext context, AsyncSnapshot<PublicCredentials> snapshot) {
        if (snapshot.hasError) {
          switch (snapshot.error.runtimeType) {
            case GeneralException:
              {
                GeneralException exception = snapshot.error as GeneralException;
                return Text(generalErrorStrings(exception.message));
              }
            default:
              {
                log.e(
                  "User Friend List Item Error",
                  snapshot.error,
                  snapshot.stackTrace,
                );
                return const Text(
                  "Something went wrong, please try again later",
                );
              }
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _publicCredentials = snapshot.data!;

          return _buildListItem();
        }

        return _publicCredentials == null ? _onLoadingData() : _buildListItem();
      },
    );
  }

  Widget _buildListItem() {
    return UserListItem(
      publicCredentials: _publicCredentials!,
      disableAlert: widget.disableAlert,
    );
  }

  Widget _onLoadingData() {
    return ListTile(
      leading: ProfilePicture(
        imageUrl: '',
        size: MediaQuery.of(context).size.width * 0.2,
      ),
      title: SizedBox(
        height: MediaQuery.of(context).size.height * 0.06,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.2,
              color: Colors.grey,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.5,
              color: Colors.grey,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.5,
              color: Colors.grey,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.5,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
