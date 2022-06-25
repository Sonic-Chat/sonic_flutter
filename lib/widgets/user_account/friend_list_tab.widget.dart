import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/animations/error_occured.animation.dart';
import 'package:sonic_flutter/animations/loading.animation.dart';
import 'package:sonic_flutter/dtos/friend_request/fetch_friend_requests/fetch_friend_requests.dto.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/services/friend_request.service.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/user_account/new_request_list.widget.dart';
import 'package:sonic_flutter/widgets/user_account/user_friend_list.widget.dart';

class FriendListTab extends StatefulWidget {
  final FriendStatus status;

  const FriendListTab({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<FriendListTab> createState() => _FriendListTabState();
}

class _FriendListTabState extends State<FriendListTab> {
  late final FriendRequestService _friendRequestService;

  List<FriendRequest>? _requests;

  @override
  void initState() {
    super.initState();

    _friendRequestService = Provider.of<FriendRequestService>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _friendRequestService.fetchFriendRequests(
        FetchFriendRequestsDto(
          status: widget.status,
        ),
      ),
      builder:
          (BuildContext context, AsyncSnapshot<List<FriendRequest>> snapshot) {
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
                  "Friend List Tab Error",
                  snapshot.error,
                  snapshot.stackTrace,
                );
                return const ErrorOccured(
                  message: "Something went wrong, please try again later",
                );
              }
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _requests = snapshot.data!;

          return _buildList();
        }

        return _requests == null
            ? const Loading(
                message: 'Fetching requests',
              )
            : _buildList();
      },
    );
  }

  Widget _buildList() {
    return widget.status == FriendStatus.REQUESTED_TO_YOU
        ? NewRequestList(
            users: _requests!,
            refreshStatus: () {
              setState(() {});
            })
        : UserFriendList(
            users: _requests!,
          );
  }
}
