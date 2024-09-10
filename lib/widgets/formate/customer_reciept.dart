import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/chassis_model.dart';

import '../../methods/numberToWord.dart';
import '../../methods/pdf_method.dart';
import '../../models/pdf_models/pdf_cutomer.dart';
import '../../providers/contents.dart';


class CustomerRecieptFormate extends StatefulWidget {
  final Chassis a;
  bool pressed = false;
  static const routeName ='/challan formate';
  CustomerRecieptFormate({Key? key,required this.a}) : super(key: key);
  @override
  State<CustomerRecieptFormate> createState() => _CustomerRecieptFormateState();
}

class _CustomerRecieptFormateState extends State<CustomerRecieptFormate> {
  TextEditingController introController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController customerPayController = TextEditingController();
  String intro="",price='',address="",phone="",customerPay="",inWord="";
  final cocode = UniqueKey().toString();
  final format = NumberFormat('##,##,##0.00');
  void word(){
    setState(() {
      double a = customerPayController.text.isEmpty||customerPayController.text.length==0?0:double.parse(customerPayController.text.replaceAll(',', '').trim().toString());
      inWord = convertNumberToWord(a) ;
    });
  }

  void saveData() async {
    // Create an instance of the Custom class and populate its fields with the data
    final customData = Custom(
      a: widget.a,
      name: intro,
      intro: intro,
      price: price,
      address: address,
      phone: phone,
      customerPay: customerPay,
      inWord: inWord,
      cocode: cocode,
      currentDate: currentDate
    );
    Provider.of<Contents>(context,listen: false).creatCustomerReceipt(customData);

    print('Data saved successfully!');
  }
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      body: widget.pressed?PdfPreview(
        build: (format) => customerPdf(widget.a,name: intro,price: price,address: address,phone: phone,cpaid: customerPay,inWord: inWord,cocode: cocode,currentDate: currentDate),
      ):Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Money Reciept")),
                SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 25),
                  child: TextFormField(
                    controller: addressController,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Customer\'s Name ',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        intro = value;
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 25),
                  child: TextFormField(
                    controller: phoneController,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        phone = value;
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 25),
                  child: TextFormField(
                    controller: introController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        address = value;
                      });
                    },
                  ),
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
                      TableItem('1','Vehicle', widget.a.name),
                      TableItem('2','Color', widget.a.color),
                      TableItem('3','Model', widget.a.model),
                      TableItem('4','Chassis No', widget.a.chassis),
                      TableItem('5','Engine No', widget.a.engineNo),
                      TableItem('6','CC', widget.a.cc),
                      InputItem('7', 'Price',price, priceController),
                      InputItem('7', 'Customer Paid',customerPay, customerPayController),
                      TableItem('8', 'Price in Word', inWord),
                    ],
                  ),
                ),
                SizedBox(height: 35,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    width>420?Text("Signature of Customer"):Text(''),
                    MaterialButton(onPressed: (){
                      setState(() {
                        widget.pressed = true;
                        saveData();
                      });
                    },textColor: Colors.white, color: Colors.purpleAccent,child: Text("Save"),),
                    width>420?Text("Authurized Signature"):Text(''),
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
                if (type == 'Price') {
                  cnt.text = format.format(double.parse(value.replaceAll(',', '')));
                  cnt.selection = TextSelection.fromPosition(TextPosition(offset: cnt.text.length-3));
                  price = cnt.text.toString();
                  } else if (type == 'Customer Paid') {
                  cnt.text = format.format(double.parse(value.replaceAll(',', '')));
                  cnt.selection = TextSelection.fromPosition(TextPosition(offset: cnt.text.length-3));
                  customerPay = cnt.text.toString();
                  }
                });
                word();
              },
            ),
          ),
        ),
      ],
    );
  }
}
