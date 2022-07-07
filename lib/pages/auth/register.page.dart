import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/auth/register_account/register_account.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/pages/auth/login.page.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/image_picker.util.dart';
import 'package:sonic_flutter/utils/image_upload.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/utils/validators/value.validator.dart';
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/loading_text_icon_button.widget.dart';
import 'package:sonic_flutter/widgets/common/profile_picture.widget.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  static const String route = "/register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final AuthService _authService;

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _loading = false;
  String _imageUrl = "";

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fetching service from the providers.
    _authService = Provider.of<AuthService>(context, listen: false);
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

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      setState(() {
        _imageUrl = uploadedUrl;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Profile picture uploaded!",
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

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      setState(() {
        _imageUrl = uploadedUrl;
      });

      // Display a success snackbar.
      displaySnackBar(
        "Profile picture uploaded!",
        context,
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

  /*
   * Form Submission method for creation of a new account.
   */
  Future<void> _onFormSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // Preparing the DTO.
      RegisterAccountDto registerAccountDto = RegisterAccountDto(
        email: _emailAddressController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        username: _usernameController.text,
        imageUrl: _imageUrl,
      );

      // Create it on the server.
      await _authService.registerAccount(registerAccountDto);

      displaySnackBar(
        "Account successfully created.",
        context,
      );

      Navigator.of(context).pushReplacementNamed(Login.route);
    } on AuthException catch (error) {
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
        'Register Page Error',
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

    _fullNameController.dispose();
    _usernameController.dispose();
    _emailAddressController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Register an account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.longestSide * 0.04,
                    ),
                  ),
                  ProfilePicture(
                    imageUrl: _imageUrl,
                    size: MediaQuery.of(context).size.width * 0.4,
                  ),
                  TextButton(
                    onPressed: _onUploadImage,
                    child: const Text('Upload Picture'),
                  ),
                  CustomField(
                    textFieldController: _fullNameController,
                    label: 'Full Name',
                    validators: [
                      MinLengthValidator(
                        5,
                        errorText:
                            'Full Name needs to be at least 5 characters long.',
                      ),
                    ],
                    textInputType: TextInputType.text,
                  ),
                  CustomField(
                    textFieldController: _usernameController,
                    label: 'Username',
                    validators: [
                      MinLengthValidator(
                        5,
                        errorText:
                            'Username needs to be at least 5 characters long.',
                      ),
                    ],
                    textInputType: TextInputType.text,
                  ),
                  CustomField(
                    textFieldController: _emailAddressController,
                    label: 'Email Address',
                    validators: [
                      RequiredValidator(
                        errorText: 'Email Address Is Required.',
                      ),
                      EmailValidator(
                        errorText:
                            'Email address needs to be a valid email address',
                      ),
                    ],
                    textInputType: TextInputType.emailAddress,
                  ),
                  CustomField(
                    textFieldController: _passwordController,
                    label: 'Password',
                    validators: [
                      MinLengthValidator(
                        5,
                        errorText:
                            'Password needs to be at least 5 characters long.',
                      ),
                    ],
                    textInputType: TextInputType.text,
                    obscureText: true,
                  ),
                  CustomField(
                    textFieldController: _passwordAgainController,
                    label: 'Password Again',
                    validators: [
                      MinLengthValidator(
                        5,
                        errorText:
                            'Password needs to be at least 5 characters long.',
                      ),
                      ValueValidator(
                        checkAgainstTextController: _passwordController,
                        errorText: 'Passwords do not match.',
                      ),
                    ],
                    textInputType: TextInputType.text,
                    obscureText: true,
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
                              text: 'Register',
                              loadingText: 'Registering',
                              icon: const Icon(
                                Icons.login,
                              ),
                            )
                          : LoadingTextIconButton(
                              connected: false,
                              loading: _loading,
                              onFormSubmit: _onFormSubmit,
                              text: 'Register',
                              loadingText: 'Registering',
                              icon: const Icon(
                                Icons.login,
                              ),
                            );
                    },
                    child: const SizedBox(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(Login.route);
                    },
                    child: const Text('Already have an account? Log in here!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
