import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/credentials/delete_credentials/delete_credentials.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/pages/auth/login.page.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/credentials.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/loading_text_icon_button.widget.dart';

class DeleteAccountTab extends StatefulWidget {
  const DeleteAccountTab({Key? key}) : super(key: key);

  @override
  _DeleteAccountTabState createState() => _DeleteAccountTabState();
}

class _DeleteAccountTabState extends State<DeleteAccountTab> {
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final CredentialsService _credentialsService;

  late final AccountProvider _accountProvider;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _credentialsService =
        Provider.of<CredentialsService>(context, listen: false);
    _accountProvider = Provider.of<AccountProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose off the controller.
    _passwordController.dispose();
  }

  /*
   * Form submission method for user delete.
   */
  Future<void> _onFormSubmit() async {
    // Validate the form.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        DeleteCredentialsDto deleteCredentialsDto = DeleteCredentialsDto(
          password: _passwordController.text,
        );

        // Delete the account from the server.
        await _credentialsService.deleteCredential(deleteCredentialsDto);

        // Clear off the provider state.
        _accountProvider.removeAccount();

        setState(() {
          _loading = false;
        });

        // Log out to the authentication page.
        Navigator.of(context).pushReplacementNamed(Login.route);
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
              Image.asset(
                "assets/img/app-icon.png",
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please note that deleting your account ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'deletes all of your data from Sonic Chat. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            'This action is irreversible and no data is recoverable after deleting your account.',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomField(
                textFieldController: _passwordController,
                label: "Password",
                validators: [
                  RequiredValidator(
                    errorText: "Please enter your password.",
                  ),
                  MinLengthValidator(
                    5,
                    errorText:
                        "Your password should be at least 5 characters long.",
                  )
                ],
                textInputType: TextInputType.visiblePassword,
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
                          text: 'Delete Account',
                          loadingText: 'Deleting',
                          icon: const Icon(
                            Icons.delete,
                          ),
                        )
                      : LoadingTextIconButton(
                          connected: false,
                          loading: _loading,
                          onFormSubmit: _onFormSubmit,
                          text: 'Delete Account',
                          loadingText: 'Deleting',
                          icon: const Icon(
                            Icons.delete,
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
