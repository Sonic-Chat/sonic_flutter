import 'dart:io';

import 'package:sonic_flutter/arguments/message_image_upload.argument.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<MessageImageUploadArgument> messageImageUpload(
  File imageFile,
) async {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Uuid uuid = const Uuid();

  String imageUuid = uuid.v4();

  await firebaseStorage.ref("chat/$imageUuid.png").putFile(imageFile);

  String url =
      await firebaseStorage.ref("chat/$imageUuid.png").getDownloadURL();

  return MessageImageUploadArgument(
    firebaseId: imageUuid,
    imageUrl: url,
  );
}
