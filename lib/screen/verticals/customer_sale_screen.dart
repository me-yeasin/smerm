import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smerp/widgets/formate/seal_receipt_customer.dart';
import 'package:smerp/widgets/search.dart';
import '../../models/chassis_model.dart';
import '../../models/lc_model.dart';
import '../../providers/contents.dart';
import '../home_page.dart';

class CustomerSealScreen extends StatefulWidget {
  static const routeName ='/customerSale';
  const CustomerSealScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSealScreen> createState() => _CustomerSealScreenState();
}

class _CustomerSealScreenState extends State<CustomerSealScreen> with WidgetsBindingObserver{
  LC? a;
  // late Box<LC?> _box;
  Chassis? selectedChassis;
  bool isSecondSegmentVisible = false;
  bool isEditable = false;
  List<Chassis> chassisList = [];
  List<Chassis> itemList = [];
  var button = "Customer Receipt";
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

  Future<void> openBox() async {
    // _box = await Hive.openBox<LC?>('mboxo'); // Call searchUnsold after _box is initialized
    store();

  }

  void store() {
    List<Chassis> b = [];
    // List<LC?> matchingLCs = _box.values.toList();
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
          title: Text("Customer Sale"),
          centerTitle: true,
        ),
        body: chassisList.isNotEmpty?
        Container(
          child: width<1020?
          Column(
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
                                      scrollDirection: Axis.vertical,
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
                  child: Expanded(child:
                  SingleChildScrollView(

                    child: Column(
                      children: [
                        Visibility(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(onPressed: (){
                                    setState(() {
                                      button = 'Customer Receipt';
                                    });
                                  },textColor: Colors.white, color: button=="Customer Receipt"?Colors.amber:Colors.purpleAccent,child: Text("Customer Receipt"),),
                                ),
                              ],),
                          ),
                        ),

                        Visibility(
                          visible: button=="Customer Receipt",
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*.84,
                            child: SaleCustomerRecieptFormate(a: selectedChassis??chassisList[0]),
                          ),
                        ),//Customer
                      ],
                    ),
                  ))),//2nd
            ],
          )
              :Row(
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
                  child: Expanded(child: Column(
                    children: [
                      Visibility(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(onPressed: (){
                                  setState(() {
                                    button = 'Customer Receipt';
                                  });
                                },textColor: Colors.white, color: button=="Customer Receipt"?Colors.amber:Colors.purpleAccent,child: Text("Customer Receipt"),),
                              ),
                            ],),
                        ),
                      ),

                      Visibility(
                        visible: button=="Customer Receipt",
                        child: Container(
                          height: MediaQuery.sizeOf(context).height*.84,
                          child: SaleCustomerRecieptFormate(a: selectedChassis??chassisList[0]),
                        ),
                      ),//Customer
                    ],
                  ))),//2nd
            ],
          ),
        )
            :Center(child: Text('No Data Found')),
      ),
    );
  }

}

