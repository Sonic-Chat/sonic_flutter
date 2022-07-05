import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/arguments/group_chat_participants.argument.dart';
import 'package:sonic_flutter/dtos/chat_message/create_group_chat/create_group_chat.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/create_group_chat/create_group_chat_with_image/create_group_chat_with_image.dto.dart';
import 'package:sonic_flutter/enum/chat_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/chat.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/pages/home.page.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/image_picker.util.dart';
import 'package:sonic_flutter/utils/image_upload.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/utils/show_bottom_sheet.util.dart' as SBS;
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/loading_text_icon_button.widget.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

class NamePhotoGroupChat extends StatefulWidget {
  static const String route = "/name-photo";

  const NamePhotoGroupChat({Key? key}) : super(key: key);

  @override
  State<NamePhotoGroupChat> createState() => _NamePhotoGroupChatState();
}

class _NamePhotoGroupChatState extends State<NamePhotoGroupChat> {
  late final ChatService _chatService;

  final List<Account> _friends = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  bool _loading = false;
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();

    _chatService = context.read<ChatService>();
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

      setState(() {
        _loading = true;
      });

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "group-pictures");

      // Update image url state
      setState(() {
        _imageUrl = uploadedUrl;
        _loading = false;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Photo Uploaded!",
        context,
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

      setState(() {
        _loading = true;
      });

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "group-pictures");

      /// Update image url state
      setState(() {
        _imageUrl = uploadedUrl;
        _loading = false;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Photo Uploaded!",
        context,
      );
    }
  }

  /*
   * Method to open up camera or gallery on user's selection.
   */
  void _onUploadImage() {
    SBS.showBottomSheet(
      context,
      Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_rounded),
            title: const Text('Upload from camera'),
            onTap: _uploadFromCamera,
          ),
          ListTile(
            leading: const Icon(Icons.photo_album_sharp),
            title: const Text('Upload from storage'),
            onTap: _uploadFromGallery,
          )
        ],
      ),
    );
  }

  /*
   * Form submission method for chat group creation.
   */
  Future<void> _onFormSubmit() async {
    // Validate the form.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        // Preparing create group chat dto.
        CreateGroupChatDto createGroupChatDto = _imageUrl.isEmpty
            ? CreateGroupChatDto(
                participants: _friends.map((e) => e.id).toList(),
                name: _nameController.text)
            : CreateGroupChatWithImageDto(
                participants: _friends.map((e) => e.id).toList(),
                name: _nameController.text,
                imageUrl: _imageUrl,
              );

        // Create it on server.
        await _chatService.createGroupChat(createGroupChatDto);

        setState(() {
          _loading = false;
        });

        // Display success snackbar.
        displaySnackBar("Group chat created!", context);

        Navigator.of(context).popUntil(
          ModalRoute.withName(
            Home.route,
          ),
        );
      }
      // Handle errors.
      on ChatException catch (error) {
        for (var message in error.messages) {
          displaySnackBar(
            chatErrorStrings(message),
            context,
          );
        }
      } on GeneralException catch (error) {
        displaySnackBar(
          generalErrorStrings(error.message),
          context,
        );
      } catch (error, stackTrace) {
        log.e(
          'Name Photo Group Chat Page Error',
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
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _friends.clear();
    _friends.addAll((ModalRoute.of(context)!.settings.arguments
            as GroupChatParticipantsArgument)
        .participants);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group Chat Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 10.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    ProfilePicture(
                      imageUrl: _imageUrl,
                      size: 200,
                    ),
                    OfflineBuilder(
                      connectivityBuilder: (
                        BuildContext context,
                        ConnectivityResult connectivity,
                        Widget _,
                      ) {
                        final bool connected =
                            connectivity != ConnectivityResult.none;
                        return TextButton(
                          onPressed: connected ? _onUploadImage : null,
                          child: Text(
                            connected ? 'Upload New Image' : 'You are offline',
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        );
                      },
                      child: const SizedBox(),
                    ),
                  ],
                ),
                CustomField(
                  textFieldController: _nameController,
                  label: "Name",
                  validators: [
                    RequiredValidator(
                      errorText: "Name is required",
                    ),
                    MinLengthValidator(
                      5,
                      errorText: "Name requires at least 5 characters.",
                    ),
                  ],
                  textInputType: TextInputType.text,
                ),
                OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult value, Widget child) {
                    bool connected = value != ConnectivityResult.none;

                    return connected
                        ? LoadingTextIconButton(
                            connected: true,
                            loading: _loading,
                            onFormSubmit: _onFormSubmit,
                            text: 'Create Group',
                            loadingText: 'Creating',
                            icon: const Icon(
                              Icons.add,
                            ),
                          )
                        : LoadingTextIconButton(
                            connected: false,
                            loading: _loading,
                            onFormSubmit: _onFormSubmit,
                            text: 'Create Group',
                            loadingText: 'Creating',
                            icon: const Icon(
                              Icons.add,
                            ),
                          );
                  },
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
