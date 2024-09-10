import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/chassis_model.dart';

import '../../methods/pdf_method.dart';
import '../../models/pdf_models/pdf_challan.dart';
import '../../providers/contents.dart';

class ChallanFormate extends StatefulWidget {
  final Chassis a;
  bool pressed = false;
  static const routeName ='/challan formate';
  ChallanFormate({Key? key,required this.a}) : super(key: key);
  @override
  State<ChallanFormate> createState() => _ChallanFormateState();
}

class _ChallanFormateState extends State<ChallanFormate> {
  TextEditingController introController = TextEditingController();
  TextEditingController acController = TextEditingController();
  TextEditingController tyreController = TextEditingController();
  String intro="",ac="",tyre="";
  final ccode = UniqueKey().toString();
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  void saveData() async {

    // Create an instance of the Custom class and populate its fields with the data
    final customData = Challan(a: widget.a, intro: intro, ac: ac, tyre: tyre,ccode: ccode, currentDate: currentDate);

    Provider.of<Contents>(context,listen: false).creatChallan(customData);

    print('Data saved successfully!');
  }



  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      body: widget.pressed?PdfPreview(
        build: (format) => challanPdf(widget.a,t: intro,ac: ac,tyre: tyre,ccode: ccode,currentDate: currentDate),
      ):Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Challan",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                SizedBox(height: 20,),
                Text("Date: $currentDate"),
                SizedBox(height: 10,),
                Text('To'),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10),
                  child: TextFormField(
                    controller: introController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        intro = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10),
                  child: TextFormField(
                    controller: acController,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'A/C'
                    ),
                    onChanged: (String value) {
                      setState(() {
                        ac = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(.90),   // Width for the first column
                      1: FlexColumnWidth(2),   // Width for the second column
                      2: FlexColumnWidth(3),   // Width for the third column
                    },
                    border: TableBorder.all(), // optional: add border to the table
                    children: [
                      TableItem('1','Vehicle', widget.a.name),
                      TableItem('2','Color', widget.a.color),
                      TableItem('3','Model', widget.a.model),
                      TableItem('4','Chassis No', widget.a.chassis),
                      TableItem('5','Engine No', widget.a.engineNo),
                      TableItem('6','CC', widget.a.cc),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('8'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Tyre Size'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tyreController,
                                maxLines: 1,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    tyre = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10,),
                Container(child: Text("I/We hereby received the above mentioned vehicle in good and running condition"),),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    width>420?Text("Delivery Received "):Text(''),
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          widget.pressed = true;
                          saveData();
                        });
                      },
                      textColor: Colors.white,
                      color: Colors.purpleAccent,
                      child: Text("Save"),
                    ),


                    width>420?Text("Authurized Signature"):Text(''),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
