import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/credentials/update_credentials.dto.dart';
import 'package:sonic_flutter/dtos/credentials/update_email/update_email.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/services/credentials.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/loading_text_icon_button.widget.dart';

class EmailUpdateTab extends StatefulWidget {
  const EmailUpdateTab({Key? key}) : super(key: key);

  @override
  _EmailUpdateTabState createState() => _EmailUpdateTabState();
}

class _EmailUpdateTabState extends State<EmailUpdateTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final CredentialsService _credentialsService;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _credentialsService =
        Provider.of<CredentialsService>(context, listen: false);

    User user = FirebaseAuth.instance.currentUser!;
    _emailController.text = user.email!;
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the controllers
    _emailController.dispose();
    _passwordController.dispose();
  }

  /*
   * Form submission method for user email address update.
   */
  Future<void> _onFormSubmit() async {
    // Validate the form.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        // Prepare DTO for updating email.
        UpdateCredentialsDto updateCredentialsDto = UpdateEmailDto(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Update it on server.
        await _credentialsService.updateCredentials(updateCredentialsDto);

        setState(() {
          _loading = false;
        });

        // Display success snackbar.
        displaySnackBar("Email Address updated!", context);
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
          'Update Email Widget Error',
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
                textFieldController: _emailController,
                label: "Email Address",
                validators: [
                  RequiredValidator(
                    errorText: "Email Address is required",
                  ),
                  EmailValidator(
                    errorText: "Please enter a valid email address.",
                  ),
                ],
                textInputType: TextInputType.text,
              ),
              CustomField(
                textFieldController: _passwordController,
                label: "Password",
                validators: [
                  RequiredValidator(errorText: "Password is required"),
                  MinLengthValidator(
                    5,
                    errorText: 'Password should be at least 5 characters.',
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
                          text: 'Update Email Address',
                          loadingText: 'Updating',
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      : LoadingTextIconButton(
                          connected: false,
                          loading: _loading,
                          onFormSubmit: _onFormSubmit,
                          text: 'Update Email Address',
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
