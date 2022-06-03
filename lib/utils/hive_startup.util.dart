import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sonic_flutter/constants/hive.constant.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

Future<void> hiveStartup() async {
  log.i("Hive Initialization Started");
  await Hive.initFlutter();
  log.i("Hive Initialization Completed");

  log.i("Registering Hive Adaptors");
  Hive.registerAdapter<Account>(AccountAdapter());
  log.i("Registered Hive Adaptors");

  log.i("Opening Hive Boxes");
  await Hive.openBox<Account>(LOGGED_IN_USER_BOX);
  log.i("Opened Hive Boxes");
}
