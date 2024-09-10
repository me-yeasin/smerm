import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/chassis_model.dart';
import 'package:smerp/models/pdf_models/pdf_quotation.dart';
import 'package:smerp/providers/contents.dart';
import '../../methods/numberToWord.dart';
import '../../methods/pdf_method.dart';

class QuotationFormate extends StatefulWidget {
  final Chassis a;
  bool pressed = false;
  static const routeName ='/qutation formate';
  QuotationFormate({Key? key,required this.a}) : super(key: key);
  @override
  State<QuotationFormate> createState() => _QuotationFormateState();
}

class _QuotationFormateState extends State<QuotationFormate> {
  TextEditingController introController = TextEditingController();
  TextEditingController acController = TextEditingController();
  TextEditingController fittingsController = TextEditingController();
  TextEditingController validityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController paymentController = TextEditingController(text: 'Cash/Pay-Order/DD/RTGS');
  String intro="",fittings="",validity="",price="",inWord="",payment_method="Cash/Pay-Order/DD/RTGS",ac ="";

  String selectedOption = '10 (Ten) Days';
  String currentDate = DateFormat('MMMM d, yyyy').format( DateTime.now());
  void word(){
    bool isDouble(price) {
      try {
        double.parse(price.toString().replaceAll(',', ''));
        return true;
      } catch (e) {
        return false;
      }
    }
    price.isNotEmpty ? setState(() {
      if (isDouble(price)) {
        double a = double.parse(price.replaceAll(',', ''));
        inWord = convertNumberToWord(a);
      }
    }):setState(() {
      inWord = "zero";
    });
  }
  void saveData() async {
    // Create an instance of the Custom class and populate its fields with the data
    final customData = Quotation(
        a: widget.a,
        intro: intro,
        ac: ac,
        fittings: fittings,
        validity: selectedOption,
        price: price.toString(),
        payment_method: payment_method,
        qcode: inWord,
        currentDate: currentDate
    );

    Provider.of<Contents>(context,listen: false).creatQuotation(customData);

  }
  @override
  Widget build(BuildContext context) {
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      body: widget.pressed?PdfPreview(
        build: (format) => quotationPdf(widget.a,t: intro,ac: ac,fit: fittings,val: selectedOption,price: price,method: payment_method,currentDate: currentDate,inWord: inWord),
      ):Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Quotation")),
                SizedBox(height: 20,),
                Text("Date: $currentDate"),
                Text('To'),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0,),
                  child: TextFormField(
                    controller: introController,
                    maxLines: 6,
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
                      vertical: 15.0,),
                  child: TextFormField(
                    controller: acController,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'A/C: '
                    ),
                    onChanged: (String value) {
                      setState(() {
                        ac = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Text("Subject: Quotation of Supply 1(One) Unit Re-Conditioned"),
                Container(
                  child: Text("Dear Sir,"
                      "In Response to your query, regarding the vehicle we are pleased to quote the following model with a special price"),
                ),
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
                      TableItem('1','Brand name', widget.a.name),
                      TableItem('2','Chassis No', widget.a.chassis),
                      TableItem('3','Engine No', widget.a.engineNo),
                      TableItem('4','CC', widget.a.cc),
                      TableItem('3','Color', widget.a.color),
                      TableItem('6','Model', widget.a.model),
                      InputItem('7','Fittings',fittings,fittingsController,line: 10),
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
                            child: Text('Validity'),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedOption,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOption = newValue!;
                                });
                              },
                              items: <String>['10 (Ten) Days', '20 (Twenty) Days','30 (Thirty) Days','45 (Forty-Five) Days','60 (Sixty) Days','90 (Ninety) Days'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                      InputItem('9','Price', price,priceController),
                      TableItem('12', 'In Word BDT', inWord),
                      InputItem('10','Payment Mode',payment_method,paymentController),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(child: Text("From the above details, we would request you to please accept our quotation and oblige thereby"),),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    width>420?Text("Accepted by Customer"):Text(''),
                    MaterialButton(onPressed: (){
                      setState(() {
                        widget.pressed = true;
                        saveData();
                      });
                    },textColor: Colors.white, color: Colors.purpleAccent,child: Text("Save"),),
                    width>420?Text("Authurized Signature"):Text('')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  TableRow InputItem(String sl,String type,String item,TextEditingController cnt,{int line = 1}) {
    final format = NumberFormat('##,##,##0.00');
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$sl'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$type'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: cnt,
              maxLines: line,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  if (type == 'Fittings') {
                    fittings = value;
                  } else if (type == 'Validity') {
                    validity = value;
                  } else if (type == 'Price') {
                    cnt.text = format.format(double.parse(value.replaceAll(',', '')));
                    cnt.selection = TextSelection.fromPosition(TextPosition(offset: cnt.text.length-3));
                    price = cnt.text.toString();
                  } else if (type == 'Payment Mode') {
                    payment_method = value;
                  }
                  word();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

}
