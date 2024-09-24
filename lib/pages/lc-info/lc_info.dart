// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/providers/design.dart';
import 'package:smerp/utils/app_colors.dart';
import 'package:smerp/widgets/lc_info-widgets/chassis_table.dart';
import 'package:smerp/widgets/lc_info-widgets/lc_table.dart';
import 'package:smerp/widgets/text_fields/default_textfield.dart';

class LcInfoPage extends StatelessWidget {
  LcInfoPage({super.key});

  final List lcItemList = [0, 1, 2, 3, 4, 5, 6, 8, 5];
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final designProvider = Provider.of<Design>(context);
    Size screenSize = MediaQuery.of(context).size;
    double subAppBarHeight = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          globalKey.currentContext!.findRenderObject() as RenderBox;
      subAppBarHeight = renderBox.size.height;
    });

    double bodySize = screenSize.height -
        (designProvider.getAppBarHeight + subAppBarHeight + 101.0);

    return Column(
      children: [
        // Top Bar
        Container(
          key: globalKey,
          margin: const EdgeInsets.only(
            top: 30.0,
            left: 50.0,
            right: 50.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (!designProvider.getIsLcDetailPage) {
                    designProvider.setIsHomePage = true;
                    return;
                  }
                  designProvider.setIsLcDetailPage = false;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 7.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_rounded,
                        size: 18.0,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(designProvider.getIsLcDetailPage ? "Back" : "Home")
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 150.0),
                child: const Text(
                  "LC Info",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: colorPrimaryS400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DefaultTextfield(
                hintText: "Search",
                onChange: (e) {},
                width: 300,
                suffixIcon: const Icon(Icons.search),
              )
            ],
          ),
        ),

        // Body Content
        !designProvider.getIsLcDetailPage
            ? Flexible(
                child: SizedBox(
                  width: 450,
                  child: ListView(
                    children: lcItemList.map((lcItem) {
                      return LcItem(onTap: () {
                        designProvider.setIsLcDetailPage = true;
                      });
                    }).toList(),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0)
                    .copyWith(top: 20.0),
                child: Row(
                  children: [
                    Container(
                      width: screenSize.width * 0.25,
                      height: bodySize,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: ListView(
                        children: [
                          LcItem(onTap: () {}),
                          LcItem(onTap: () {}),
                          LcItem(onTap: () {}),
                          LcItem(onTap: () {}),
                          LcItem(onTap: () {}),
                          LcItem(onTap: () {}),
                          LcItem(onTap: () {}),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                    SizedBox(
                      width: screenSize.width * (0.75 - 0.15),
                      height: bodySize,
                      child: const SingleChildScrollView(
                        child: Column(
                          children: [
                            LcTable(),
                            SizedBox(
                              height: 50.0,
                            ),
                            ChassisTable(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
      ],
    );
  }
}

class LcItem extends StatelessWidget {
  LcItem({super.key, required this.onTap, this.width});

  VoidCallback onTap;
  double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: colorPrimaryS300,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "LC Name",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
