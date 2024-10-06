import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/providers/design.dart';
import 'package:smerp/widgets/lc_info-widgets/chassis_entry_dialog.dart';

import '../../utils/app_colors.dart';

class ChassisTable extends StatelessWidget {
  const ChassisTable({super.key});

  @override
  Widget build(BuildContext context) {
    Design designProvider = Provider.of<Design>(context, listen: false);
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
                _chassisItem(),
                _chassisItem(),
                _chassisItem(),
                _chassisItem()
              ],
            ),
          ],
        ),
      ],
    );
  }
}

Widget _chassisItem() {
  return Container(
    margin: const EdgeInsets.only(top: 10.0, right: 10.0),
    padding: const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 7.0,
    ),
    decoration: BoxDecoration(
        color: colorPrimaryS100.withOpacity(0.45),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: colorPrimaryS300)),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text("Total"),
      ],
    ),
  );
}
