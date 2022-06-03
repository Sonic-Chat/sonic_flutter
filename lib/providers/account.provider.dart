import 'package:flutter/foundation.dart';
import 'package:sonic_flutter/models/account/account.model.dart';

/*
 * Provider Implementation for saving logged in user in memory.
 */
class AccountProvider with ChangeNotifier {
  Account? _account;

  /*
   * Save account details in memory.
   */
  void saveAccount(Account account) {
    _account = account;
    notifyListeners();
  }

  /*
   * Get account details from memory.
   */
  Account? getAccount() => _account;

  /*
   * Remove account details from memory.
   */
  void removeUser() {
    _account = null;
    notifyListeners();
  }
}
