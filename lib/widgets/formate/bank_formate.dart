import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/chassis_model.dart';

import '../../methods/numberToWord.dart';
import '../../methods/pdf_method.dart';
import '../../models/pdf_models/pdf_bank.dart';
import '../../providers/contents.dart';

class BankFormate extends StatefulWidget {
  final Chassis a;
  bool pressed = false;
  static const routeName ='/challan formate';
  BankFormate({Key? key,required this.a}) : super(key: key);
  @override
  State<BankFormate> createState() => _BankFormateState();
}

class _BankFormateState extends State<BankFormate> {
  TextEditingController introController = TextEditingController();
  TextEditingController acController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bank_payController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController poController = TextEditingController();
  String intro="",price='',bankPay="",bank="",branch="",po="",ac="",inWord="";
  final bacode = UniqueKey().toString();
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  String formatNumber(int number) {
    final format = NumberFormat('##,##,###');
    return format.format(number);
  }
  
  void word(){
    setState(() {
      double a = bank_payController.text.isEmpty?0:double.parse(bank_payController.text.replaceAll(',', '').trim().toString());
      inWord = convertNumberToWord(a) ;
    });
  }

  void saveData() async {
    final customData = Bank(a: widget.a, intro: intro, ac: ac, price: price.toString(), bank: bank,branch: branch, bankPay: bankPay.toString(), po:po, inWord: inWord, bacode: bacode, currentDate: currentDate);
    Provider.of<Contents>(context,listen: false).creatBankReceipt(customData);
  }

  @override
  Widget build(BuildContext context) {
    double width= MediaQuery.of(context).size.width;

    return Scaffold(
      body: widget.pressed?PdfPreview(
        build: (format) => bankPdf(widget.a,t: intro,ac:ac,price: price,bank: bank,branch: branch,bpaid: bankPay,po: po,inWord: inWord,bacode: bacode,currentDate: currentDate),
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
                      vertical: 10.0, horizontal: 5),
                  child: TextFormField(
                    controller: introController,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'To',
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
                      vertical: 10.0, horizontal: 5),
                  child: TextFormField(
                    controller: acController,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'A/C: ',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        ac = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(.90),  // Width for the first column
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
                      InputItem('8', 'Amount Paid By Bank',bankPay, bank_payController),
                      InputItem('9','Cheque No or P/O No',po, poController),
                      InputItem('10', 'Bank',bank, bankController),
                      InputItem('11', 'Branch',branch, branchController),
                      TableItem('12', 'In Word BDT', inWord)
                    ],
                  ),
                ),
                SizedBox(height: 15,),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow InputItem(String sl, String type, String item, TextEditingController cnt, {int line = 1}) {
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  if (type == 'Price') {
                    // Update the controller's text with the formatted price
                    cnt.text = format.format(double.parse(value.replaceAll(',', '')));
                    cnt.selection = TextSelection.fromPosition(TextPosition(offset: cnt.text.length-3));
                     price = cnt.text.toString();
                  } else if (type == 'Amount Paid By Bank') {
                    cnt.text = format.format(double.parse(value.replaceAll(',', '')));
                    cnt.selection = TextSelection.fromPosition(TextPosition(offset: cnt.text.length-3));
                    bankPay = cnt.text.toString();
                  } else if (type == 'Cheque No or P/O No') {
                    po = value;
                  } else if (type == 'Bank') {
                    bank = value;
                  } else if (type == 'Branch') {
                    branch = value;
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