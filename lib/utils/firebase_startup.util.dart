import 'package:firebase_core/firebase_core.dart';
import 'package:sonic_flutter/firebase_options.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

Future<void> firebaseStartup() async {
  log.i('Firebase Initialization Started');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log.i('Firebase Initialized');
}
