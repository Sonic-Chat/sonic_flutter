import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/chat_message/delete_group_chat/delete_group_chat.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/update_group_chat/update_group_chat.dto.dart';
import 'package:sonic_flutter/dtos/chat_message/update_group_chat/update_group_chat_with_image/update_group_chat_with_image.dto.dart';
import 'package:sonic_flutter/enum/chat_error.enum.dart';
import 'package:sonic_flutter/enum/chat_type.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/chat.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/models/chat/chat.model.dart';
import 'package:sonic_flutter/pages/home.page.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/chat.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/image_picker.util.dart';
import 'package:sonic_flutter/utils/image_upload.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/utils/show_bottom_sheet.util.dart' as SBS;
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';
import 'package:sonic_flutter/widgets/user_account/user_details.widget.dart';

class ChatDetails extends StatefulWidget {
  static const route = "/group-details";

  const ChatDetails({Key? key}) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  Chat? _chat;

  late final ChatService _chatService;

  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
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
      });

      await _onImageUpdate();

      setState(() {
        _loading = false;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Photo Updated!",
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
      });

      await _onImageUpdate();

      setState(() {
        _loading = false;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Photo Updated!",
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
   * Form submission method for chat group name updating.
   */
  Future<void> _onChatNameUpdate() async {
    // Validate the form.
    if (_nameFormKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        // Preparing the DTO.
        UpdateGroupChatDto updateGroupChatDto = _imageUrl.isEmpty
            ? UpdateGroupChatDto(
                chatId: _chat!.id,
                participants: _chat!.participants.map((e) => e.id).toList(),
                name: _nameController.text,
              )
            : UpdateGroupChatWithImageDto(
                chatId: _chat!.id,
                participants: _chat!.participants.map((e) => e.id).toList(),
                name: _nameController.text,
                imageUrl: _imageUrl,
              );

        // Update it on server.
        Chat chat = await _chatService.updateGroupChat(updateGroupChatDto);

        setState(() {
          _chat = chat;
          _loading = false;
        });

        Navigator.of(context).pop();

        // Display success snackbar.
        displaySnackBar("Group chat updated!", context);
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

  /*
   * Form submission method for chat group name updating.
   */
  Future<void> _onImageUpdate() async {
    setState(() {
      _loading = true;
    });

    try {
      UpdateGroupChatDto updateGroupChatDto = UpdateGroupChatWithImageDto(
        chatId: _chat!.id,
        participants: _chat!.participants.map((e) => e.id).toList(),
        name: _chat!.name,
        imageUrl: _imageUrl,
      );

      Chat chat = await _chatService.updateGroupChat(updateGroupChatDto);

      setState(() {
        _chat = chat;
        _imageUrl = chat.imageUrl;
        _loading = false;
      });

      // Display success snackbar.
      displaySnackBar("Group chat updated!", context);

      Navigator.of(context).pop();
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

  /*
   * Form submission method for chat group name updating.
   */
  Future<void> _onLeaveGroup() async {
    setState(() {
      _loading = true;
    });

    Account loggedInAccount = context.read<AccountProvider>().getAccount()!;

    try {
      UpdateGroupChatDto updateGroupChatDto = _imageUrl.isEmpty
          ? UpdateGroupChatDto(
              chatId: _chat!.id,
              participants: _chat!.participants
                  .where((element) => element.id != loggedInAccount.id)
                  .map((e) => e.id)
                  .toList(),
              name: _nameController.text,
            )
          : UpdateGroupChatWithImageDto(
              chatId: _chat!.id,
              participants: _chat!.participants
                  .where((element) => element.id != loggedInAccount.id)
                  .map((e) => e.id)
                  .toList(),
              name: _nameController.text,
              imageUrl: _imageUrl,
            );

      await _chatService.updateGroupChat(updateGroupChatDto);

      setState(() {
        _loading = false;
      });

      Navigator.of(context).popUntil(
        ModalRoute.withName(
          Home.route,
        ),
      );

      // Display success snackbar.
      displaySnackBar("Left Group Chat", context);
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

  /*
   * Form submission method for chat group name updating.
   */
  Future<void> _onDeleteGroup() async {
    setState(() {
      _loading = true;
    });

    try {
      DeleteGroupChatDto deleteGroupChatDto = DeleteGroupChatDto(
        chatId: _chat!.id,
      );

      await _chatService.deleteGroupChat(deleteGroupChatDto);

      setState(() {
        _loading = false;
      });

      Navigator.of(context).popUntil(
        ModalRoute.withName(
          Home.route,
        ),
      );

      // Display success snackbar.
      displaySnackBar("Group chat deleted!", context);
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

  void _updateName() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Update Name'),
        content: Form(
          key: _nameFormKey,
          child: CustomField(
            textFieldController: _nameController,
            label: 'Name',
            validators: [
              RequiredValidator(
                errorText: "Name is required",
              ),
              MinLengthValidator(
                5,
                errorText: "Name requires at least 5 characters.",
              ),
            ],
            textInputType: TextInputType.name,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onChatNameUpdate,
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chat == null) {
      _chat = ModalRoute.of(context)!.settings.arguments as Chat;
      _imageUrl = _chat!.imageUrl;
      _nameController.text = _chat!.name;
    }
    Account loggedInAccount =
        Provider.of<AccountProvider>(context, listen: false).getAccount()!;

    return Scaffold(
      appBar: AppBar(
        title: _chat!.type == ChatType.GROUP
            ? const Text("Group Details")
            : const Text("Friend Details"),
      ),
      body: _chat!.type == ChatType.GROUP
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: OfflineBuilder(
                      connectivityBuilder: (BuildContext context,
                          ConnectivityResult value, Widget child) {
                        bool connected = value != ConnectivityResult.none;

                        return connected
                            ? InkWell(
                                onTap: _onUploadImage,
                                child: ProfilePicture(
                                  imageUrl: _imageUrl,
                                  size: MediaQuery.of(context).size.width * 0.4,
                                ),
                              )
                            : ProfilePicture(
                                imageUrl: _imageUrl,
                                size: MediaQuery.of(context).size.width * 0.4,
                              );
                      },
                      child: const SizedBox(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _chat!.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.black,
                            ),
                      ),
                      OfflineBuilder(
                        connectivityBuilder: (BuildContext context,
                            ConnectivityResult value, Widget child) {
                          bool connected = value != ConnectivityResult.none;

                          return connected
                              ? IconButton(
                                  onPressed: _updateName,
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                )
                              : const IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.offline_bolt,
                                  ),
                                );
                        },
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Text(
                      'Participants',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _chat!.participants.length,
                    itemBuilder: (BuildContext context, int index) {
                      Account participant = _chat!.participants[index];

                      return ListTile(
                        leading: ProfilePicture(
                          imageUrl: participant.imageUrl,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                        title: Text(
                          participant.fullName,
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _onLeaveGroup,
                        child: const Text('Leave Group'),
                      ),
                      TextButton(
                        onPressed: _onDeleteGroup,
                        child: const Text(
                          'Delete Group',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : UserDetails(
              account: _chat!.participants
                  .where((element) => element.id != loggedInAccount.id)
                  .first,
            ),
    );
  }
}
