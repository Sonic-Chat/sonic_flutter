import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sonic_flutter/firebase_options.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

Future<void> firebaseStartup() async {
  log.i('Firebase Initialization Started');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log.i('Firebase Initialized');

  log.i('Connecting Firebase Emulators');

  await FirebaseAuth.instance.useAuthEmulator(
    'localhost',
    9099,
  );

  await FirebaseStorage.instance.useStorageEmulator(
    "localhost",
    9199,
  );

  log.i('Connected Firebase Emulators');
}
