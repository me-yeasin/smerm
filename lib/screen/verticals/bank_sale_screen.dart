import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/widgets/formate/bank_formate.dart';
import 'package:smerp/widgets/formate/bill_formate.dart';
import 'package:smerp/widgets/formate/challan_formate.dart';
import 'package:smerp/widgets/formate/customer_reciept.dart';
import 'package:smerp/widgets/formate/qutation_formate.dart';
import 'package:smerp/widgets/search.dart';

import '../../models/chassis_model.dart';
import '../../models/lc_model.dart';
import '../../providers/contents.dart';
import '../home_page.dart';

class QuotationScreen extends StatefulWidget {
  static const routeName ='/quotation';
  const QuotationScreen({Key? key}) : super(key: key);

  @override
  State<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<QuotationScreen> with WidgetsBindingObserver{
  LC? a;
  Chassis? selectedChassis;
  bool isSecondSegmentVisible = false;
  bool isEditable = false;
  List<Chassis> chassisList = [];
  List<Chassis> itemList = [];
  var button = "quotation";
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
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {
      // Open the box when the app is resumed or the user enters the page
      openBox();
    }
  }

  Future<void> openBox() async {
    store();

  }

  void store() {
    List<Chassis> b = [];
    List<LC?> matchingLCs = Provider.of<Contents>(context,listen: false).postdata.toList();
    for (int i = 0; i < matchingLCs.length; i++) {
      List<Chassis> a = matchingLCs[i]!.chassis.toList();
      for (int j = 0; j < a.length; j++) {
        b.add(a[j]);
      }
    }
    setState(() {
      if (b.isNotEmpty) {
        chassisList = b;
        itemList = b;
      }
    });
  }

  void hideSecondSegment() {
    setState(() {
      selectedChassis = null;
      isSecondSegmentVisible = false;
    });
  }

  void searchChassis(String cNo) {
    String chassisNO = cNo.toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison

    List<Chassis> matchingLCs = chassisList.where((element) => element.chassis.toLowerCase().contains(chassisNO)).toList();
    setState(() {
      if (matchingLCs.isNotEmpty) {
        chassisList = matchingLCs;
        hideSecondSegment();
      }else{
        chassisList = itemList;
      }
    });
  }

  TextEditingController cNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: ()async{

        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
              (Route<dynamic> route) => false,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bank Sale"),
          centerTitle: true,
        ),
        body: chassisList.isNotEmpty?Container(
          child: width>1020?Row(
            children: [
              Visibility(
                // visible: !isSecondSegmentVisible,
                child: Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      SearchWidget(cNoController: cNoController, searchChassis: searchChassis),
                      Container(

                        child: Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Adjust the number of columns as needed
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 2.0,
                            ),
                            itemCount: chassisList.length,
                            itemBuilder: (context, index) {
                              final chassis = chassisList[index] as Chassis;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedChassis = chassisList[index];
                                    selectedListTileIndex = index;
                                  });
                                },
                                child: Card(
                                  color: selectedListTileIndex == index ? Colors.amber : null,
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
                                        Text('Chassis NO: ${chassis.chassis}'),
                                        Text('Delivery Date: ${chassis.delivery_date}'),
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
              ),//1st
              Visibility(
                visible: !isSecondSegmentVisible,
                  child: Expanded(child:
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Visibility(
                          child: Container(
                            child: SingleChildScrollView(
                              scrollDirection:Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'bill';
                                      });
                                    },textColor: Colors.white, color: button=="bill"?Colors.amber:Colors.purpleAccent,child: Text("Bill"),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'challan';
                                      });
                                    },textColor: Colors.white, color: button=="challan"?Colors.amber:Colors.purpleAccent,child: Text("Calan"),),
                                  ),//Challan
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'quotation';
                                      });
                                    },textColor: Colors.white, color: button=="quotation"?Colors.amber:Colors.purpleAccent,child: Text("Quotation"),),
                                  ),//Quotation
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'bank';
                                      });
                                    },textColor: Colors.white, color: button=="bank"?Colors.amber:Colors.purpleAccent,child: Text("Bank Receipt"),),
                                  ),//Bank
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'customer';
                                      });
                                    },textColor: Colors.white, color: button=="customer"?Colors.amber:Colors.purpleAccent,child: Text("Customer Receipt"),),
                                  ),//Customer

                                ],),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: button=="customer",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.85,
                            child: CustomerRecieptFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Customer
                        Visibility(
                          visible: button=="quotation",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.85,
                            child: QuotationFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Quotation
                        Visibility(
                          visible: button=="challan",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.85,
                            child: ChallanFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Challan
                        Visibility(
                          visible: button=="bank",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.85,
                            child: BankFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Bank
                        Visibility(
                          visible: button=="bill",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.85,
                            child: BillFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Bill
                      ],
                    ),
                  ))),//2nd
            ],
          )
              :Column(
            children: [
              Visibility(
                // visible: !isSecondSegmentVisible,
                child: Expanded(
                  child: Column(
                    children: [
                      SizedBox(height:5,),
                      SearchWidget(cNoController: cNoController, searchChassis: searchChassis),
                      Container(
                        child: Expanded(
                          flex: 1,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: width<600?(width<430?2:3):4, // Adjust the number of columns as needed
                              mainAxisSpacing: 16.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 2.0,
                            ),
                            itemCount: chassisList.length,
                            itemBuilder: (context, index) {
                              final chassis = chassisList[index] as Chassis;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedChassis = chassisList[index];
                                    selectedListTileIndex = index;
                                  });
                                },
                                child: Card(
                                  color: selectedListTileIndex == index ? Colors.amber : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Chassis NO: ${chassis.chassis}'),
                                          Text('Delivery Date: ${chassis.delivery_date}'),
                                        ],
                                      ),
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
              ),//1st
              Visibility(
                  visible: !isSecondSegmentVisible,
                  child: Expanded(
                    flex: 2,
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Visibility(
                          child: Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'bill';
                                      });
                                    },textColor: Colors.white, color: button=="bill"?Colors.amber:Colors.purpleAccent,child: Text("Bill"),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'challan';
                                      });
                                    },textColor: Colors.white, color: button=="challan"?Colors.amber:Colors.purpleAccent,child: Text("Calan"),),
                                  ),//Challan
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'quotation';
                                      });
                                    },textColor: Colors.white, color: button=="quotation"?Colors.amber:Colors.purpleAccent,child: Text("Quotation"),),
                                  ),//Quotation
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'bank';
                                      });
                                    },textColor: Colors.white, color: button=="bank"?Colors.amber:Colors.purpleAccent,child: Text("Bank Receipt"),),
                                  ),//Bank
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(onPressed: (){
                                      setState(() {
                                        button = 'customer';
                                      });
                                    },textColor: Colors.white, color: button=="customer"?Colors.amber:Colors.purpleAccent,child: Text("Customer Receipt"),),
                                  ),//Customer

                                ],),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: button=="customer",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.80,
                            child: CustomerRecieptFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Customer
                        Visibility(
                          visible: button=="quotation",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.80,
                            child: QuotationFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Quotation
                        Visibility(
                          visible: button=="challan",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.80,
                            child: ChallanFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Challan
                        Visibility(
                          visible: button=="bank",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.80,
                            child: BankFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Bank
                        Visibility(
                          visible: button=="bill",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.80,
                            child: BillFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Bill
                      ],
                    ),
                  ))),//2nd
            ],
          ),
        ):Center(child: Text('No chassis Selected for Quotation')),
      ),
    );
  }
}

