// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smerp/utils/app_colors.dart';
import 'package:smerp/widgets/text_fields/default_textfield.dart';

class ChassisEntryDialog extends StatelessWidget {
  ChassisEntryDialog({super.key});

  List<String> colOneInputs = [
    "Name",
    "Chassis No",
    "AP/KM",
    "Buying Price",
    "Cost Before Duty",
    "Warf rent",
    "Others",
  ];
  List<String> colTwoInputs = [
    "Color",
    "Engine No",
    "Landing Date",
    "Invoice",
    "Invoice Rate",
    "Invoice BDT",
    "Duty",
    "Total Cost",
    "Selling Price",
  ];
  List<String> colThreeInputs = [
    "Model",
    "CC",
    "VAT",
    "Sold",
    "TT",
    "TT Rate",
    "TT BDT",
    "CNF",
    "Profit/Loss",
  ];

  final List<TextEditingController> colOneTextController =
      List.generate(7, (index) => TextEditingController());

  final List<TextEditingController> colTwoTextController =
      List.generate(9, (index) => TextEditingController());

  final List<TextEditingController> colThreeTextController =
      List.generate(9, (index) => TextEditingController());

  @override
  SimpleDialog build(BuildContext context) {
    return SimpleDialog(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      titlePadding: const EdgeInsets.only(top: 15.0),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: colorPrimaryS400,
        fontSize: 18.0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      title: const Center(
        child: Text(
          "Chassis Entry",
          textAlign: TextAlign.center,
        ),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < colOneInputs.length - 2; i++)
                    DefaultTextfield(
                      controller: colOneTextController[i],
                      hintText: colOneInputs[i],
                      onChange: (val) {},
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: DefaultTextfield(
                          controller:
                              colOneTextController[colOneInputs.length - 2],
                          hintText: colOneInputs[colOneInputs.length - 2],
                          onChange: (val) {},
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: DefaultTextfield(
                          controller:
                              colOneTextController[colOneInputs.length - 1],
                          hintText: colOneInputs[colOneInputs.length - 1],
                          onChange: (val) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < colTwoInputs.length - 2; i++)
                    if (colTwoInputs[i] == "Landing Date")
                      DefaultTextfield(
                        hintText: "Landing Date",
                        onChange: (val) {},
                        useAsButton: true,
                        buttonBgColor: Colors.transparent,
                        buttonForegroundColor: colorPrimaryS300,
                        buttonIcon: Icons.date_range_outlined,
                        buttonText: "Landing Date",
                        onTapButton: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            initialDate: DateTime.now(),
                          );
                        },
                      )
                    else if (colTwoInputs[i] == "Invoice")
                      Row(
                        children: [
                          for (int j = 0; j < 3; j++)
                            if (i + j < colTwoInputs.length)
                              Expanded(
                                child: DefaultTextfield(
                                  hintText: colTwoInputs[i + j],
                                  controller: colTwoTextController[i + j],
                                  onChange: (val) {},
                                ),
                              ),
                        ],
                      )
                    else if (colTwoInputs[i] == "Invoice Rate" ||
                        colTwoInputs[i] == "Invoice BDT")
                      Container()
                    else
                      DefaultTextfield(
                        controller: colTwoTextController[i],
                        hintText: colTwoInputs[i],
                        onChange: (val) {},
                      ),
                  Row(
                    children: [
                      Expanded(
                        child: DefaultTextfield(
                            controller:
                                colTwoTextController[colTwoInputs.length - 2],
                            hintText: colTwoInputs[colTwoInputs.length - 2],
                            onChange: (val) {}),
                      ),
                      Expanded(
                        child: DefaultTextfield(
                            controller:
                                colTwoTextController[colTwoInputs.length - 1],
                            hintText: colTwoInputs[colTwoInputs.length - 1],
                            onChange: (val) {}),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < colThreeInputs.length; i++)
                    if (colThreeInputs[i] == "VAT")
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownMenu(
                                width: 170.0,
                                trailingIcon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                selectedTrailingIcon:
                                    const Icon(Icons.keyboard_arrow_up_rounded),
                                initialSelection: "VAT",
                                dropdownMenuEntries: [
                                  "VAT",
                                  "Not Given",
                                  "Unsold"
                                ].map<DropdownMenuEntry<String>>((any) {
                                  return DropdownMenuEntry(
                                      value: any, label: any);
                                }).toList()),
                            DropdownMenu(
                                width: 170.0,
                                trailingIcon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                selectedTrailingIcon:
                                    const Icon(Icons.keyboard_arrow_up_rounded),
                                initialSelection: "Sold",
                                dropdownMenuEntries: [
                                  "Sold",
                                  "Not Given",
                                  "Unsold"
                                ].map<DropdownMenuEntry<String>>((any) {
                                  return DropdownMenuEntry(
                                      value: any, label: any);
                                }).toList()),
                          ],
                        ),
                      )
                    else if (colThreeInputs[i] == "Sold")
                      Container()
                    else if (colThreeInputs[i] == "TT")
                      Row(
                        children: [
                          for (int j = 0; j < 3; j++)
                            if (i + j < colTwoInputs.length)
                              Expanded(
                                child: DefaultTextfield(
                                  hintText: colThreeInputs[i + j],
                                  controller: colThreeTextController[i + j],
                                  onChange: (val) {},
                                ),
                              ),
                        ],
                      )
                    else if (colThreeInputs[i] == "TT Rate" ||
                        colThreeInputs[i] == "TT BDT")
                      Container()
                    else
                      DefaultTextfield(
                        controller: colThreeTextController[i],
                        hintText: colThreeInputs[i],
                        onChange: (val) {},
                      )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          child: DefaultTextfield(
            hintText: "Remarks",
            onChange: (val) {},
            width: double.maxFinite,
            maxLine: 5,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(
                      150.0,
                      40.0,
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(colorPrimaryS300),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Colors.white,
                  ),
                ),
                onPressed: () {},
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
