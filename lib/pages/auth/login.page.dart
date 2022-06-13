import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:sonic_flutter/dtos/auth/login_account/login_account.dto.dart';
import 'package:sonic_flutter/enum/auth_error.enum.dart';
import 'package:sonic_flutter/enum/general_error.enum.dart';
import 'package:sonic_flutter/exceptions/auth.exception.dart';
import 'package:sonic_flutter/exceptions/general.exception.dart';
import 'package:sonic_flutter/models/account/account.model.dart';
import 'package:sonic_flutter/pages/auth/register.page.dart';
import 'package:sonic_flutter/pages/home.page.dart';
import 'package:sonic_flutter/providers/account.provider.dart';
import 'package:sonic_flutter/services/auth.service.dart';
import 'package:sonic_flutter/utils/display_snackbar.util.dart';
import 'package:sonic_flutter/utils/logger.util.dart';
import 'package:sonic_flutter/widgets/common/custom_field.widget.dart';
import 'package:sonic_flutter/widgets/common/loading_text_icon_button.widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final AuthService _authService;

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _loading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
  }

  Future<void> _onFormSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      LoginAccountDto loginAccountDto = LoginAccountDto(
        password: _passwordController.text,
        username: _usernameController.text,
      );

      Account account = await _authService.loginAccount(loginAccountDto);

      log.i(account.id);

      Provider.of<AccountProvider>(context, listen: false).saveAccount(account);

      Navigator.of(context).pushReplacementNamed(
        Home.route,
      );
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
        'Login Page Error',
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

    _usernameController.dispose();
    _passwordController.dispose();
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
                    'Login to your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.longestSide * 0.04,
                    ),
                  ),
                  Image.asset(
                    "assets/img/app-icon.png",
                    width: MediaQuery.of(context).size.width * 0.4,
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
                  OfflineBuilder(
                    connectivityBuilder: (BuildContext context,
                        ConnectivityResult value, Widget child) {
                      bool connected = value != ConnectivityResult.none;

                      return connected
                          ? LoadingTextIconButton(
                              connected: true,
                              loading: _loading,
                              onFormSubmit: _onFormSubmit,
                              text: 'Login',
                              loadingText: 'Logging In',
                              icon: const Icon(
                                Icons.login,
                              ),
                            )
                          : LoadingTextIconButton(
                              connected: false,
                              loading: _loading,
                              onFormSubmit: _onFormSubmit,
                              text: 'Login',
                              loadingText: 'Logging In',
                              icon: const Icon(
                                Icons.login,
                              ),
                            );
                    },
                    child: const SizedBox(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(Register.route);
                    },
                    child: const Text('Don\'t have an account? Register here!'),
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
