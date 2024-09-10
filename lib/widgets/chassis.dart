import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/chassis_model.dart';
import '../models/lc_model.dart';

class ChassisWidget extends StatefulWidget {
  bool isSecondSegmentVisible=false;
  double w = 0;
  List chassisList =[];
  Chassis? selectedChassis;
  LC? a;
  ChassisWidget({
    Key? key,
    required this.isSecondSegmentVisible,
    required this.a,
    required this.selectedChassis,
    required this.chassisList,
    required this.w
  }) : super(key: key);

  @override
  State<ChassisWidget> createState() => _ChassisWidgetState();
}

class _ChassisWidgetState extends State<ChassisWidget> {

  void showSecondSegment(int index) {
    setState(() {
      widget.selectedChassis = widget.a!.chassis.elementAt(index) as Chassis;
      widget.isSecondSegmentVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: widget.isSecondSegmentVisible?1*(widget.w/1336):3.0*((widget.w/1336)),
        ),

        // itemCount: _chassisBox.length,
        itemCount: widget.chassisList.length,
        itemBuilder: (context, index) {
          // final chassis = _chassisBox.getAt(index);
          final chassis = widget.chassisList[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      chassis!.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    AutoSizeText(
                      'Total: ${chassis.total.toString()}',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
