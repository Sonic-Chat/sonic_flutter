import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

Future<void> hiveStartup() async {
  log.i("Hive Initialization Started");
  await Hive.initFlutter();
  log.i("Hive Initialization Completed");
}
