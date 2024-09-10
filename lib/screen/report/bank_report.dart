import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/pdf_models/pdf_bank.dart';
import '../../methods/pdf_method.dart';
import '../../providers/contents.dart';
import '../../widgets/search.dart';

class BankReport extends StatefulWidget {
  static const routeName="/bankk";
  const BankReport({Key? key}) : super(key: key);

  @override
  State<BankReport> createState() => _BankReportState();
}

class _BankReportState extends State<BankReport>  with WidgetsBindingObserver{
  // late Box<Bank?> _box;
  bool isSecondSegmentVisible = false;
  Bank? selectedReport;
  int? selectedListTileIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this as WidgetsBindingObserver);
    openBox();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this as WidgetsBindingObserver);
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

  List<Bank?> customDataList =[];
  List<Bank?> itemList =[];
  Future<void> openBox() async {
    // _box = await Hive.openBox<Bank?>('bankBox'); // Call searchUnsold after _box is initialized
    setState(() {
      // customDataList = _box.values.toList();
      // itemList=_box.values.toList();
      customDataList =  Provider.of<Contents>(context,listen: false).bankReceiptdata.toList();
      itemList =  Provider.of<Contents>(context,listen: false).bankReceiptdata.toList();
    });


  }
  void searchChassis(String cNo) {

    String chassisNO = cNo.toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison

    List<Bank?> matchingLCs = customDataList.where((element) => element!.a.chassis.toLowerCase().contains(chassisNO)).toList();
    setState(() {
      if (matchingLCs.isNotEmpty) {
        customDataList = matchingLCs;
      }else{
        customDataList = itemList;
      }
    });
  }
  TextEditingController cNoController = TextEditingController();
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Bank Report"),centerTitle: true,),
      body: Container(
        child: customDataList.isNotEmpty?Container(
          child: width<1200?Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    SearchWidget(cNoController: cNoController, searchChassis: searchChassis),
                    Container(
                      child: Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: width<600?(width<430?2:3):4, // Adjust the number of columns as needed
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 2.0,
                          ),
                          itemCount: customDataList.length,
                          itemBuilder: (context, index) {
                            Bank? customData = customDataList[index];
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
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Vehicle Name: ${customData!.a.name}'),
                                      Text('Chassis No: ${customData!.a.chassis}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isSecondSegmentVisible,
                child: Expanded(child: PdfPreview(
                  build: (format) => bankPdf(selectedReport!.a,t: selectedReport?.intro??"",ac:selectedReport?.ac??"",price: selectedReport?.price??"", bank: selectedReport?.bank??"",bpaid: selectedReport?.bankPay??"",branch: selectedReport?.branch??"",po: selectedReport?.po??"",inWord: selectedReport?.inWord??"",bacode: selectedReport?.bacode??"",currentDate: selectedReport?.currentDate??""),
                )),
              )
            ],
          ):Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    SearchWidget(cNoController: cNoController, searchChassis: searchChassis),
                    Container(
                      child: Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isSecondSegmentVisible?3:6, // Adjust the number of columns as needed
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 2.0,
                          ),
                          itemCount: customDataList.length,
                          itemBuilder: (context, index) {
                            Bank? customData = customDataList[index];
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
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Vehicle Name: ${customData!.a.name}'),
                                      Text('Chassis No: ${customData!.a.chassis}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isSecondSegmentVisible,
                child: Expanded(child: PdfPreview(
                  build: (format) => bankPdf(selectedReport!.a,t: selectedReport?.intro??"",ac:selectedReport?.ac??"",price: selectedReport?.price??"", bank: selectedReport?.bank??"",bpaid: selectedReport?.bankPay??"",branch: selectedReport?.branch??"",po: selectedReport?.po??"",inWord: selectedReport?.inWord??"",bacode: selectedReport?.bacode??"",currentDate: selectedReport?.currentDate??""),
                )),
              )
            ],
          ),
        ):Text("No Data Found"),
      )
      ,
    );
  }
}
