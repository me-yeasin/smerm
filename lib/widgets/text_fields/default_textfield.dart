// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_string.dart';

class DefaultTextfield extends StatelessWidget {
  const DefaultTextfield({
    super.key,
    required this.hintText,
    this.lebelText,
    this.width = 500,
    required this.onChange,
    this.secureText,
    this.textEditingController,
    this.useAsButton = false,
    this.onTapButton,
    this.suffixIcon,
    this.controller,
    this.buttonBgColor,
    this.buttonForegroundColor,
    this.buttonPadding,
    this.buttonIcon,
    this.buttonText,
    this.maxLine,
  });
  final String hintText;
  final String? lebelText, buttonText;
  final double width;
  final Function(String) onChange;
  final bool? secureText;
  final TextEditingController? textEditingController;
  final bool? useAsButton;
  final VoidCallback? onTapButton;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final Color? buttonBgColor, buttonForegroundColor;
  final double? buttonPadding;
  final IconData? buttonIcon;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lebelText != null)
          Text(
            lebelText!,
            style: const TextStyle(
              fontSize: 16.0,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        const SizedBox(
          height: 5.0,
        ),
        if (!useAsButton!)
          SizedBox(
            width: width,
            child: TextField(
              maxLines: maxLine,
              controller: controller,
              obscureText: secureText ?? false,
              obscuringCharacter: "x",
              onChanged: onChange,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                fontFamily: fontRaleway,
              ),
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                hintText: hintText,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
                hintStyle: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: colorPrimaryS300,
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        5.0,
                      ),
                    ),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    )),
              ),
            ),
          )
        else
          ElevatedButton(
            style: ButtonStyle(
              overlayColor:
                  WidgetStatePropertyAll(colorPrimaryS100.withOpacity(0.35)),
              shadowColor: const WidgetStatePropertyAll(Colors.transparent),
              alignment: Alignment.center,
              foregroundColor: WidgetStatePropertyAll(
                buttonForegroundColor,
              ),
              backgroundColor: WidgetStatePropertyAll(
                buttonBgColor,
              ),
              minimumSize: const WidgetStatePropertyAll(
                Size(
                  180.0,
                  50.0,
                ),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                  side: const BorderSide(
                    width: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: buttonPadding ?? 10.0,
                ),
              ),
            ),
            onPressed: onTapButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  buttonText ?? "Button",
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Icon(
                  buttonIcon,
                  size: 18.0,
                )
              ],
            ),
          ),
      ],
    );
  }
}
