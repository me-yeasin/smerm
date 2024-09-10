import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/utils/app_colors.dart';
import 'package:smerp/widgets/auth/log-in-form/log_in_form.dart';
import 'package:smerp/widgets/auth/sing-up-form/sign_up_form.dart';
import 'package:smerp/widgets/buttons/default_button.dart';

import '../../models/http_exception.dart';
import '../../providers/auth.dart';
import '../../utils/app_string.dart';

class LogInPage extends StatefulWidget {
  static const routeName = '/login';
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isLoading = false;
  bool _isSignUp = false;
  bool isPassword = false;
  bool reset = false;
  String email = "", password = "", confirmPassword = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occerred'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> logInHandler() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).logIn(email, password);
    } on HttpException catch (err) {
      String errorMessage = "Authentication failed";
      if (err.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (err.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (err.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> signUpHandler() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signUp(email, password);
      setState(() {
        _isSignUp = false;
      });
    } on HttpException catch (err) {
      String errorMessage = "Authentication failed";
      if (err.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (err.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (err.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog("Could not authenticate you. Please try again later.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/login-bg-two.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Text "Auto-Mobile Manager"
            const Text(
              "Auto-Mobile Manager",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w800,
                fontFamily: fontRaleway,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            // Login Form & Car Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Car Image
                SizedBox(
                  height: 450,
                  width: 450,
                  child: Image.asset("assets/images/car-image.png"),
                ),
                SizedBox(
                  width: _isSignUp ? 150.0 : 250.0,
                ),
                // Log In Form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Text "Welcome!"
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontRaleway,
                            color: colorPrimaryS400,
                          ),
                        ),
                        Text(
                          "Sign ${_isSignUp ? "Up" : "In"} to continue",
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontRaleway,
                            color: colorPrimaryS400,
                          ),
                        ),
                      ],
                    ),
                    if (_isSignUp)
                      SignUpForm(
                        emailChangeHandler: (p0) => email = p0,
                        passwordChangeHandler: (p0) => password = p0,
                        confirmPasswordChangeHandler: (p0) =>
                            confirmPassword = p0,
                        onTextButtonTap: () {
                          setState(() {
                            _isSignUp = false;
                          });
                        },
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                      )
                    else
                      LogInForm(
                        onChangeEmail: (val) {
                          email = val;
                        },
                        onChangePassword: (val) {
                          password = val;
                        },
                        emailController: emailController,
                        passwordController: passwordController,
                        textButtonClick: () {
                          setState(() {
                            _isSignUp = true;
                          });
                        },
                      ),
                    // Sign in button
                    const SizedBox(height: 30.0),
                    DefaultButton(
                      buttonText: "Sign ${_isSignUp ? "Up" : "In"}",
                      icon: Icons.keyboard_arrow_right,
                      onTap: _isSignUp ? signUpHandler : logInHandler,
                      loading: _isLoading,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




// Future<void> _reset() async {
//   if (!_formKey.currentState!.validate()) {
//     // Invalid!
//     return;
//   }
//   _formKey.currentState!.save();
//   setState(() {
//     _isLoading = true;
//   });
//   try {
//     await Provider.of<Auth>(context, listen: false).resetPassword(
//       _authData['email']!,
//     );
//   } on HttpException catch (error) {
//     print("http");
//     var errorMessage = 'Reset failed';
//     if (error.toString().contains('MISSING_EMAIL')) {
//       errorMessage = 'This email address is not in use.';
//     } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
//       errorMessage = 'Wrong email address.Pls insert corret one or signup';
//     } else if (error.toString().contains('INVALID_PASSWORD')) {
//       errorMessage = 'Invalid password.';
//     }
//     _showErrorDialog(errorMessage);
//   } catch (error) {
//     const errorMessage = 'Could not reset password. Please try again later.';
//     _showErrorDialog(errorMessage);
//   }
//   setState(() {
//     _isLoading = false;
//   });
// }
