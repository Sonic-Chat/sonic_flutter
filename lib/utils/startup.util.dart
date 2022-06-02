import 'package:flutter/material.dart';
import 'package:sonic_flutter/utils/firebase_startup.util.dart';

Future<void> startup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseStartup();
}
