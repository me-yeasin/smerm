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
  });
  final String hintText;
  final String? lebelText;
  final double width;
  final Function(String) onChange;
  final bool? secureText;
  final TextEditingController? textEditingController;
  final bool? useAsButton;
  final VoidCallback? onTapButton;

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
              obscureText: secureText ?? false,
              obscuringCharacter: "x",
              onChanged: onChange,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                fontFamily: fontRaleway,
              ),
              decoration: InputDecoration(
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
                    width: 1.0,
                    strokeAlign: BorderSide.strokeAlignInside,
                    color: colorPrimaryS400,
                  ),
                ),
              ),
            ),
          )
        else
          ElevatedButton(
            style: ButtonStyle(
              alignment: Alignment.center,
              foregroundColor: const WidgetStatePropertyAll(
                Colors.white,
              ),
              backgroundColor: const WidgetStatePropertyAll(
                Colors.black,
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
                ),
              ),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.zero,
              ),
            ),
            onPressed: onTapButton,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "More Details",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18.0,
                )
              ],
            ),
          ),
      ],
    );
  }
}
