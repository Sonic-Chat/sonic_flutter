import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/dtos/friend_request/create_friend_request/create_friend_request.dto.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';
import 'package:sonic_flutter/enum/friends_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/services/friend_request.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/common/loading_icon_button.widget.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

import '../../exceptions/friend_request.exception.dart';

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
  late final FriendRequestService _friendRequestService;

  FriendStatus? _friendStatus;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _friendRequestService = Provider.of<FriendRequestService>(
      context,
      listen: false,
    );

    _fetchStatus();
  }

  void _fetchStatus() {
    _friendRequestService
        .fetchRequestsFromOfflineDb(LOGGED_IN_USER_REQUESTS)
        .forEach((request) {
      for (var account in request.accounts) {
        if (account.id == widget.publicCredentials.account.id) {
          setState(() {
            _friendStatus = request.status;
          });
        }
      }
    });
  }

  Future<void> _sendFriendRequest() async {
    setState(() {
      _loading = true;
    });

    try {
      CreateFriendRequestDto createFriendRequestDto = CreateFriendRequestDto(
        userId: widget.publicCredentials.account.id,
      );

      await _friendRequestService.createFriendRequest(createFriendRequestDto);

      _fetchStatus();
    } on FriendRequestException catch (error) {
      displaySnackBar(
        friendErrorStrings(error.message),
        context,
      );
    } on GeneralException catch (error) {
      displaySnackBar(
        generalErrorStrings(error.message),
        context,
      );
    } catch (error, stackTrace) {
      log.e(
        'User Details Alert Widget Error',
        error,
        stackTrace,
      );
      displaySnackBar(
        'Something went wrong, please try again later',
        context,
      );
    }

    setState(() {
      _loading = false;
    });
  }

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
              child: _friendStatus == null
                  ? OfflineBuilder(
                      connectivityBuilder: (BuildContext context,
                          ConnectivityResult value, Widget child) {
                        bool connected = value != ConnectivityResult.none;

                        return connected
                            ? LoadingIconButton(
                                connected: true,
                                loading: _loading,
                                onFormSubmit: _sendFriendRequest,
                                text: 'Send Friend Request',
                                loadingText: 'Sending',
                                icon: const Icon(
                                  Icons.person,
                                ),
                              )
                            : LoadingIconButton(
                                connected: false,
                                loading: _loading,
                                onFormSubmit: _sendFriendRequest,
                                text: 'Send Friend Request',
                                loadingText: 'Sending',
                                icon: const Icon(
                                  Icons.person,
                                ),
                              );
                      },
                      child: const SizedBox(),
                    )
                  : (_friendStatus == FriendStatus.REQUESTED) ||
                          (_friendStatus == FriendStatus.IGNORED)
                      ? ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Cancel Friend Request',
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Unfriend',
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
