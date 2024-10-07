import 'package:flutter/material.dart';
import 'package:smerp/utils/app_colors.dart';
import 'package:smerp/widgets/text_fields/default_textfield.dart';

class LCDialog extends StatelessWidget {
  const LCDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "LC Name",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorPrimaryS400,
                  ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextfield(
                  width: 300,
                  hintText: "Supplier",
                  onChange: (val) {},
                  lebelText: "Supplier",
                ),
                const SizedBox(
                  width: 15.0,
                ),
                DefaultTextfield(
                  width: 300,
                  hintText: "Port",
                  onChange: (val) {},
                  lebelText: "Port",
                )
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextfield(
                  width: 300,
                  hintText: "IRC",
                  onChange: (val) {},
                  lebelText: "IRC",
                ),
                const SizedBox(
                  width: 15.0,
                ),
                DefaultTextfield(
                  width: 300,
                  hintText: "Bank Name",
                  onChange: (val) {},
                  lebelText: "Bank Name",
                )
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(colorPrimaryS300),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                fixedSize: WidgetStatePropertyAll(Size(140.0, 40.0)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(
                        5.0,
                        5.0,
                      ),
                    ),
                  ),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Save",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
