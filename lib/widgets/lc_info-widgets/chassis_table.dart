// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/providers/design.dart';
import 'package:smerp/widgets/lc_info-widgets/chassis_entry_dialog.dart';
import 'package:smerp/widgets/text_fields/default_textfield.dart';

import '../../utils/app_colors.dart';

class ChassisTable extends StatelessWidget {
  ChassisTable({super.key});

  List<String> chassisNameColOneInputs = [
    "Chassis",
    "CC",
    "AP/KM",
    "Sold/Unsold",
    "Invoice",
    "Invoice Rate",
    "Invoice BDT",
    "Cost Before Port",
    "CNF",
    "Others",
    "Selling Price",
    "Delivery Date"
  ];
  List<String> chassisNameColTwoInputs = [
    "Engine No",
    "Color",
    "Model",
    "VAT",
    "Buying Price",
    "TT",
    "TT Rate",
    "TT BDT",
    "Duty",
    "Warf Rent",
    "Total",
    "Profit/Loss"
  ];

  @override
  Widget build(BuildContext context) {
    Design designProvider = Provider.of<Design>(context, listen: true);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 11.0,
              ).copyWith(
                right: 70.0,
              ),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5.0)),
              child: const Text(
                "Chassis Lists",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                designProvider.showSimpleDialog(context, ChassisEntryDialog());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 11.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                    color: colorPrimaryS300,
                    borderRadius: BorderRadius.circular(5.0)),
                child: const Text(
                  "Add New +",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                _chassisItem(
                  () => designProvider.selectChassisItem(0),
                  designProvider.chassisItemSelectedBoolList[0],
                ),
                _chassisItem(
                  () => designProvider.selectChassisItem(1),
                  designProvider.chassisItemSelectedBoolList[1],
                ),
                _chassisItem(
                  () => designProvider.selectChassisItem(2),
                  designProvider.chassisItemSelectedBoolList[2],
                ),
                _chassisItem(
                  () => designProvider.selectChassisItem(3),
                  designProvider.chassisItemSelectedBoolList[3],
                )
              ],
            ),
          ],
        ),
        if (designProvider.showChassisNameForm)
          Container(
            margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 40.0,
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        "Chassis Name",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              designProvider.showSimpleDialog(
                                  context, ChassisEntryDialog());
                            },
                            icon: const Icon(
                              Icons.edit_calendar_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: chassisNameColOneInputs
                            .asMap()
                            .entries
                            .map((entries) {
                          String item = entries.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: DefaultTextfield(
                              width: 350.0,
                              hintText: item,
                              onChange: (val) {},
                              lebelText: item,
                            ),
                          );
                        }).toList(),
                      ),
                      Column(
                        children: chassisNameColTwoInputs
                            .asMap()
                            .entries
                            .map((entries) {
                          String item = entries.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: DefaultTextfield(
                              width: 350.0,
                              hintText: item,
                              onChange: (val) {},
                              lebelText: item,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Widget _chassisItem(VoidCallback onTap, bool isSelected) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0, right: 10.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 7.0,
        ),
        decoration: BoxDecoration(
            color: isSelected
                ? Colors.black.withOpacity(0.8)
                : colorPrimaryS100.withOpacity(0.45),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1.0, color: colorPrimaryS300)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? colorPrimaryS200 : Colors.black,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Total",
              style: TextStyle(
                color: isSelected ? colorPrimaryS200 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
