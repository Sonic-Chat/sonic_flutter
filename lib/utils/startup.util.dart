import 'package:flutter/material.dart';
import 'package:sonic_flutter/utils/firebase_startup.util.dart';
import 'package:sonic_flutter/utils/hive_startup.util.dart';
import 'package:sonic_flutter/utils/local_notification_setup.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

Future<void> startup() async {
  WidgetsFlutterBinding.ensureInitialized();

  log.i("Running Startup Script");

  await firebaseStartup();
  await hiveStartup();
  await localNotificationSetup();

  log.i("Startup Script Completed");
}
