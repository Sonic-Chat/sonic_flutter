import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/account/update_account/update_account.dto.dart';
import 'package:sonic_flutter/dtos/account/update_account_with_image_uri/update_account_with_image_uri.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/user_account.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/image_picker.util.dart';
import 'package:sonic_flutter/utils/image_upload.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/utils/show_bottom_sheet.util.dart' as SBS;
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/loading_text_icon_button.widget.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

class ProfileUpdateTab extends StatefulWidget {
  const ProfileUpdateTab({Key? key}) : super(key: key);

  @override
  _ProfileUpdateTabState createState() => _ProfileUpdateTabState();
}

class _ProfileUpdateTabState extends State<ProfileUpdateTab> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  late final UserAccountService _userAccountService;
  late final AccountProvider _accountProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String _imageUrl = "";

  late Account _account;

  @override
  void initState() {
    super.initState();

    _accountProvider = Provider.of<AccountProvider>(context, listen: false);
    _userAccountService =
        Provider.of<UserAccountService>(context, listen: false);

    _account = _accountProvider.getAccount()!;
    _imageUrl = _account.imageUrl;

    _fullNameController.text = _account.fullName;
    _statusController.text = _account.status;
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the controllers
    _fullNameController.dispose();
    _statusController.dispose();
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
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      // Update image url state
      setState(() {
        _imageUrl = uploadedUrl;
        _loading = false;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Image has been uploaded! Please click \"Update Profile\" to confirm your changes when you are done!",
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
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      /// Update image url state
      setState(() {
        _imageUrl = uploadedUrl;
        _loading = false;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Image has been uploaded! Please click \"Update Profile\" to confirm your changes when you are done!",
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
   * Form submission method for user profile update.
   */
  Future<void> _onFormSubmit() async {
    // Validate the form.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        // Prepare DTO for updating profile.
        UpdateAccountDto updateAccountDto = _imageUrl == _account.imageUrl
            ? UpdateAccountDto(
                fullName: _fullNameController.text,
                status: _statusController.text,
              )
            : UpdateAccountWithImageUriDto(
                fullName: _fullNameController.text,
                imageUrl: _imageUrl,
                status: _statusController.text,
              );

        // Update it on server and also update the state as well.
        Account account = await _userAccountService.updateAccount(
          updateAccountDto,
        );

        _accountProvider.saveAccount(account);

        setState(() {
          _loading = false;
        });

        // Display success snackbar.
        displaySnackBar("Profile updated!", context);
      }
      // Handle errors.
      on AuthException catch (error) {
        displaySnackBar(
          authErrorStrings(error.message),
          context,
        );
      } on GeneralException catch (error) {
        displaySnackBar(
          generalErrorStrings(error.message),
          context,
        );
      } catch (error, stackTrace) {
        log.e(
          'Update Profile Widget Error',
          error,
          stackTrace,
        );
        displaySnackBar(
          'Something went wrong, please try again later',
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                textFieldController: _fullNameController,
                label: "Full Name",
                validators: [
                  RequiredValidator(
                    errorText: "Full name is required",
                  ),
                  MinLengthValidator(
                    5,
                    errorText: "Full name requires at least 5 characters.",
                  ),
                ],
                textInputType: TextInputType.text,
              ),
              CustomField(
                textFieldController: _statusController,
                label: "Status",
                validators: [
                  RequiredValidator(errorText: "Status is required"),
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
                          text: 'Update Account',
                          loadingText: 'Updating',
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      : LoadingTextIconButton(
                          connected: false,
                          loading: _loading,
                          onFormSubmit: _onFormSubmit,
                          text: 'Update Account',
                          loadingText: 'Updating',
                          icon: const Icon(
                            Icons.edit,
                          ),
                        );
                },
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
