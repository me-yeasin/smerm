// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/providers/design.dart';

import '../../widgets/buttons/home_page_button.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  List buttonList = [
    "LC Info",
    "Bank Sale",
    "Customer Sale",
    "Unsold Items List",
    "VAT Not Given List",
    "Booked Chasis List",
    "Report",
  ];

  @override
  Widget build(BuildContext context) {
    Design design = Provider.of<Design>(context, listen: false);
    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 50.0,
        runSpacing: 50.0,
        children: buttonList
            .map(
              (e) => HomePageButton(
                buttonText: e,
                onTap: () {
                  design.setIsHomePage = false;
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
