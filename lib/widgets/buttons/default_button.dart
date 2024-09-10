// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({
    super.key,
    required this.buttonText,
    this.icon,
    required this.onTap,
    this.loading = true,
  });
  final String buttonText;
  final IconData? icon;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 14.0,
          ),
        ),
        foregroundColor: const WidgetStatePropertyAll(
          Colors.white,
        ),
        backgroundColor: const WidgetStatePropertyAll(
          colorPrimaryS300,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              3.0,
            ),
          ),
        ),
      ),
      child: loading
          ? const SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Icon(
                  icon,
                  size: 18.0,
                ),
              ],
            ),
    );
  }
}
