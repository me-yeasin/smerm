// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../widgets/text_fields/default_textfield.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({
    super.key,
    required this.confirmPasswordChangeHandler,
    required this.emailChangeHandler,
    required this.passwordChangeHandler,
    required this.onTextButtonTap,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });
  Function(String) emailChangeHandler,
      passwordChangeHandler,
      confirmPasswordChangeHandler;
  VoidCallback onTextButtonTap;
  TextEditingController emailController,
      passwordController,
      confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DefaultTextfield(
                    hintText: "Enter E-Mail",
                    onChange: emailChangeHandler,
                    lebelText: "E-Mail",
                    width: 400.0,
                    textEditingController: emailController,
                  ),
                  const SizedBox(width: 20.0),
                  DefaultTextfield(
                    hintText: "",
                    onChange: (val) {},
                    lebelText: "Subscription Package",
                    useAsButton: true,
                    onTapButton: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              DefaultTextfield(
                hintText: "Enter Password",
                onChange: passwordChangeHandler,
                lebelText: "Password",
                textEditingController: passwordController,
              ),
              const SizedBox(
                height: 15.0,
              ),
              DefaultTextfield(
                hintText: "Confirm Password",
                onChange: confirmPasswordChangeHandler,
                lebelText: "Confirm Password",
                textEditingController: confirmPasswordController,
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text(
            "Already Have an Account?",
          ),
          TextButton(
            onPressed: onTextButtonTap,
            child: const Text(
              "Sign In",
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
