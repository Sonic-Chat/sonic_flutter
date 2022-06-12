import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/enum/friend_status.enum.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/friend_request/friend_request.model.dart';
import 'package:sonic_flutter/models/public_credentials/public_credentials.model.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

Future<void> hiveStartup() async {
  log.i("Hive Initialization Started");
  await Hive.initFlutter();
  log.i("Hive Initialization Completed");

  log.i("Registering Hive Adaptors");
  Hive.registerAdapter<Account>(AccountAdapter());
  Hive.registerAdapter<PublicCredentials>(PublicCredentialsAdapter());
  Hive.registerAdapter<FriendRequest>(FriendRequestAdapter());
  Hive.registerAdapter<FriendStatus>(FriendStatusAdapter());
  log.i("Registered Hive Adaptors");

  log.i("Opening Hive Boxes");
  await Hive.openBox<Account>(LOGGED_IN_USER_BOX);
  await Hive.openBox<PublicCredentials>(USERS_BOX);
  await Hive.openBox<List<dynamic>>(FRIEND_REQUESTS_BOX);
  log.i("Opened Hive Boxes");
}
