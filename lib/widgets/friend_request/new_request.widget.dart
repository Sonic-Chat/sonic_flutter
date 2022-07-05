import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/friend_request/delete_friend_request/delete_friend_request.dto.dart';
import 'package:sonic_flutter/dtos/friend_request/update_friend_request/update_friend_request.dto.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';
import 'package:sonic_flutter/enum/friends_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/services/friend_request.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/common/loading_icon_button.widget.dart';
import 'package:sonic_flutter/widgets/friend_request/user_friend_list_item.dart';

import '../../exceptions/friend_request.exception.dart';

class NewRequest extends StatefulWidget {
  final FriendRequest friendRequest;
  final VoidCallback refreshStatus;

  const NewRequest({
    Key? key,
    required this.friendRequest,
    required this.refreshStatus,
  }) : super(key: key);

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  late final FriendRequestService _friendRequestService;

  bool _acceptLoading = false;
  bool _ignoreLoading = false;
  bool _cancelLoading = false;

  @override
  void initState() {
    super.initState();

    _friendRequestService = Provider.of<FriendRequestService>(
      context,
      listen: false,
    );
  }

  Future<void> _updateStatus(FriendStatus friendStatus) async {
    setState(() {
      _acceptLoading = friendStatus == FriendStatus.ACCEPTED;
      _ignoreLoading = friendStatus == FriendStatus.IGNORED;
    });

    try {
      UpdateFriendRequestDto updateFriendRequestDto = UpdateFriendRequestDto(
        id: widget.friendRequest.id,
        status: friendStatus,
      );

      await _friendRequestService.updateFriendRequest(updateFriendRequestDto);
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
        'New Request Widget Error',
        error,
        stackTrace,
      );
      displaySnackBar(
        'Something went wrong, please try again later',
        context,
      );
    }

    setState(() {
      _acceptLoading = false;
      _ignoreLoading = false;
    });

    widget.refreshStatus();
  }

  Future<void> _deleteRequest() async {
    setState(() {
      _cancelLoading = true;
    });

    try {
      DeleteFriendRequestDto deleteFriendRequestDto = DeleteFriendRequestDto(
        id: widget.friendRequest.id,
      );

      await _friendRequestService.deleteFriendRequest(deleteFriendRequestDto);
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
        'New Request Widget Error',
        error,
        stackTrace,
      );
      displaySnackBar(
        'Something went wrong, please try again later',
        context,
      );
    }

    setState(() {
      _cancelLoading = false;
    });
    widget.refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        MediaQuery.of(context).size.longestSide * 0.01,
      ),
      child: Card(
        child: Column(
          children: [
            UserFriendListItem(
              friendRequest: widget.friendRequest,
              disableAlert: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult value, Widget child) {
                    bool connected = value != ConnectivityResult.none;

                    return connected
                        ? LoadingIconButton(
                            onFormSubmit: () async {
                              await _updateStatus(
                                FriendStatus.ACCEPTED,
                              );
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            connected: connected,
                            loading: _acceptLoading,
                          )
                        : LoadingIconButton(
                            onFormSubmit: () async {
                              await _updateStatus(
                                FriendStatus.ACCEPTED,
                              );
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            connected: connected,
                            loading: _acceptLoading,
                          );
                  },
                  child: const SizedBox(),
                ),
                OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult value, Widget child) {
                    bool connected = value != ConnectivityResult.none;

                    return connected
                        ? LoadingIconButton(
                            onFormSubmit: () async {
                              await _updateStatus(
                                FriendStatus.IGNORED,
                              );
                            },
                            icon: const Icon(
                              Icons.do_not_disturb,
                              color: Colors.blue,
                            ),
                            connected: connected,
                            loading: _ignoreLoading,
                          )
                        : LoadingIconButton(
                            onFormSubmit: () async {
                              await _updateStatus(
                                FriendStatus.IGNORED,
                              );
                            },
                            icon: const Icon(
                              Icons.do_not_disturb,
                              color: Colors.blue,
                            ),
                            connected: connected,
                            loading: _ignoreLoading,
                          );
                  },
                  child: const SizedBox(),
                ),
                OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult value, Widget child) {
                    bool connected = value != ConnectivityResult.none;

                    return connected
                        ? LoadingIconButton(
                            onFormSubmit: _deleteRequest,
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            connected: connected,
                            loading: _cancelLoading,
                          )
                        : LoadingIconButton(
                            onFormSubmit: _deleteRequest,
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            connected: connected,
                            loading: _cancelLoading,
                          );
                  },
                  child: const SizedBox(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
