import 'package:image_picker/image_picker.dart';

final ImagePicker imagePicker = ImagePicker();

Future<XFile?> openGallery() async =>
    await imagePicker.pickImage(source: ImageSource.gallery);

Future<XFile?> openCamera() async =>
    await imagePicker.pickImage(source: ImageSource.camera);
