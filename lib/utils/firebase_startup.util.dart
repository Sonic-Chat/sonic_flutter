import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sonic_flutter/firebase_options.dart';

Future<void> firebaseStartup() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.useAuthEmulator(
    'localhost',
    9099,
  );

  await FirebaseStorage.instance.useStorageEmulator(
    "localhost",
    9199,
  );
}
