import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/message_image_upload.argument.dart';
import 'package:sonic_flutter/arguments/send_image.argument.dart';
import 'package:sonic_flutter/arguments/send_image.argument.dart';
import 'package:sonic_flutter/enum/message_type.enum.dart';
import 'package:sonic_flutter/pages/chat_message/send_image.page.dart';
import 'package:sonic_flutter/pages/chat_message/send_image.page.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/image_picker.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/utils/message_image_upload.util.dart';

class ChatField extends StatefulWidget {
  final MessageType messageType;
  final String chatId;
  final File? imageFile;

  const ChatField({
    Key? key,
    this.messageType = MessageType.TEXT,
    required this.chatId,
    this.imageFile,
  }) : super(key: key);

  @override
  State<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  late final ChatService _chatService;

  final TextEditingController textFieldController = TextEditingController();

  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _chatService = Provider.of<ChatService>(
      context,
      listen: false,
    );
  }

  /*
   * Method for uploading images from gallery.
   */
  Future<void> _uploadFromGallery() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openGallery();

    // Run if there is an image selected.
    if (imageXFile != null) {
      // Prepare the file from the selected image.
      File imageFile = File(imageXFile.path);

      Navigator.of(context).pushNamed(
        SendImage.route,
        arguments: SendImageArgument(
          chatId: widget.chatId,
          file: imageFile,
        ),
      );
    }
  }

  /*
   * Method for uploading images from camera.
   */
  Future<void> _uploadFromCamera() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openCamera();

    // Run if there is an image selected.
    if (imageXFile != null) {
      // Prepare the file from the selected image.
      File imageFile = File(imageXFile.path);

      Navigator.of(context).pushNamed(
        SendImage.route,
        arguments: SendImageArgument(
          chatId: widget.chatId,
          file: imageFile,
        ),
      );
    }
  }

  /*
   * Method to open up camera or gallery on user's selection.
   */
  void _onUploadImage() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_rounded),
            title: const Text(
              'Upload from camera',
            ),
            onTap: _uploadFromCamera,
          ),
          ListTile(
            leading: const Icon(Icons.photo_album_sharp),
            title: const Text(
              'Upload from storage',
            ),
            onTap: _uploadFromGallery,
          )
        ],
      ),
    );
  }

  Future<void> _onFormSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    MessageType sendMessageType = widget.messageType;

    if (textFieldController.text.isNotEmpty) {
      if (sendMessageType == MessageType.IMAGE) {
        sendMessageType = MessageType.IMAGE_TEXT;
      }
    }

    try {
      if (sendMessageType == MessageType.IMAGE) {
        MessageImageUploadArgument messageImageUploadArgument =
            await messageImageUpload(
          widget.imageFile!,
        );

        await _chatService.sendImage(
          firebaseId: messageImageUploadArgument.firebaseId,
          imageUrl: messageImageUploadArgument.imageUrl,
          chatId: widget.chatId,
        );

        Navigator.of(context).pop();
      } else if (sendMessageType == MessageType.IMAGE_TEXT) {
        MessageImageUploadArgument messageImageUploadArgument =
            await messageImageUpload(
          widget.imageFile!,
        );

        await _chatService.sendMessageImage(
            firebaseId: messageImageUploadArgument.firebaseId,
            imageUrl: messageImageUploadArgument.imageUrl,
            chatId: widget.chatId,
            message: textFieldController.text);

        Navigator.of(context).pop();
      } else if (sendMessageType == MessageType.TEXT) {
        await _chatService.sendTextMessage(
            chatId: widget.chatId, message: textFieldController.text);

        textFieldController.clear();
      }
    } catch (error, stackTrace) {
      log.e(
        'Send Image Page Error',
        error,
        stackTrace,
      );
      displaySnackBar(
        'Something went wrong, please try again later',
        context,
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        child: TextFormField(
          style: const TextStyle(
            color: Colors.black,
          ),
          minLines: 1,
          maxLines: 10,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: Colors.black,
            ),
            hintText: 'Message...',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: Colors.white,
            labelText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                15.0,
              ),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            prefixIcon: widget.messageType == MessageType.TEXT
                ? OfflineBuilder(
                    connectivityBuilder: (BuildContext context,
                        ConnectivityResult value, Widget child) {
                      bool connected = value != ConnectivityResult.none;

                      return connected
                          ? IconButton(
                              icon: const Icon(
                                Icons.photo,
                              ),
                              onPressed: _onUploadImage,
                            )
                          : const IconButton(
                              icon: Icon(
                                Icons.photo,
                              ),
                              onPressed: null,
                            );
                    },
                    child: const SizedBox(),
                  )
                : null,
            suffixIcon: _loading
                ? const CircularProgressIndicator(
                    color: Colors.grey,
                  )
                : OfflineBuilder(
                    connectivityBuilder: (BuildContext context,
                        ConnectivityResult value, Widget child) {
                      bool connected = value != ConnectivityResult.none;

                      return connected
                          ? IconButton(
                              icon: const Icon(
                                Icons.send,
                              ),
                              onPressed: _onFormSubmit,
                            )
                          : const IconButton(
                              icon: Icon(
                                Icons.send,
                              ),
                              onPressed: null,
                            );
                    },
                    child: const SizedBox(),
                  ),
          ),
          controller: textFieldController,
          validator: (widget.messageType == MessageType.IMAGE_TEXT ||
                  widget.messageType == MessageType.TEXT)
              ? MultiValidator(
                  [
                    RequiredValidator(
                      errorText: 'Message is required.',
                    ),
                  ],
                )
              : MultiValidator([]),
        ),
      ),
    );
  }
}
