import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smerp/lc/chasis_entry.dart';
import 'package:smerp/lc/lc_entey.dart';
import 'package:smerp/providers/contents.dart';
import 'package:smerp/screen/home_page.dart';

import '../models/chassis_model.dart';
import '../models/lc_model.dart';

class LcReportScreen extends StatefulWidget {
  static const routeName = '/Lc report';

  const LcReportScreen({super.key});

  @override
  State<LcReportScreen> createState() => _LcReportScreenState();
}

class _LcReportScreenState extends State<LcReportScreen>
    with WidgetsBindingObserver {
  TextEditingController lcNoController = TextEditingController();

  Chassis? selectedChassis;
  List<dynamic> lcList = [];
  List<LC> remotelcList = [];
  late List<bool> tappedList;
  late List<bool> remotetappedList;
  bool isEditable = false;
  bool isLCEditable = false;
  bool isSecondSegmentVisible = false;
  bool isThirdSegmentVisible = false;
  late Map<int, LC?> selectedLcMap; // Map to store selected LC for each index
  late Map<int, LC?> remoteselectedLcMap;
  int? tapLCIndex;
  int? selectedListTileIndex;
  int? tappedChassisIndex;
  bool isHovered = false;
  DateTime selectedDate = DateTime.now();

  ShapeBorder a = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );

  ShapeBorder b = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );

  double t = 0.5; // Interpolation value between 0.0 and 1.0

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    openBox();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Close the box when the app is paused or the user leaves the page
    } else if (state == AppLifecycleState.resumed) {
      // Open the box when the app is resumed or the user enters the page
      openBox();
      print("Changed");
    }
  }

  Future<void> openBox() async {
    remoteStore();
  }

  void remoteStore() {
    setState(() {
      lcList = Provider.of<Contents>(context, listen: false).postdata;
      tappedList = List<bool>.filled(lcList.length, false);
      selectedLcMap = {}; // Initialize the selected LC map
    });
  }

  void searchLC(String lc) {
    hideThirdSegment();
    String lcNo = lc
        .toLowerCase(); // Convert the search text to lowercase for case-insensitive comparison
    List matchingLCs = Provider.of<Contents>(context, listen: false)
        .postdata
        .where((lc) => lc.lcNo.toLowerCase().contains(lcNo))
        .toList();
    setState(() {
      if (matchingLCs.isNotEmpty) {
        selectedLcMap.clear();
        lcList = matchingLCs;
        selectedListTileIndex = null;
      }
    });
  }

  void showThirdSegment(int index) {
    setState(() {
      final lc = lcList[tapLCIndex!] as LC;
      selectedChassis = lc.chassis.elementAt(index);
      isThirdSegmentVisible = true;
    });
  }

  void hideThirdSegment() {
    setState(() {
      selectedChassis = null;
      isThirdSegmentVisible = false;
    });
  }

  double LcAmount(int index) {
    double lcAmount = 0;
    if (selectedLcMap[index]?.chassis != null) {
      for (int i = 0; i < selectedLcMap[index]!.chassis.length; i++) {
        lcAmount +=
            double.parse(selectedLcMap[index]!.chassis[i].total.toString());
      }
    }
    return lcAmount;
  }

  double LcProfit(int index) {
    double lcAmount = 0;
    if (selectedLcMap[index]?.chassis != null) {
      for (int i = 0; i < selectedLcMap[index]!.chassis.length; i++) {
        lcAmount +=
            double.parse(selectedLcMap[index]!.chassis[i].profit.toString());
      }
    }
    return lcAmount;
  }

  void updateTTAmount() {
    setState(() {
      selectedChassis!.ttAmount =
          selectedChassis!.buyingPrice - selectedChassis!.invoice;
      print('selectedChassis!.ttAmount :${selectedChassis!.ttAmount}');
    });
  }

  void updateBeforeDuty() {
    setState(() {
      selectedChassis!.portCost =
          selectedChassis!.invoiceBdt + selectedChassis!.ttBdt;
      print('selectedChassis!.portCost :${selectedChassis!.portCost}');
    });
  }

  void updateTotal() {
    setState(() {
      selectedChassis!.total = selectedChassis!.portCost +
          selectedChassis!.duty +
          selectedChassis!.cnf +
          selectedChassis!.warfrent +
          selectedChassis!.others;
      print('selectedChassis!.total :${selectedChassis!.total}');
    });
  }

  void updateInvoice() {
    setState(() {
      selectedChassis!.invoiceBdt =
          selectedChassis!.invoice * selectedChassis!.invoiceRate;
      print('selectedChassis!.invoiceBdt :${selectedChassis!.invoiceBdt}');
    });
  }

  void updateTT() {
    setState(() {
      selectedChassis!.ttBdt =
          selectedChassis!.ttAmount * selectedChassis!.ttRate;
      print('selectedChassis!.ttBdt :${selectedChassis!.ttBdt}');
    });
  }

  void updatelossProfit() {
    setState(() {
      selectedChassis!.profit =
          selectedChassis!.sellingPrice - selectedChassis!.total;
      print('selectedChassis!.profit :${selectedChassis!.profit}');
    });
  }

  void updateAll() {
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
    Contents lcedit = Provider.of<Contents>(context);
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Navigator.of(context).pushNamed(HomePage.routeName);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
          (Route<dynamic> route) => false,
        );
        return true;
      },
      child: width < 930
          ? Scaffold(
              appBar: AppBar(
                title: const Text('LC Report'),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight / 2),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        height: (MediaQuery.of(context).size.height / 20),
                        width: (MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width / 10)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: lcNoController,
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              suffixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            onChanged: (value) {
                              searchLC(value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: lcList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: isSecondSegmentVisible
                              ? (isThirdSegmentVisible ? 2 : 1)
                              : 2,
                          child: ListView.builder(
                            itemCount: lcList.length,
                            scrollDirection: isSecondSegmentVisible
                                ? Axis.horizontal
                                : Axis.vertical,
                            itemBuilder: (context, index) {
                              final lc = lcList[index] as LC;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedLcMap.containsValue(lc)) {
                                      selectedLcMap.removeWhere(
                                          (key, value) => value == lc);
                                    } else {
                                      selectedLcMap.clear();
                                      tappedChassisIndex = null;
                                    }
                                    // checker = null;

                                    selectedListTileIndex = index;
                                    Provider.of<Contents>(context,
                                            listen: false)
                                        .updateCurrentRootKey(
                                            selectedListTileIndex.toString());
                                    tappedList[index] = true;
                                    tapLCIndex = selectedListTileIndex;
                                    selectedLcMap[index] = lc;
                                    isSecondSegmentVisible = true;
                                    hideThirdSegment();
                                  });
                                },
                                child: Container(
                                  height: 100,
                                  width: 320,
                                  padding: isSecondSegmentVisible
                                      ? const EdgeInsets.all(8)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Set your desired border radius
                                      side: const BorderSide(
                                          width: 2,
                                          color: Colors
                                              .black), // Set your desired border side
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('LC NO: ${lc.lcNo}'),
                                              content: const Text(
                                                  'Are you sure you want to delete this LC?'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Delete'),
                                                  onPressed: () {
                                                    lcedit.deletePost(lc,
                                                        lcedit.postkey[index]);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            HomePage.routeName);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    title: Text('LC NO: ${lc.lcNo}'),
                                    subtitle: Text('Date: ${lc.date}'),
                                    tileColor: selectedListTileIndex == index
                                        ? Colors.amber
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Visibility(
                          visible: isSecondSegmentVisible,
                          child: Expanded(
                            flex: width < 500 ? 4 : 3,
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'LC NO: ${selectedLcMap[tapLCIndex]?.lcNo ?? ""}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        isThirdSegmentVisible
                                            ? IconButton(
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_up),
                                                onPressed: () {
                                                  setState(() {
                                                    isSecondSegmentVisible =
                                                        !isSecondSegmentVisible;
                                                  });
                                                },
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedListTileIndex =
                                                        null;
                                                    isSecondSegmentVisible =
                                                        false;
                                                    hideThirdSegment();
                                                  });
                                                },
                                              ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                setState(() {
                                                  isLCEditable = true;
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.save),
                                              onPressed: () {
                                                setState(() {
                                                  isLCEditable = false;
                                                });
                                                lcedit.editLcSupplier(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                                lcedit.editLcIrc(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                                lcedit.editLcBank(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                                lcedit.editLcShipment(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columnSpacing: 4,
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Loss/Profit')),
                                              DataColumn(label: Text('Amount')),
                                              DataColumn(
                                                  label: Text('Supplier')),
                                              DataColumn(label: Text('Port')),
                                              DataColumn(label: Text('IRC')),
                                              DataColumn(label: Text('Bank')),
                                            ],
                                            rows: [
                                              DataRow(cells: [
                                                DataCell(Text(
                                                    LcProfit(tapLCIndex ?? 0)
                                                        .toString())),
                                                DataCell(Text(
                                                    LcAmount(tapLCIndex ?? 0)
                                                        .toString())),
                                                DataCell(isLCEditable
                                                    ? TextFormField(
                                                        initialValue:
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.supplier,
                                                        onChanged: (newValue) {
                                                          // lcedit.keystore.values.elementAt(tapLCIndex!)[tappedChassisIndex!]
                                                          selectedLcMap[
                                                                      tapLCIndex]
                                                                  ?.supplier =
                                                              newValue;
                                                          // box.put(lcList[tapLCIndex!].key, lcList[tapLCIndex!]);
                                                        },
                                                      )
                                                    : Text(selectedLcMap[
                                                                tapLCIndex]
                                                            ?.supplier ??
                                                        "")),
                                                DataCell(isLCEditable
                                                    ? TextFormField(
                                                        initialValue:
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.shipment,
                                                        onChanged: (newValue) {
                                                          selectedLcMap[
                                                                      tapLCIndex]
                                                                  ?.shipment =
                                                              newValue;
                                                          // box.put(lcList[tapLCIndex!].key, lcList[tapLCIndex!]);
                                                        },
                                                      )
                                                    : Text(selectedLcMap[
                                                                tapLCIndex]
                                                            ?.shipment ??
                                                        "")),
                                                DataCell(isLCEditable
                                                    ? TextFormField(
                                                        initialValue:
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.irc,
                                                        onChanged: (newValue) {
                                                          selectedLcMap[
                                                                  tapLCIndex]
                                                              ?.irc = newValue;
                                                          // box.put(lcList[tapLCIndex!].key, lcList[tapLCIndex!]);
                                                        },
                                                      )
                                                    : Text(selectedLcMap[
                                                                tapLCIndex]
                                                            ?.irc ??
                                                        "")),
                                                DataCell(isLCEditable
                                                    ? TextFormField(
                                                        initialValue:
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.bank,
                                                        onChanged: (newValue) {
                                                          selectedLcMap[
                                                                  tapLCIndex]
                                                              ?.bank = newValue;
                                                          // box.put(lcList[tapLCIndex!].key, lcList[tapLCIndex!]);
                                                        },
                                                      )
                                                    : Text(selectedLcMap[
                                                                tapLCIndex]
                                                            ?.bank ??
                                                        "")),
                                              ])
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(2),
                                          color: Colors.grey[200],
                                          child: SingleChildScrollView(
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    3, // Adjust the number of columns as needed
                                                mainAxisSpacing: 10.0,
                                                crossAxisSpacing: 10.0,
                                                childAspectRatio: 2.0,
                                              ),
                                              itemCount: (selectedLcMap[
                                                              tapLCIndex]
                                                          ?.chassis
                                                          .length ??
                                                      0) +
                                                  1, // Add 1 for the first item
                                              itemBuilder:
                                                  (context, gridIndex) {
                                                if (gridIndex == 0) {
                                                  // Return the box with add icon for the first item
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              ChasisEntry
                                                                  .routeName,
                                                              arguments: [
                                                            tapLCIndex as int,
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.lcAmount,
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.profit
                                                          ]);
                                                    },
                                                    child: Card(
                                                      elevation: 4,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        side: BorderSide(
                                                            width: 2,
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      color: Colors
                                                          .white, // Customize the color for the box
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons
                                                              .add, // Replace with your add icon
                                                          size: 40,
                                                          color: Colors
                                                              .grey, // Customize the color for the add icon
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  final chassis = selectedLcMap[
                                                              tapLCIndex]
                                                          ?.chassis[
                                                      gridIndex -
                                                          1]; // Subtract 1 to account for the first item
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tappedChassisIndex =
                                                            gridIndex -
                                                                1; // Subtract 1 to account for the first item
                                                        isHovered = true;
                                                      });
                                                      showThirdSegment(gridIndex -
                                                          1); // Subtract 1 to account for the first item
                                                    },
                                                    child: Card(
                                                      elevation: 4,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        side: BorderSide(
                                                            width: 2,
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      color:
                                                          tappedChassisIndex ==
                                                                  gridIndex - 1
                                                              ? Colors.amber
                                                              : Colors.white,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          gradient:
                                                              tappedChassisIndex ==
                                                                      gridIndex -
                                                                          1
                                                                  ? LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .amber
                                                                            .shade400,
                                                                        Colors
                                                                            .amber
                                                                            .shade600
                                                                      ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                    )
                                                                  : null,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            2),
                                                                child:
                                                                    AutoSizeText(
                                                                  chassis?.name ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            2),
                                                                child:
                                                                    AutoSizeText(
                                                                  'Total: ${chassis?.total.toString() ?? ''}',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: isThirdSegmentVisible == true &&
                                isSecondSegmentVisible == false,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () {
                                  setState(() {
                                    isSecondSegmentVisible =
                                        !isSecondSegmentVisible;
                                  });
                                },
                              ),
                            )),
                        if (isThirdSegmentVisible && tappedChassisIndex != null)
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              color: Colors.grey[200],
                              child: SingleChildScrollView(
                                child: Card(
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: hideThirdSegment,
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
                                                onPressed: () {
                                                  setState(() {
                                                    isEditable = !isEditable;
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.save),
                                                onPressed: () {
                                                  setState(() {
                                                    isEditable = false;
                                                  });
                                                  lcedit.editChassis(
                                                      selectedChassis!,
                                                      lcedit
                                                          .postkey[tapLCIndex!],
                                                      lcedit.keystore.values
                                                              .elementAt(
                                                                  tapLCIndex!)[
                                                          tappedChassisIndex!]);
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columnSpacing: isEditable ? 12 : 16,
                                          columns: const [
                                            DataColumn(label: Text('Field')),
                                            DataColumn(label: Text('Value')),
                                            DataColumn(label: Text('Field')),
                                            DataColumn(label: Text('Value')),
                                          ],
                                          rows: [
                                            DataRow(cells: [
                                              const DataCell(Text('Chassis')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .chassis,
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                            .chassis = newValue;
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .chassis)),
                                              const DataCell(Text('Engine No')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .engineNo,
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .engineNo =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .engineNo)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('CC')),
                                              DataCell(
                                                isEditable
                                                    ? TextFormField(
                                                        initialValue:
                                                            selectedChassis!.cc,
                                                        onChanged: (newValue) {
                                                          selectedChassis!.cc =
                                                              newValue;
                                                        },
                                                      )
                                                    : Text(selectedChassis!.cc),
                                              ),
                                              const DataCell(Text('Color')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .color,
                                                      onChanged: (newValue) {
                                                        selectedChassis!.color =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(
                                                      selectedChassis!.color)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('AP/KM')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!.km,
                                                      onChanged: (newValue) {
                                                        selectedChassis!.km =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(selectedChassis!.km)),
                                              const DataCell(Text('Model')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .model,
                                                      onChanged: (newValue) {
                                                        selectedChassis!.model =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(
                                                      selectedChassis!.model)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Sold/Unsold')),
                                              DataCell(isEditable
                                                  ? DropdownButtonFormField<
                                                      String>(
                                                      value:
                                                          selectedChassis!.sold,
                                                      onChanged:
                                                          (String? newValue) {
                                                        // Update the function signature
                                                        if (newValue != null) {
                                                          setState(() {
                                                            selectedChassis!
                                                                    .sold =
                                                                newValue; // Perform actions based on the selected value
                                                          });
                                                        }
                                                      },
                                                      items: <String>[
                                                        'Sold',
                                                        'Unsold',
                                                        'Booked'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    )
                                                  : Text(
                                                      selectedChassis!.sold)),
                                              const DataCell(Text('VAT')),
                                              DataCell(isEditable
                                                  ? DropdownButtonFormField<
                                                      String>(
                                                      value:
                                                          selectedChassis!.vat,
                                                      onChanged:
                                                          (String? newValue) {
                                                        // Update the function signature
                                                        if (newValue != null) {
                                                          setState(() {
                                                            selectedChassis!
                                                                    .vat =
                                                                newValue; // Perform actions based on the selected value
                                                          });
                                                        }
                                                      },
                                                      items: <String>[
                                                        'Given',
                                                        'Not Given'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    )
                                                  : Text(selectedChassis!.vat)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Delivery date')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .delivery_date
                                                              .toString(),
                                                      decoration:
                                                          InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        final DateTime?
                                                                            picked =
                                                                            await showDatePicker(
                                                                          context:
                                                                              context,
                                                                          initialDate:
                                                                              selectedDate,
                                                                          firstDate:
                                                                              DateTime(2000),
                                                                          lastDate:
                                                                              DateTime(2100),
                                                                        );

                                                                        if (picked !=
                                                                                null &&
                                                                            picked !=
                                                                                selectedDate) {
                                                                          setState(
                                                                              () {
                                                                            selectedDate =
                                                                                picked;
                                                                            var d =
                                                                                DateFormat('yyyy-MM-dd').format(selectedDate);
                                                                            selectedChassis!.delivery_date =
                                                                                d.toString();
                                                                          });
                                                                        }
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .date_range))),
                                                    )
                                                  : Text(selectedChassis!
                                                      .delivery_date
                                                      .toString())),
                                              const DataCell(
                                                  Text('Buying Price')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .buyingPrice
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .buyingPrice =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .buyingPrice
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('Invoice')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .invoice
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .invoice =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!
                                                                .ttAmount =
                                                            selectedChassis!
                                                                    .buyingPrice -
                                                                selectedChassis!
                                                                    .invoice;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .invoice
                                                      .toString())),
                                              const DataCell(Text('TT')),
                                              DataCell(Text(selectedChassis!
                                                  .ttAmount
                                                  .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Invoice Rate')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .invoiceRate
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .invoiceRate =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!
                                                                .invoiceBdt =
                                                            selectedChassis!
                                                                    .invoiceRate *
                                                                selectedChassis!
                                                                    .invoice;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .invoiceRate
                                                      .toString())),
                                              const DataCell(Text('TT Rate')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .ttRate
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .ttRate =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.ttBdt =
                                                            selectedChassis!
                                                                    .ttAmount *
                                                                selectedChassis!
                                                                    .ttRate;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.ttRate
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Invoice BDT')),
                                              DataCell(Text(selectedChassis!
                                                  .invoiceBdt
                                                  .toString())),
                                              const DataCell(Text('TT BDT')),
                                              DataCell(Text(selectedChassis!
                                                  .ttBdt
                                                  .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Cost before Port')),
                                              DataCell(Text(selectedChassis!
                                                  .portCost
                                                  .toString())),
                                              const DataCell(Text('Duty')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!.duty
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!.duty =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.duty
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('CNF')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!.cnf
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!.cnf =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.cnf
                                                      .toString())),
                                              const DataCell(Text('Warfrent')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .warfrent
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .warfrent =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .warfrent
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('Others')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .others
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .others =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.others
                                                      .toString())),
                                              const DataCell(Text('Total')),
                                              DataCell(Text(selectedChassis!
                                                  .total
                                                  .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Selling Price')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .sellingPrice
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .sellingPrice =
                                                            double.parse(
                                                                newValue);
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .sellingPrice
                                                      .toString())),
                                              const DataCell(Text('Profit')),
                                              DataCell(Text(selectedChassis!
                                                  .profit
                                                  .toString())),
                                            ]),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20),
                                        child: isEditable
                                            ? TextFormField(
                                                initialValue:
                                                    selectedChassis!.remark,
                                                maxLines: 4,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      "Enter Others cost details",
                                                  labelText: "Remarks",
                                                  border: OutlineInputBorder(),
                                                ),
                                                onChanged: (String value) {
                                                  selectedChassis!.remark =
                                                      value;
                                                },
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                    selectedChassis!.remark),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: Text("No Lc Data found"),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LcEntry.routeName);
                },
                backgroundColor: Colors.amber,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: const Text('LC Report'),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight / 2),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        height: (MediaQuery.of(context).size.height / 20),
                        width: (MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width / 10)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: lcNoController,
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              suffixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            onChanged: (value) {
                              searchLC(value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: lcList.isNotEmpty
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: isThirdSegmentVisible ? 2 : 1,
                          child: ListView.builder(
                            itemCount: lcList.length,
                            itemBuilder: (context, index) {
                              final lc = lcList[index] as LC;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedLcMap.containsValue(lc)) {
                                      selectedLcMap.removeWhere(
                                          (key, value) => value == lc);
                                    } else {
                                      selectedLcMap.clear();
                                      tappedChassisIndex = null;
                                    }
                                    // checker = null;

                                    selectedListTileIndex = index;
                                    Provider.of<Contents>(context,
                                            listen: false)
                                        .updateCurrentRootKey(
                                            selectedListTileIndex.toString());
                                    tappedList[index] = true;
                                    tapLCIndex = selectedListTileIndex;
                                    selectedLcMap[index] = lc;
                                    isSecondSegmentVisible = true;
                                    hideThirdSegment();
                                  });
                                },
                                child: Padding(
                                  padding: isSecondSegmentVisible
                                      ? const EdgeInsets.all(8)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 400, vertical: 20),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Set your desired border radius
                                      side: const BorderSide(
                                          width: 2,
                                          color: Colors
                                              .black), // Set your desired border side
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('LC NO: ${lc.lcNo}'),
                                              content: const Text(
                                                  'Are you sure you want to delete this LC?'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Delete'),
                                                  onPressed: () {
                                                    lcedit.deletePost(lc,
                                                        lcedit.postkey[index]);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            HomePage.routeName);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    title: Text('LC NO: ${lc.lcNo}'),
                                    subtitle: Text('Date: ${lc.date}'),
                                    tileColor: selectedListTileIndex == index
                                        ? Colors.amber
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Visibility(
                          visible: isSecondSegmentVisible,
                          child: Expanded(
                            flex: isThirdSegmentVisible ? 4 : 1,
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'LC NO: ${selectedLcMap[tapLCIndex]?.lcNo ?? ""}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            setState(() {
                                              selectedListTileIndex = null;
                                              isSecondSegmentVisible = false;
                                              hideThirdSegment();
                                            });
                                          },
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                setState(() {
                                                  isLCEditable = true;
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.save),
                                              onPressed: () {
                                                setState(() {
                                                  isLCEditable = false;
                                                });
                                                lcedit.editLcSupplier(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                                lcedit.editLcIrc(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                                lcedit.editLcBank(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                                lcedit.editLcShipment(
                                                  selectedLcMap[tapLCIndex]!,
                                                  lcedit.postkey[tapLCIndex!],
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: DataTable(
                                          columnSpacing: 14,
                                          columns: const [
                                            DataColumn(
                                                label: Text('Loss/Profit')),
                                            DataColumn(label: Text('Amount')),
                                            DataColumn(label: Text('Supplier')),
                                            DataColumn(label: Text('Port')),
                                            DataColumn(label: Text('IRC')),
                                            DataColumn(label: Text('Bank')),
                                          ],
                                          rows: [
                                            DataRow(cells: [
                                              DataCell(Text(
                                                  LcProfit(tapLCIndex ?? 0)
                                                      .toString())),
                                              DataCell(Text(
                                                  LcAmount(tapLCIndex ?? 0)
                                                      .toString())),
                                              DataCell(isLCEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedLcMap[
                                                                  tapLCIndex]
                                                              ?.supplier,
                                                      onChanged: (newValue) {
                                                        selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.supplier =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(
                                                      selectedLcMap[tapLCIndex]
                                                              ?.supplier ??
                                                          "")),
                                              DataCell(isLCEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedLcMap[
                                                                  tapLCIndex]
                                                              ?.shipment,
                                                      onChanged: (newValue) {
                                                        selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.shipment =
                                                            newValue;
                                                        // box.put(lcList[tapLCIndex!].key, lcList[tapLCIndex!]);
                                                      },
                                                    )
                                                  : Text(
                                                      selectedLcMap[tapLCIndex]
                                                              ?.shipment ??
                                                          "")),
                                              DataCell(isLCEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedLcMap[
                                                                  tapLCIndex]
                                                              ?.irc,
                                                      onChanged: (newValue) {
                                                        selectedLcMap[
                                                                tapLCIndex]
                                                            ?.irc = newValue;
                                                        // box.put(lcList[tapLCIndex!].key, lcList[tapLCIndex!]);
                                                      },
                                                    )
                                                  : Text(
                                                      selectedLcMap[tapLCIndex]
                                                              ?.irc ??
                                                          "")),
                                              DataCell(isLCEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedLcMap[
                                                                  tapLCIndex]
                                                              ?.bank,
                                                      onChanged: (newValue) {
                                                        selectedLcMap[
                                                                tapLCIndex]
                                                            ?.bank = newValue;
                                                      },
                                                    )
                                                  : Text(
                                                      selectedLcMap[tapLCIndex]
                                                              ?.bank ??
                                                          "")),
                                            ])
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(16),
                                          color: Colors.grey[200],
                                          child: SingleChildScrollView(
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    isThirdSegmentVisible
                                                        ? 3
                                                        : 5,
                                                childAspectRatio:
                                                    isThirdSegmentVisible
                                                        ? 1.7
                                                        : 1,
                                              ),
                                              itemCount: (selectedLcMap[
                                                              tapLCIndex]
                                                          ?.chassis
                                                          .length ??
                                                      0) +
                                                  1, // Add 1 for the first item
                                              itemBuilder:
                                                  (context, gridIndex) {
                                                if (gridIndex == 0) {
                                                  // Return the box with add icon for the first item
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              ChasisEntry
                                                                  .routeName,
                                                              arguments: [
                                                            tapLCIndex as int,
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.lcAmount,
                                                            selectedLcMap[
                                                                    tapLCIndex]
                                                                ?.profit
                                                          ]);
                                                    },
                                                    child: Card(
                                                      elevation: 4,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        side: BorderSide(
                                                            width: 2,
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      color: Colors
                                                          .white, // Customize the color for the box
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons
                                                              .add, // Replace with your add icon
                                                          size: 40,
                                                          color: Colors
                                                              .grey, // Customize the color for the add icon
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  final chassis = selectedLcMap[
                                                              tapLCIndex]
                                                          ?.chassis[
                                                      gridIndex -
                                                          1]; // Subtract 1 to account for the first item
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tappedChassisIndex =
                                                            gridIndex -
                                                                1; // Subtract 1 to account for the first item
                                                        isHovered = true;
                                                      });
                                                      showThirdSegment(gridIndex -
                                                          1); // Subtract 1 to account for the first item
                                                    },
                                                    child: Card(
                                                      elevation: 4,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        side: BorderSide(
                                                            width: 2,
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      color:
                                                          tappedChassisIndex ==
                                                                  gridIndex - 1
                                                              ? Colors.amber
                                                              : Colors.white,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          gradient:
                                                              tappedChassisIndex ==
                                                                      gridIndex -
                                                                          1
                                                                  ? LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .amber
                                                                            .shade400,
                                                                        Colors
                                                                            .amber
                                                                            .shade600
                                                                      ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                    )
                                                                  : null,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                chassis?.name ??
                                                                    '',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  AutoSizeText(
                                                                'Total: ${chassis?.total.toString() ?? ''}',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isThirdSegmentVisible && tappedChassisIndex != null)
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.grey[200],
                              child: SingleChildScrollView(
                                child: Card(
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: hideThirdSegment,
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
                                                onPressed: () {
                                                  setState(() {
                                                    isEditable = !isEditable;
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.save),
                                                onPressed: () {
                                                  setState(() {
                                                    isEditable = false;
                                                  });
                                                  lcedit.editChassis(
                                                      selectedChassis!,
                                                      lcedit
                                                          .postkey[tapLCIndex!],
                                                      lcedit.keystore.values
                                                              .elementAt(
                                                                  tapLCIndex!)[
                                                          tappedChassisIndex!]);
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columnSpacing: isEditable ? 12 : 55,
                                          columns: const [
                                            DataColumn(label: Text('Field')),
                                            DataColumn(label: Text('Value')),
                                            DataColumn(label: Text('Field')),
                                            DataColumn(label: Text('Value')),
                                          ],
                                          rows: [
                                            DataRow(cells: [
                                              const DataCell(Text('Chassis')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .chassis,
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                            .chassis = newValue;
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .chassis)),
                                              const DataCell(Text('Engine No')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .engineNo,
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .engineNo =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .engineNo)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('CC')),
                                              DataCell(
                                                isEditable
                                                    ? TextFormField(
                                                        initialValue:
                                                            selectedChassis!.cc,
                                                        onChanged: (newValue) {
                                                          selectedChassis!.cc =
                                                              newValue;
                                                        },
                                                      )
                                                    : Text(selectedChassis!.cc),
                                              ),
                                              const DataCell(Text('Color')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .color,
                                                      onChanged: (newValue) {
                                                        selectedChassis!.color =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(
                                                      selectedChassis!.color)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('AP/KM')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!.km,
                                                      onChanged: (newValue) {
                                                        selectedChassis!.km =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(selectedChassis!.km)),
                                              const DataCell(Text('Model')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .model,
                                                      onChanged: (newValue) {
                                                        selectedChassis!.model =
                                                            newValue;
                                                      },
                                                    )
                                                  : Text(
                                                      selectedChassis!.model)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Sold/Unsold')),
                                              DataCell(isEditable
                                                  ? DropdownButtonFormField<
                                                      String>(
                                                      value:
                                                          selectedChassis!.sold,
                                                      onChanged:
                                                          (String? newValue) {
                                                        // Update the function signature
                                                        if (newValue != null) {
                                                          setState(() {
                                                            selectedChassis!
                                                                    .sold =
                                                                newValue; // Perform actions based on the selected value
                                                          });
                                                        }
                                                      },
                                                      items: <String>[
                                                        'Sold',
                                                        'Unsold',
                                                        'Booked'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    )
                                                  : Text(
                                                      selectedChassis!.sold)),
                                              const DataCell(Text('VAT')),
                                              DataCell(isEditable
                                                  ? DropdownButtonFormField<
                                                      String>(
                                                      value:
                                                          selectedChassis!.vat,
                                                      onChanged:
                                                          (String? newValue) {
                                                        // Update the function signature
                                                        if (newValue != null) {
                                                          setState(() {
                                                            selectedChassis!
                                                                    .vat =
                                                                newValue; // Perform actions based on the selected value
                                                          });
                                                        }
                                                      },
                                                      items: <String>[
                                                        'Given',
                                                        'Not Given'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    )
                                                  : Text(selectedChassis!.vat)),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Delivery date')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .delivery_date
                                                              .toString(),
                                                      decoration:
                                                          InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        final DateTime?
                                                                            picked =
                                                                            await showDatePicker(
                                                                          context:
                                                                              context,
                                                                          initialDate:
                                                                              selectedDate,
                                                                          firstDate:
                                                                              DateTime(2000),
                                                                          lastDate:
                                                                              DateTime(2100),
                                                                        );

                                                                        if (picked !=
                                                                                null &&
                                                                            picked !=
                                                                                selectedDate) {
                                                                          setState(
                                                                              () {
                                                                            selectedDate =
                                                                                picked;
                                                                            var d =
                                                                                DateFormat('yyyy-MM-dd').format(selectedDate);
                                                                            selectedChassis!.delivery_date =
                                                                                d.toString();
                                                                          });
                                                                        }
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .date_range))),
                                                    )
                                                  : Text(selectedChassis!
                                                      .delivery_date
                                                      .toString())),
                                              const DataCell(
                                                  Text('Buying Price')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .buyingPrice
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .buyingPrice =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .buyingPrice
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('Invoice')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .invoice
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .invoice =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!
                                                                .ttAmount =
                                                            selectedChassis!
                                                                    .buyingPrice -
                                                                selectedChassis!
                                                                    .invoice;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .invoice
                                                      .toString())),
                                              const DataCell(Text('TT')),
                                              DataCell(Text(selectedChassis!
                                                  .ttAmount
                                                  .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Invoice Rate')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .invoiceRate
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .invoiceRate =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!
                                                                .invoiceBdt =
                                                            selectedChassis!
                                                                    .invoiceRate *
                                                                selectedChassis!
                                                                    .invoice;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .invoiceRate
                                                      .toString())),
                                              const DataCell(Text('TT Rate')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .ttRate
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .ttRate =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.ttBdt =
                                                            selectedChassis!
                                                                    .ttAmount *
                                                                selectedChassis!
                                                                    .ttRate;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.ttRate
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Invoice BDT')),
                                              DataCell(Text(selectedChassis!
                                                  .invoiceBdt
                                                  .toString())),
                                              const DataCell(Text('TT BDT')),
                                              DataCell(Text(selectedChassis!
                                                  .ttBdt
                                                  .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Cost before Port')),
                                              DataCell(Text(selectedChassis!
                                                  .portCost
                                                  .toString())),
                                              const DataCell(Text('Duty')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!.duty
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!.duty =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.duty
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('CNF')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!.cnf
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!.cnf =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.cnf
                                                      .toString())),
                                              const DataCell(Text('Warfrent')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .warfrent
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .warfrent =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .warfrent
                                                      .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(Text('Others')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .others
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .others =
                                                            double.parse(
                                                                newValue);
                                                        selectedChassis!.total =
                                                            selectedChassis!
                                                                    .buyingPrice +
                                                                selectedChassis!
                                                                    .portCost +
                                                                selectedChassis!
                                                                    .duty +
                                                                selectedChassis!
                                                                    .cnf +
                                                                selectedChassis!
                                                                    .warfrent +
                                                                selectedChassis!
                                                                    .others;
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!.others
                                                      .toString())),
                                              const DataCell(Text('Total')),
                                              DataCell(Text(selectedChassis!
                                                  .total
                                                  .toString())),
                                            ]),
                                            DataRow(cells: [
                                              const DataCell(
                                                  Text('Selling Price')),
                                              DataCell(isEditable
                                                  ? TextFormField(
                                                      initialValue:
                                                          selectedChassis!
                                                              .sellingPrice
                                                              .toString(),
                                                      onChanged: (newValue) {
                                                        selectedChassis!
                                                                .sellingPrice =
                                                            double.parse(
                                                                newValue);
                                                        updateAll();
                                                      },
                                                    )
                                                  : Text(selectedChassis!
                                                      .sellingPrice
                                                      .toString())),
                                              const DataCell(Text('Profit')),
                                              DataCell(Text(selectedChassis!
                                                  .profit
                                                  .toString())),
                                            ]),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20),
                                        child: isEditable
                                            ? TextFormField(
                                                initialValue:
                                                    selectedChassis!.remark,
                                                maxLines: 4,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      "Enter Others cost details",
                                                  labelText: "Remarks",
                                                  border: OutlineInputBorder(),
                                                ),
                                                onChanged: (String value) {
                                                  selectedChassis!.remark =
                                                      value;
                                                },
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                    selectedChassis!.remark),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: Text("No Lc Data found"),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LcEntry.routeName);
                },
                backgroundColor: Colors.amber,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
    );
  }
}
