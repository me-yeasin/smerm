import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smerp/screen/home_page.dart';
import 'package:smerp/models/chassis_model.dart';

import '../../models/lc_model.dart';
import '../../providers/contents.dart';

class UnsoldScreen extends StatefulWidget {
  static const routeName = '/unsold';

  const UnsoldScreen({Key? key}) : super(key: key);

  @override
  State<UnsoldScreen> createState() => _UnsoldScreenState();
}

class _UnsoldScreenState extends State<UnsoldScreen>
    with WidgetsBindingObserver {
  LC? a;
  Chassis? selectedChassis;
  bool isSecondSegmentVisible = false;
  bool isEditable = false;
  List<Chassis> chassisList = [];
  List<Chassis> itemList =[];
  DateTime selectedDate = DateTime.now();
  int? selectedListTileIndex;
  List<Map<int,int>> indexlist = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    openBox();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {
      openBox();
    }
  }
  Future<void> openBox() async {
    searchUnsold(); // Call searchUnsold after _box is initialized
  }
  void searchUnsold() {
    List<Chassis> b = [];
    // List<LC?> matchingLCs = _box.values.toList();
    List<LC?> matchingLCs = Provider.of<Contents>(context,listen: false).postdata.toList();
    for (int i = 0; i < matchingLCs.length; i++) {
      List<Chassis> a = matchingLCs[i]!.chassis.toList();
      for (int j = 0; j < a.length; j++) {
        if (a[j].sold == 'Unsold') {
          b.add(a[j]);
          Map<int,int> temp ={};
          temp.clear();
          temp[i]=j;
          indexlist.add(temp);
        }
      }
    }
    print(indexlist);
    setState(() {
      if (b.isNotEmpty) {
        chassisList = b;
        itemList = b;
      }
    });
    store();
  }
  int compareChassis(Chassis a, Chassis b) {
    final letterA = a.name.substring(0, 1).toUpperCase();
    final letterB = b.name.substring(0, 1).toUpperCase();

    // Define the letter hierarchy based on your requirement
    final letterHierarchy = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

    final indexA = letterHierarchy.indexOf(letterA);
    final indexB = letterHierarchy.indexOf(letterB);

    // Compare the indices and return the comparison result
    return indexA.compareTo(indexB);
  }
  void store() {
    setState(() {

      // Create a new list by sorting the chassisList based on the name's first letter hierarchy
      List<Chassis> sortedChassisList = List<Chassis>.from(chassisList);
      sortedChassisList.sort(compareChassis);

      // Assign the sorted list to chassisList
      chassisList = sortedChassisList;
    });
  }
  void showSecondSegment(int index) {
    setState(() {
      selectedChassis = chassisList[index];
      isSecondSegmentVisible = true;
      a = findLCForChassis(selectedChassis!);
      isEditable = false;
    });
  }
  LC? findLCForChassis(Chassis chassis) {
    // List<LC?> matchingLCs = _box.values.toList();
    List<LC?> matchingLCs = Provider.of<Contents>(context,listen: false).postdata.toList();
    for (int i = 0; i < matchingLCs.length; i++) {
      LC? lc = matchingLCs[i];
      if (lc!.chassis.contains(chassis)) {
        return lc;
      }
    }
    return null;
  }
  void hideSecondSegment() {
    setState(() {
      selectedChassis = null;
      isSecondSegmentVisible = false;
    });
  }
  void searchLC(String cNo) {
    String chassisNO = cNo.toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison

    List<Chassis> matchingLCs = chassisNO==''||chassisNO==null?itemList:itemList.where((element) => element.chassis.toLowerCase().contains(chassisNO)).toList();
    setState(() {
      if (matchingLCs.isNotEmpty) {
        chassisList = matchingLCs;
        hideSecondSegment();
      }else{
        chassisList = itemList;
      }
    });
    store();
  }
  void searchCar(String cNo) {
    String chassisNO = cNo.toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison

    List<Chassis> matchingLC = chassisNO==''||chassisNO==null?itemList:itemList.where((element) => element.name.toLowerCase().contains(chassisNO)).toList();
    setState(() {
      if (matchingLC.isNotEmpty) {
        chassisList = matchingLC;
        hideSecondSegment();
      }else if(matchingLC.isEmpty){
        chassisList = itemList;
      }else{
        chassisList = itemList;
      }
    });
    store();
  }

  String selectedSearchOption = 'Chassis No';
  TextEditingController cNoController = TextEditingController();

  void updateTTAmount() {
    setState(() {
      selectedChassis!.ttAmount = selectedChassis!.buyingPrice - selectedChassis!.invoice;
      print('selectedChassis!.ttAmount :'+ selectedChassis!.ttAmount.toString() );
    });
  }
  void updateBeforeDuty() {
    setState(() {
      selectedChassis!.portCost = selectedChassis!.invoiceBdt + selectedChassis!.ttBdt;
      print('selectedChassis!.portCost :'+ selectedChassis!.portCost.toString() );
    });
  }
  void updateTotal() {
    setState(() {
      selectedChassis!.total = selectedChassis!.portCost + selectedChassis!.duty+selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
      print('selectedChassis!.total :'+ selectedChassis!.total.toString() );
    });
  }
  void updateInvoice() {
    setState(() {
      selectedChassis!.invoiceBdt = selectedChassis!.invoice*selectedChassis!.invoiceRate;
      print('selectedChassis!.invoiceBdt :'+ selectedChassis!.invoiceBdt.toString() );
    });
  }
  void updateTT() {
    setState(() {
      selectedChassis!.ttBdt = selectedChassis!.ttAmount*selectedChassis!.ttRate;
      print('selectedChassis!.ttBdt :'+ selectedChassis!.ttBdt.toString() );
    });
  }
  void updatelossProfit() {
    setState(() {
      selectedChassis!.profit = selectedChassis!.sellingPrice - selectedChassis!.total;
      print('selectedChassis!.profit :'+ selectedChassis!.profit.toString() );
    });
  }
  void updateAll(){
    setState(() {
      updateTTAmount();
      updateBeforeDuty();
      updateTotal();
      updateInvoice();
      updateTT();
      updatelossProfit();
      print('2');
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    Contents lcedit = Provider.of<Contents>(context);

    return WillPopScope(
      onWillPop: ()async{
        // Navigator.of(context).pushNamed(HomePage.routeName);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
              (Route<dynamic> route) => false,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Unsold Chassis'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight / 2),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:Container(
              margin: const EdgeInsets.only(left: 8),
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width / 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: selectedSearchOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSearchOption = newValue!;
                        });
                      },
                      items: <String>['Vehicle Name', 'Chassis No'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: cNoController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          suffixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                        onChanged: (value) {
                          selectedSearchOption=="Vehicle Name"?searchCar(value):searchLC(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
              ),
            ),
          ),
        ),
        body: chassisList.isNotEmpty? w<900?Column(
          children: [
            Expanded(
              flex: 1,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: w<600?(w<430?2:3):4, // Adjust the number of columns as needed
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 2.0,
                ),
                itemCount: chassisList.length,
                itemBuilder: (context, index) {
                  final chassis = chassisList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        showSecondSegment(index);
                        selectedListTileIndex = index;
                      },
                      child: Card(
                        color: selectedListTileIndex == index ? Colors.amber.shade500 : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  chassis.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              AutoSizeText(
                                'Total: ${chassis.total.toString()}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isSecondSegmentVisible)
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: hideSecondSegment,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    'Name: ${selectedChassis!.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: (){
                                        setState(() {
                                          isEditable = !isEditable;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.save),
                                      onPressed: (){
                                        lcedit.editChassis(selectedChassis!, lcedit.postkey[indexlist[selectedListTileIndex!].keys.elementAt(0)], lcedit.keystore.values.elementAt(indexlist[selectedListTileIndex!].keys.elementAt(0))[indexlist[selectedListTileIndex!].values.elementAt(0)]);
                                        setState(() {
                                          isEditable = false;
                                          hideSecondSegment();
                                          openBox();
                                        });
                                      },
                                    ),

                                  ],
                                )
                              ],
                            ),
                            isEditable&&w<420?SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 12,
                                columns: const [
                                  DataColumn(label: Text('Field')),
                                  DataColumn(label: Text('Value')),
                                  DataColumn(label: Text('Field')),
                                  DataColumn(label: Text('Value')),
                                ],
                                rows: [
                                  DataRow(cells: [
                                    const DataCell(Text('Chassis')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.chassis,
                                          onChanged: (newValue) {
                                            selectedChassis!.chassis = newValue;
                                          },
                                        )
                                            :Text(selectedChassis!.chassis)),
                                    const DataCell(Text('Engine No')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.engineNo,
                                          onChanged: (newValue) {
                                            selectedChassis!.engineNo = newValue;
                                          },
                                        )
                                            :Text(selectedChassis!.engineNo)),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('CC')),
                                    DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.cc,
                                        onChanged: (newValue) {
                                          selectedChassis!.cc = newValue;
                                        },
                                      )
                                          : Text(selectedChassis!.cc),
                                    ),
                                    const DataCell(Text('Color')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.color,
                                          onChanged: (newValue) {
                                            selectedChassis!.color = newValue;
                                          },
                                        )
                                            :Text(selectedChassis!.color)),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('AP/KM')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.km,
                                          onChanged: (newValue) {
                                            selectedChassis!.km = newValue;
                                          },
                                        )
                                            :Text(selectedChassis!.km)),
                                    const DataCell(Text('Model')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.model,
                                          onChanged: (newValue) {
                                            selectedChassis!.model = newValue;
                                          },
                                        )
                                            :Text(selectedChassis!.model)),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Sold/Unsold')),
                                    DataCell(
                                        isEditable
                                            ? DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: selectedChassis!.sold,
                                          onChanged: (String? newValue) { // Update the function signature
                                            if (newValue != null) {
                                              setState(() {
                                                selectedChassis!.sold = newValue;// Perform actions based on the selected value
                                              });
                                            }
                                          },
                                          items: <String>['Sold', 'Unsold','Booked'].map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                            :Text(selectedChassis!.sold)),
                                    const DataCell(Text('VAT')),
                                    DataCell(
                                        isEditable
                                            ? DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: selectedChassis!.vat,
                                          onChanged: (String? newValue) { // Update the function signature
                                            if (newValue != null) {
                                              setState(() {
                                                selectedChassis!.vat = newValue; // Perform actions based on the selected value
                                              });
                                            }
                                          },
                                          items: <String>['Given', 'Not Given'].map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                            :Text(selectedChassis!.vat)),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Delivery date')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.delivery_date.toString(),
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(onPressed: ()async{
                                                final DateTime? picked = await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100),
                                                );

                                                if (picked != null && picked != selectedDate) {
                                                  setState(() {
                                                    selectedDate = picked;
                                                    var d = DateFormat('yyyy-MM-dd').format(selectedDate);
                                                    selectedChassis!.delivery_date = d.toString();
                                                  });
                                                }
                                              }, icon: const Icon(Icons.date_range))
                                          ),
                                        ):Text(selectedChassis!.delivery_date.toString())),
                                    const DataCell(Text('Buying Price')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.buyingPrice.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.buyingPrice = double.parse(newValue);
                                            selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                            updateAll();
                                          },
                                        ):Text(selectedChassis!.buyingPrice.toString())),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Invoice')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.invoice.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.invoice = double.parse(newValue);
                                            selectedChassis!.ttAmount = selectedChassis!.buyingPrice - selectedChassis!.invoice;
                                            updateAll();
                                          },

                                        ):Text(selectedChassis!.invoice.toString())),
                                    const DataCell(Text('TT')),
                                    DataCell(Text(selectedChassis!.ttAmount.toString())),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Invoice Rate')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.invoiceRate.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.invoiceRate = double.parse(newValue);
                                            selectedChassis!.invoiceBdt = selectedChassis!.invoiceRate * selectedChassis!.invoice;
                                            updateAll();
                                          },

                                        ):Text(selectedChassis!.invoiceRate.toString())),
                                    const DataCell(Text('TT Rate')),
                                    DataCell( isEditable
                                        ? TextFormField(
                                      initialValue: selectedChassis!.ttRate.toString(),
                                      onChanged: (newValue) {
                                        selectedChassis!.ttRate = double.parse(newValue);
                                        selectedChassis!.ttBdt = selectedChassis!.ttAmount* selectedChassis!.ttRate;
                                        updateAll();
                                      },
                                    ):Text(selectedChassis!.ttRate.toString())),

                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Invoice BDT')),
                                    DataCell(Text(selectedChassis!.invoiceBdt.toString())),
                                    const DataCell(Text('TT BDT')),
                                    DataCell(Text(selectedChassis!.ttBdt.toString())),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Cost before Port')),
                                    DataCell(Text(selectedChassis!.portCost.toString())),
                                    const DataCell(Text('Duty')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.duty.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.duty = double.parse(newValue);
                                            selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                            updateAll();
                                          },
                                        ):Text(selectedChassis!.duty.toString())),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('CNF')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.cnf.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.cnf = double.parse(newValue);
                                            selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                            updateAll();
                                          },
                                        ):Text(selectedChassis!.cnf.toString())),
                                    const DataCell(Text('Warfrent')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.warfrent.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.warfrent = double.parse(newValue);
                                            selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                            updateAll();
                                          },
                                        ):Text(selectedChassis!.warfrent.toString())),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Others')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.others.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.others = double.parse(newValue);
                                            selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                            updateAll();
                                          },
                                        ):Text(selectedChassis!.others.toString())),
                                    const DataCell(Text('Total')),
                                    DataCell(Text(selectedChassis!.total.toString())),
                                  ]),
                                  DataRow(cells: [
                                    const DataCell(Text('Selling Price')),
                                    DataCell(
                                        isEditable
                                            ? TextFormField(
                                          initialValue: selectedChassis!.sellingPrice.toString(),
                                          onChanged: (newValue) {
                                            selectedChassis!.sellingPrice = double.parse(newValue);
                                            updateAll();
                                          },
                                        ):Text(selectedChassis!.sellingPrice.toString())),
                                    const DataCell(Text('Profit')),
                                    DataCell(Text(selectedChassis!.profit.toString())),
                                  ]),
                                ],
                              ),
                            ):DataTable(
                              columnSpacing: 12,
                              columns: const [
                                DataColumn(label: Text('Field')),
                                DataColumn(label: Text('Value')),
                                DataColumn(label: Text('Field')),
                                DataColumn(label: Text('Value')),
                              ],
                              rows: [
                                DataRow(cells: [
                                  const DataCell(Text('Chassis')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.chassis,
                                        onChanged: (newValue) {
                                          selectedChassis!.chassis = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.chassis)),
                                  const DataCell(Text('Engine No')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.engineNo,
                                        onChanged: (newValue) {
                                          selectedChassis!.engineNo = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.engineNo)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('CC')),
                                  DataCell(
                                    isEditable
                                        ? TextFormField(
                                      initialValue: selectedChassis!.cc,
                                      onChanged: (newValue) {
                                        selectedChassis!.cc = newValue;
                                      },
                                    )
                                        : Text(selectedChassis!.cc),
                                  ),
                                  const DataCell(Text('Color')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.color,
                                        onChanged: (newValue) {
                                          selectedChassis!.color = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.color)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('AP/KM')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.km,
                                        onChanged: (newValue) {
                                          selectedChassis!.km = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.km)),
                                  const DataCell(Text('Model')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.model,
                                        onChanged: (newValue) {
                                          selectedChassis!.model = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.model)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Sold/Unsold')),
                                  DataCell(
                                      isEditable
                                          ? DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        value: selectedChassis!.sold,
                                        onChanged: (String? newValue) { // Update the function signature
                                          if (newValue != null) {
                                            setState(() {
                                              selectedChassis!.sold = newValue;// Perform actions based on the selected value
                                            });
                                          }
                                        },
                                        items: <String>['Sold', 'Unsold','Booked'].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )
                                          :Text(selectedChassis!.sold)),
                                  const DataCell(Text('VAT')),
                                  DataCell(
                                      isEditable
                                          ? DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        value: selectedChassis!.vat,
                                        onChanged: (String? newValue) { // Update the function signature
                                          if (newValue != null) {
                                            setState(() {
                                              selectedChassis!.vat = newValue; // Perform actions based on the selected value
                                            });
                                          }
                                        },
                                        items: <String>['Given', 'Not Given'].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )
                                          :Text(selectedChassis!.vat)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Delivery date')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.delivery_date.toString(),
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(onPressed: ()async{
                                              final DateTime? picked = await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );

                                              if (picked != null && picked != selectedDate) {
                                                setState(() {
                                                  selectedDate = picked;
                                                  var d = DateFormat('yyyy-MM-dd').format(selectedDate);
                                                  selectedChassis!.delivery_date = d.toString();
                                                });
                                              }
                                            }, icon: const Icon(Icons.date_range))
                                        ),
                                      ):Text(selectedChassis!.delivery_date.toString())),
                                  const DataCell(Text('Buying Price')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.buyingPrice.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.buyingPrice = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                        },
                                      ):Text(selectedChassis!.buyingPrice.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Invoice')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.invoice.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.invoice = double.parse(newValue);
                                          selectedChassis!.ttAmount = selectedChassis!.buyingPrice - selectedChassis!.invoice;
                                          updateAll();
                                        },

                                      ):Text(selectedChassis!.invoice.toString())),
                                  const DataCell(Text('TT')),
                                  DataCell(Text(selectedChassis!.ttAmount.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Invoice Rate')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.invoiceRate.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.invoiceRate = double.parse(newValue);
                                          selectedChassis!.invoiceBdt = selectedChassis!.invoiceRate * selectedChassis!.invoice;
                                          updateAll();
                                        },

                                      ):Text(selectedChassis!.invoiceRate.toString())),
                                  const DataCell(Text('TT Rate')),
                                  DataCell( isEditable
                                      ? TextFormField(
                                    initialValue: selectedChassis!.ttRate.toString(),
                                    onChanged: (newValue) {
                                      selectedChassis!.ttRate = double.parse(newValue);
                                      selectedChassis!.ttBdt = selectedChassis!.ttAmount* selectedChassis!.ttRate;
                                      updateAll();
                                    },
                                  ):Text(selectedChassis!.ttRate.toString())),

                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Invoice BDT')),
                                  DataCell(Text(selectedChassis!.invoiceBdt.toString())),
                                  const DataCell(Text('TT BDT')),
                                  DataCell(Text(selectedChassis!.ttBdt.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Cost before Port')),
                                  DataCell(Text(selectedChassis!.portCost.toString())),
                                  const DataCell(Text('Duty')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.duty.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.duty = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                        },
                                      ):Text(selectedChassis!.duty.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('CNF')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.cnf.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.cnf = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                        },
                                      ):Text(selectedChassis!.cnf.toString())),
                                  const DataCell(Text('Warfrent')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.warfrent.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.warfrent = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                        },
                                      ):Text(selectedChassis!.warfrent.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Others')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.others.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.others = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                        },
                                      ):Text(selectedChassis!.others.toString())),
                                  const DataCell(Text('Total')),
                                  DataCell(Text(selectedChassis!.total.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Selling Price')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.sellingPrice.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.sellingPrice = double.parse(newValue);
                                          updateAll();
                                        },
                                      ):Text(selectedChassis!.sellingPrice.toString())),
                                  const DataCell(Text('Profit')),
                                  DataCell(Text(selectedChassis!.profit.toString())),
                                ]),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
                              child: isEditable?TextFormField(
                                initialValue: selectedChassis!.remark,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  hintText: "Enter Others cost details",
                                  labelText: "Remarks",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String value) {
                                  selectedChassis!.remark = value;
                                },
                              ):Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(selectedChassis!.remark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ):
        Row(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: isSecondSegmentVisible
                      ? 1 * (w / 1336)
                      : 2.50 * ((w / 1336)),
                ),
                itemCount: chassisList.length,
                itemBuilder: (context, index) {
                  final chassis = chassisList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        showSecondSegment(index);
                        selectedListTileIndex = index;
                      },
                      child: Card(
                        color: selectedListTileIndex == index ? Colors.amber.shade500 : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  chassis.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              AutoSizeText(
                                'Total: ${chassis.total.toString()}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isSecondSegmentVisible)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16,),
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: hideSecondSegment,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    'Name: ${selectedChassis!.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: (){
                                        setState(() {
                                          isEditable = !isEditable;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.save),
                                      onPressed: (){
                                        lcedit.editChassis(selectedChassis!, lcedit.postkey[indexlist[selectedListTileIndex!].keys.elementAt(0)], lcedit.keystore.values.elementAt(indexlist[selectedListTileIndex!].keys.elementAt(0))[indexlist[selectedListTileIndex!].values.elementAt(0)]);
                                        setState(() {
                                          isEditable = false;
                                          hideSecondSegment();
                                          openBox();
                                        });
                                      },
                                    ),

                                  ],
                                )
                              ],
                            ),
                            DataTable(
                              columnSpacing: isEditable?12:55,
                              columns: const [
                                DataColumn(label: Text('Field')),
                                DataColumn(label: Text('Value')),
                                DataColumn(label: Text('Field')),
                                DataColumn(label: Text('Value')),
                              ],
                              rows: [
                                DataRow(cells: [
                                  const DataCell(Text('Chassis')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.chassis,
                                        onChanged: (newValue) {
                                          selectedChassis!.chassis = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.chassis)),
                                  const DataCell(Text('Engine No')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.engineNo,
                                        onChanged: (newValue) {
                                          selectedChassis!.engineNo = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.engineNo)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('CC')),
                                  DataCell(
                                    isEditable
                                        ? TextFormField(
                                      initialValue: selectedChassis!.cc,
                                      onChanged: (newValue) {
                                        selectedChassis!.cc = newValue;
                                      },
                                    )
                                        : Text(selectedChassis!.cc),
                                  ),
                                  const DataCell(Text('Color')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.color,
                                        onChanged: (newValue) {
                                          selectedChassis!.color = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.color)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('AP/KM')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.km,
                                        onChanged: (newValue) {
                                          selectedChassis!.km = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.km)),
                                  const DataCell(Text('Model')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.model,
                                        onChanged: (newValue) {
                                          selectedChassis!.model = newValue;
                                        },
                                      )
                                          :Text(selectedChassis!.model)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Sold/Unsold')),
                                  DataCell(
                                      isEditable
                                          ? DropdownButtonFormField<String>(
                                        value: selectedChassis!.sold,
                                        onChanged: (String? newValue) { // Update the function signature
                                          if (newValue != null) {
                                            setState(() {
                                              selectedChassis!.sold = newValue;// Perform actions based on the selected value
                                            });
                                          }
                                        },
                                        items: <String>['Sold', 'Unsold','Booked'].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )
                                          :Text(selectedChassis!.sold)),
                                  const DataCell(Text('VAT')),
                                  DataCell(
                                      isEditable
                                          ? DropdownButtonFormField<String>(
                                        value: selectedChassis!.vat,
                                        onChanged: (String? newValue) { // Update the function signature
                                          if (newValue != null) {
                                            setState(() {
                                              selectedChassis!.vat = newValue; // Perform actions based on the selected value
                                            });
                                          }
                                        },
                                        items: <String>['Given', 'Not Given'].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )
                                          :Text(selectedChassis!.vat)),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Delivery date')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.delivery_date.toString(),
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(onPressed: ()async{
                                              final DateTime? picked = await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );

                                              if (picked != null && picked != selectedDate) {
                                                setState(() {
                                                  selectedDate = picked;
                                                  var d = DateFormat('yyyy-MM-dd').format(selectedDate);
                                                  selectedChassis!.delivery_date = d.toString();
                                                });
                                              }
                                            }, icon: const Icon(Icons.date_range))
                                        ),
                                      ):Text(selectedChassis!.delivery_date.toString())),
                                  const DataCell(Text('Buying Price')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.buyingPrice.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.buyingPrice = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                          },
                                      ):Text(selectedChassis!.buyingPrice.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Invoice')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.invoice.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.invoice = double.parse(newValue);
                                          selectedChassis!.ttAmount = selectedChassis!.buyingPrice - selectedChassis!.invoice;
                                        updateAll();
                                          },

                                      ):Text(selectedChassis!.invoice.toString())),
                                  const DataCell(Text('TT')),
                                  DataCell(Text(selectedChassis!.ttAmount.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Invoice Rate')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.invoiceRate.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.invoiceRate = double.parse(newValue);
                                          selectedChassis!.invoiceBdt = selectedChassis!.invoiceRate * selectedChassis!.invoice;
                                          updateAll();
                                          },

                                      ):Text(selectedChassis!.invoiceRate.toString())),
                                  const DataCell(Text('TT Rate')),
                                  DataCell( isEditable
                                      ? TextFormField(
                                    initialValue: selectedChassis!.ttRate.toString(),
                                    onChanged: (newValue) {
                                      selectedChassis!.ttRate = double.parse(newValue);
                                      selectedChassis!.ttBdt = selectedChassis!.ttAmount* selectedChassis!.ttRate;
                                      updateAll();
                                    },
                                  ):Text(selectedChassis!.ttRate.toString())),

                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Invoice BDT')),
                                  DataCell(Text(selectedChassis!.invoiceBdt.toString())),
                                  const DataCell(Text('TT BDT')),
                                  DataCell(Text(selectedChassis!.ttBdt.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Cost before Port')),
                                  DataCell(Text(selectedChassis!.portCost.toString())),
                                  const DataCell(Text('Duty')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.duty.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.duty = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                          },
                                      ):Text(selectedChassis!.duty.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('CNF')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.cnf.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.cnf = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                          },
                                      ):Text(selectedChassis!.cnf.toString())),
                                  const DataCell(Text('Warfrent')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.warfrent.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.warfrent = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                          },
                                      ):Text(selectedChassis!.warfrent.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Others')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.others.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.others = double.parse(newValue);
                                          selectedChassis!.total = selectedChassis!.buyingPrice + selectedChassis!.portCost + selectedChassis!.duty + selectedChassis!.cnf+selectedChassis!.warfrent+selectedChassis!.others;
                                          updateAll();
                                          },
                                      ):Text(selectedChassis!.others.toString())),
                                  const DataCell(Text('Total')),
                                  DataCell(Text(selectedChassis!.total.toString())),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Selling Price')),
                                  DataCell(
                                      isEditable
                                          ? TextFormField(
                                        initialValue: selectedChassis!.sellingPrice.toString(),
                                        onChanged: (newValue) {
                                          selectedChassis!.sellingPrice = double.parse(newValue);
                                           updateAll();
                                        },
                                      ):Text(selectedChassis!.sellingPrice.toString())),
                                  const DataCell(Text('Profit')),
                                  DataCell(Text(selectedChassis!.profit.toString())),
                                ]),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
                              child: isEditable?TextFormField(
                                initialValue: selectedChassis!.remark,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  hintText: "Enter Others cost details",
                                  labelText: "Remarks",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String value) {
                                  selectedChassis!.remark = value;
                                },
                              ):Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(selectedChassis!.remark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ):const Center(child: Text("No Data Found")),
      ),
    );
  }
}