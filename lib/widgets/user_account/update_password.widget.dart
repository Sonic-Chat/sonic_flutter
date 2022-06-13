import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/credentials/update_credentials.dto.dart';
import 'package:sonic_flutter/dtos/credentials/update_password/update_password.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/services/credentials.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/utils/validators/value.validator.dart';
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/loading_text_icon_button.widget.dart';

class PasswordUpdateTab extends StatefulWidget {
  const PasswordUpdateTab({Key? key}) : super(key: key);

  @override
  _PasswordUpdateTabState createState() => _PasswordUpdateTabState();
}

class _PasswordUpdateTabState extends State<PasswordUpdateTab> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordAgainController =
      TextEditingController();

  late final CredentialsService _credentialsService;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _credentialsService =
        Provider.of<CredentialsService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the controllers
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordAgainController.dispose();
  }

  /*
   * Form submission method for user password update.
   */
  Future<void> _onFormSubmit() async {
    // Validate the form.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        // Prepare DTO for updating password.
        UpdateCredentialsDto updateCredentialsDto = UpdatePasswordDto(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        );

        // Update it on server.
        await _credentialsService.updateCredentials(updateCredentialsDto);

        setState(() {
          _loading = false;
        });

        // Display success snackbar.
        displaySnackBar("Password updated!", context);
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
          'Update Password Widget Error',
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
              CustomField(
                textFieldController: _oldPasswordController,
                label: "Old Password",
                validators: [
                  RequiredValidator(errorText: "Old Password is required"),
                  MinLengthValidator(
                    5,
                    errorText: 'Old Password should be at least 5 characters.',
                  ),
                ],
                textInputType: TextInputType.text,
                obscureText: true,
              ),
              CustomField(
                textFieldController: _newPasswordController,
                label: "New Password",
                validators: [
                  RequiredValidator(errorText: "New Password is required"),
                  MinLengthValidator(
                    5,
                    errorText: 'New Password should be at least 5 characters.',
                  ),
                ],
                textInputType: TextInputType.text,
                obscureText: true,
              ),
              CustomField(
                textFieldController: _newPasswordAgainController,
                label: "New Password Again",
                validators: [
                  RequiredValidator(
                      errorText: "New Password Again is required"),
                  MinLengthValidator(
                    5,
                    errorText:
                        'New Password Again should be at least 5 characters.',
                  ),
                  ValueValidator(
                    checkAgainstTextController: _newPasswordController,
                    errorText: "New password's do not match.",
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
                          text: 'Update Password',
                          loadingText: 'Updating',
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      : LoadingTextIconButton(
                          connected: false,
                          loading: _loading,
                          onFormSubmit: _onFormSubmit,
                          text: 'Update Password',
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
