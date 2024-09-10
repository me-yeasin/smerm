import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:smerp/models/chassis_model.dart';
import 'package:smerp/models/pdf_models/pdf_sale_customer.dart';
import '../../methods/numberToWord.dart';
import '../../methods/pdf_method.dart';
import '../../providers/contents.dart';


// ignore: must_be_immutable
class SaleCustomerRecieptFormate extends StatefulWidget {
  final Chassis a;
  bool pressed = false;
  SaleCustomerRecieptFormate({Key? key,required this.a}) : super(key: key);
  @override
  State<SaleCustomerRecieptFormate> createState() => _SaleCustomerRecieptFormateState();
}

class _SaleCustomerRecieptFormateState extends State<SaleCustomerRecieptFormate> {
  TextEditingController introController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController customerPayController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController tyreController = TextEditingController();
  TextEditingController chequeController = TextEditingController();
  final format = NumberFormat('##,##,##0.00');
  String intro="",address="",phone="",inWord="",balance='',cheque='',bank='',branch='',tyre='',price ="",customerPay="";

  final cocode = UniqueKey().toString();
  void word(){
    double a =price ==""||price.isEmpty?0:double.parse(price.replaceAll(',', ''));
    double b = customerPay==""||customerPay.isEmpty?0:double.parse(customerPay.replaceAll(',', ''));
    double c = a-b;
    setState(() {
    balance = format.format(c);
    });
  }
  void bala(){
    setState(() {
      double a = customerPayController.text.isEmpty?0:double.parse(customerPayController.text.replaceAll(',', ''));
      inWord = convertNumberToWord(a) ;
    });
  }
  void saveData() async {
    // Create an instance of the Custom class and populate its fields with the data
    final customData = SaleCustom(
        a: widget.a,
        name: intro,
        intro: intro,
        price: price.toString(),
        address: address,
        phone: phone,
        customerPay: customerPay.toString(),
        inWord: inWord,
        balance: balance,
        currentDate: currentDate,
      cheque: cheque,
      bank: bank,
      branch: branch,
      tyre: tyre
    );
    Provider.of<Contents>(context,listen: false).creatDirectCustomerReceipt(customData);

  }
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: widget.pressed?PdfPreview(
        build: (format) => SalecustomerPdf(widget.a,name: intro,price: price,address: address,phone: phone,cpaid: customerPay,inWord: inWord,balance: balance,currentDate: currentDate,cheque: cheque,branch: branch,bank: bank,tyre: tyre),
      ):Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text("Money Reciept")),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 15),
                  child: TextFormField(
                    controller: addressController,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Buyer\'s Name ',
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
                      vertical: 25.0, horizontal: 15),
                  child: TextFormField(
                    controller: phoneController,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
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
                      vertical: 25.0, horizontal: 15),
                  child: TextFormField(
                    controller: introController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
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
                    columnWidths: const {
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
                      InputItem('7', 'Price',price.toString(), priceController),
                      InputItem('8', 'Tk',customerPay.toString(), customerPayController),
                      TableItem('9', 'In Word BDT', inWord),
                      TableItem('10', 'Balance Amount',balance),
                      InputItem('11','Cheque No',cheque,chequeController),
                      InputItem('12','Bank',bank,bankController),
                      InputItem('13','Branch',branch,branchController),
                      InputItem('14','Tyre Size',tyre,tyreController),
                    ],
                  ),
                ),
                const SizedBox(height: 35,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                     width>420?Text("Signature of Customer"):Text(''),
                      MaterialButton(onPressed: (){
                        setState(() {
                          widget.pressed = true;
                          saveData();
                        });
                      },textColor: Colors.white, color: Colors.purpleAccent,child: const Text("Save"),),
                      width>420?Text("Authurized Signature"):Text(''),
                    ],
                  ),
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
            child: Text(sl),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(type),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: cnt,
              maxLines: line,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  if (type == 'Price') {
                    cnt.text = format.format(double.parse(value.replaceAll(',', '')));
                    cnt.selection = TextSelection.fromPosition(TextPosition(offset: cnt.text.length-3));
                    price = cnt.text.toString();
                  } else if (type == 'Tk') {
                    cnt.text = format.format(double.parse(value.replaceAll(',', '')));
                    cnt.selection = TextSelection.fromPosition(TextPosition(offset: cnt.text.length-3));
                    customerPay =  cnt.text.toString();
                  } else if (type == 'Cheque No') {
                    cheque = value;
                  } else if (type == 'Bank') {
                    bank = value;
                  } else if (type == 'Branch') {
                    branch = value;
                  } else if (type == 'Tyre Size') {
                    tyre = value;
                  }
                });
                word();
                bala();
              },
            ),
          ),
        ),
      ],
    );
  }
}
