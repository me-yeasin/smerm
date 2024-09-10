import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smerp/lc/chasis_entry.dart';
import 'package:smerp/models/lc_model.dart';

import '../providers/contents.dart';

class LcEntry extends StatefulWidget {
  static const routeName = '/lc entry';

  const LcEntry({Key? key}) : super(key: key);

  @override
  State<LcEntry> createState() => _LcEntryState();
}

class _LcEntryState extends State<LcEntry> {
  final _formKey = GlobalKey<FormState>();
  String date='';
  String lcNo = '', irc = '', supplier = '', shipment = '', lcAmount = '', bank = '',profit='';
  TextEditingController lcController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController shipmentController = TextEditingController();
  TextEditingController ircController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<String> chassis=[];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        date = dateController.text; // Assign the selected date to the 'date' variable
      });
    }
  }

  @override
  void dispose() {
    lcController.dispose();
    supplierController.dispose();
    shipmentController.dispose();
    ircController.dispose();
    bankController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Contents provider = Provider.of<Contents>(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('LC Entry'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  width<700?EdgeInsets.symmetric(horizontal: 20):EdgeInsets.symmetric(horizontal: 100),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          height: 75,
                          width: 400,
                          child: TextFormField(
                            controller: lcController,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: "Enter LC Number",
                              labelText: "Product LC Number",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              lcNo = value;
                            },
                            validator: (value) {
                              return value!.isEmpty ? 'Enter LC Number' : null;
                            },
                          ),
                        ), //Lc Number
                        SizedBox(height: 15),
                        Container(
                          height: 75,
                          width: 400,
                          child: TextFormField(
                            controller: dateController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "Landing date",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(onPressed: (){
                                _selectDate(context);
                              }, icon: Icon(Icons.date_range)),
                            ),
                            validator: (value) {
                              setState(() {
                                value = date;
                              });
                              return value==''? 'Select a date' : null;
                            },
                          ),
                        ), //Date
                        SizedBox(height: 15),
                        Container(
                          height: 75,
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: TextFormField(
                              controller: supplierController,
                              keyboardType: TextInputType.name,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: "Enter Supplier Name",
                                labelText: "Supplier Name",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value) {
                                supplier = value;
                              },
                              validator: (value) {
                                return value!.isEmpty ? 'Supplier Name is Required' : null;
                              },
                            ),
                          ),
                        ), //Supplier Name
                        SizedBox(height: 15),
                        Container(
                          height: 75,
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: TextFormField(
                              controller: ircController,
                              maxLines: 2,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter IRC Amount",
                                labelText: "IRC",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value) {
                                irc = value;
                              },
                              validator: (value) {
                                return value!.isEmpty ? 'IRC is Required' : null;
                              },
                            ),
                          ),
                        ), //IRC
                        SizedBox(height: 15),
                        Container(
                          height: 75,
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: TextFormField(
                              controller: bankController,
                              keyboardType: TextInputType.name,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: "Enter Bank Name",
                                labelText: "Bank",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value) {
                                bank = value;
                              },
                              validator: (value) {
                                return value!.isEmpty ? 'Bank is required' : null;
                              },
                            ),
                          ),
                        ), //Bank
                        SizedBox(height: 15),
                        Container(
                          height: 75,
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: TextFormField(
                              controller: shipmentController,
                              keyboardType: TextInputType.name,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: "Landing Port ",
                                labelText: "Shipment",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value) {
                                shipment = value;
                              },
                              validator: (value) {
                                return value!.isEmpty ? 'Shipment is required' : null;
                              },
                            ),
                          ),
                        ), //Shipment
                        SizedBox(height: 30),
                        Container(
                          height: 50,
                          width: 200,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {

                                var lc = LC(
                                  lcNo: lcNo,
                                  irc: irc,
                                  supplier: supplier,
                                  shipment: shipment,
                                  chassis: [],
                                  date: date,
                                  lcAmount: lcAmount,
                                  bank: bank,
                                  profit: profit,
                                );
                                await provider.creatpost(lc);
                                if (provider.statusCode==true) {
                                  Navigator.of(context).pushNamed(ChasisEntry.routeName, arguments: [lcAmount,profit]);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('LC Not Stored'),
                                      content: Text('The lc is not stored in the box.'),
                                      actions: [
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            color: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Next',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}