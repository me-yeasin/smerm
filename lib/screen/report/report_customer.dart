import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../methods/pdf_method.dart';
import '../../models/pdf_models/pdf_cutomer.dart';
import '../../providers/contents.dart';
import '../../widgets/search.dart';

class CustomerReport extends StatefulWidget {
  static const routeName="/reportcustomer";
  const CustomerReport({Key? key}) : super(key: key);

  @override
  State<CustomerReport> createState() => _CustomerReportState();
}

class _CustomerReportState extends State<CustomerReport>  with WidgetsBindingObserver{
  // late Box<Custom?> _box;
  bool isSecondSegmentVisible = false;
  Custom? selectedReport;
  int? selectedListTileIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    openBox();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _box.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Close the box when the app is paused or the user leaves the page
      // _box.close();
    } else if (state == AppLifecycleState.resumed) {
      // Open the box when the app is resumed or the user enters the page
      openBox();
    }
  }

  List<Custom?> customDataList =[];
  List<Custom?> itemList =[];
  Future<void> openBox() async {
    // _box = await Hive.openBox<Custom?>('customBox'); // Call searchUnsold after _box is initialized
    setState(() {
      // customDataList = _box.values.toList();
      // itemList=_box.values.toList();
      customDataList =  Provider.of<Contents>(context,listen: false).customerReceiptdata.toList();
      itemList =  Provider.of<Contents>(context,listen: false).customerReceiptdata.toList();
    });


  }
  void searchChassis(String cNo) {
    String chassisNO = cNo.toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison

    List<Custom?> matchingLCs = customDataList.where((element) => element!.a.chassis.toLowerCase().contains(chassisNO)).toList();
    setState(() {
      if (matchingLCs.isNotEmpty) {
        customDataList = matchingLCs;
      }else{
        customDataList = itemList;
      }
    });
  }
  TextEditingController cNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Customer"),centerTitle: true,),
      body: Container(
        child: customDataList.isNotEmpty?Container(
          child: width<1200?Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    SearchWidget(cNoController: cNoController, searchChassis: searchChassis),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: width<600?(width<430?2:3):4, // Adjust the number of columns as needed
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: customDataList.length,
                        itemBuilder: (context, index) {
                          Custom? customData = customDataList[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedReport = customDataList[index];
                                isSecondSegmentVisible = true;
                                selectedListTileIndex = index;
                              });
                            },
                            child: Card(
                              color: selectedListTileIndex == index ? Colors.amber.shade500 : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Chassis NO: ${customData!.a.name}'),
                                    Text('Delivery Date: ${customData.a.chassis}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isSecondSegmentVisible,
                child: Expanded(child: PdfPreview(
                  build: (format) => customerPdf(selectedReport!.a,name: selectedReport?.name??"",price: selectedReport?.price??"",address: selectedReport?.address??"",phone: selectedReport?.phone??"",cpaid: selectedReport?.customerPay??"",inWord: selectedReport?.inWord??"",cocode: selectedReport?.cocode??"",currentDate:selectedReport?.currentDate??""),
                )),
              )
            ],
          ):Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    SearchWidget(cNoController: cNoController, searchChassis: searchChassis),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isSecondSegmentVisible?3:6, // Adjust the number of columns as needed
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: customDataList.length,
                        itemBuilder: (context, index) {
                          Custom? customData = customDataList[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedReport = customDataList[index];
                                isSecondSegmentVisible = true;
                                selectedListTileIndex = index;
                              });
                            },
                            child: Card(
                              color: selectedListTileIndex == index ? Colors.amber.shade500 : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Chassis NO: ${customData!.a.name}'),
                                    Text('Delivery Date: ${customData.a.chassis}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isSecondSegmentVisible,
                child: Expanded(child: PdfPreview(
                  build: (format) => customerPdf(selectedReport!.a,name: selectedReport?.name??"",price: selectedReport?.price??"",address: selectedReport?.address??"",phone: selectedReport?.phone??"",cpaid: selectedReport?.customerPay??"",inWord: selectedReport?.inWord??"",cocode: selectedReport?.cocode??"",currentDate:selectedReport?.currentDate??""),
                )),
              )
            ],
          ),
        ):const Text("No Data Found"),
      )
      ,
    );
  }
}
