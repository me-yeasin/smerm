// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class HomePageButton extends StatelessWidget {
  HomePageButton({super.key, required this.buttonText, required this.onTap});
  String buttonText;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(
          20.0,
        ),
        shadowColor: const WidgetStatePropertyAll(
          colorPrimaryS100,
        ),
        backgroundColor: const WidgetStatePropertyAll(
          colorPrimaryS300,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              5.0,
            ),
          ),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 45.0,
          vertical: 20.0,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
