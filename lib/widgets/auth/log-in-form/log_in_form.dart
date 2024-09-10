// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../widgets/text_fields/default_textfield.dart';

class LogInForm extends StatelessWidget {
  LogInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.textButtonClick,
    required this.onChangeEmail,
    required this.onChangePassword,
  });
  TextEditingController emailController, passwordController;
  VoidCallback textButtonClick;
  Function(String) onChangeEmail, onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text Fields
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextfield(
                lebelText: "E-mail",
                hintText: "Enter E-mail",
                width: 400.0,
                onChange: onChangeEmail,
                textEditingController: emailController,
              ),
              const SizedBox(
                height: 15.0,
              ),
              DefaultTextfield(
                lebelText: "Password",
                hintText: "Enter Password",
                width: 400.0,
                onChange: onChangePassword,
                secureText: true,
                textEditingController: passwordController,
              ),
            ],
          ),
          // forgot password text
          const SizedBox(
            height: 15.0,
          ),
          const Text(
            "Forgot Password?",
          ),
          TextButton(
            onPressed: textButtonClick,
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: colorPrimaryS400,
                fontWeight: FontWeight.w500,
                fontFamily: fontRaleway,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
