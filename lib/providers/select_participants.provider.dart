import 'package:flutter/material.dart';
import 'package:sonic_flutter/models/account/account.model.dart';

class SelectParticipantsProvider with ChangeNotifier {
  final List<Account> selectedFriends = [];

  void selectOrUnselectFriend(Account friend) {
    if (selectedFriends
        .where((element) => element.id == friend.id)
        .isNotEmpty) {
      selectedFriends.removeWhere((element) => element.id == friend.id);
    } else {
      selectedFriends.add(friend);
    }

    notifyListeners();
  }
}
