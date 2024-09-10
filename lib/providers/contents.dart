import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smerp/models/chassis_model.dart';
import 'package:smerp/models/lc_model.dart';
import 'package:smerp/models/pdf_models/pdf_bank.dart';
import 'package:smerp/models/pdf_models/pdf_cutomer.dart';
import 'package:smerp/models/pdf_models/pdf_quotation.dart';
import 'package:smerp/models/pdf_models/pdf_bill.dart';
import 'package:smerp/providers/auth.dart';
import '../models/pdf_models/pdf_challan.dart';
import '../models/pdf_models/pdf_sale_customer.dart';

class Contents extends ChangeNotifier{

  List<LC> postdata =[];
  List<Quotation>quotationdata = [];
  List<Bill>billdata = [];
  List<Challan>challandata = [];
  List<Custom> customerReceiptdata =[];
  List<SaleCustom> directCustomerReceiptdata =[];
  List<Bank> bankReceiptdata =[];
  List<Chassis> chassisdata =[];
  List<String> quotationkey =[];
  List<String> billkey =[];
  List<String> challankey =[];
  List<String> customerReceiptkey =[];
  List<String> directCustomerReceiptkey =[];
  List<String> bankReceiptkey =[];
  List<String> postkey =[];
  Map<String,List<String>> keystore={};
  String currentPostKey = "";
  String _currentRootKey = ""; // Private field for currentRootKey
  String get currentRootKey => _currentRootKey; // Getter for currentRootKey
  String get userName => Auth.userName;
  bool statusCode =false;
  // Method to update currentRootKey
  void updateCurrentRootKey(String newRootKey) {
   int index = int.parse(newRootKey);
    _currentRootKey = postkey[index];
    notifyListeners();
    // Notify listeners about the change
  }
  late LC editedPostData;

  void editData(LC post){
    editedPostData = post;
  }

  Future<List<LC>> fetchAndPrintPosts() async {
    try {
      List<String> keylist=[];
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc.json'),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);
        // List<LC> posts = [];
        postdata.clear();
        postkey.clear();
        keylist.clear();
        keystore.clear();
        data.forEach((key, value) {
          if(value['chassis']==null){
            postdata.add(LC
              (lcNo: value['lcNo'], irc: value['irc'], supplier: value['supplier'],
                shipment: value['shipment'], chassis: [], date: value['date'], lcAmount: value['lcAmount'], bank: value['bank'],profit: value['profit']));
          }else{
            Map<String, dynamic> chassisdata= value['chassis'];
            postdata.add(LC.fromJson(value));
            keystore.addAll({key:chassisdata.keys.toList()});
          }

        });
        postkey.addAll(data.keys);
        // print("3: "+keystore.toString());
        return postdata;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> creatpost(LC lcData) async {
    currentPostKey = currentPostKey;
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(
          lcData
        )
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      // Print the response data
     _currentRootKey = responseData.substring(9,29);
      statusCode = true;
    } else {
      // Error handling - handle failed API request
    }
  }

  Future<void> createtChassis(Chassis chassis,String PostKey,String amount,String profit) async {
    try {
      var response = await http.post(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$PostKey/chassis.json'),
        body: jsonEncode(
            chassis
            ),
      );
      if (response.statusCode == 200) {
        fetchAndPrintPosts();
        updateLcAmount(amount, PostKey);
        updateLcProfit(profit, PostKey);
        notifyListeners();
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchAndPrintChassis(String RootKey,String keyNode) async {

    try {
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/$keyNode/chassis.json'),
      );

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);

        // Convert the map of posts to a list
        List<Map<String, dynamic>> chassis = [];
        data.forEach((key, value) {
          chassis.add(Map<String, dynamic>.from(value));
        });
        chassisdata.clear();
        for (var c in chassis) {
          Chassis chassis = Chassis(
              name: c.values.first['name'],
              cc: c.values.first['cc'],
              chassis: c.values.first['chassis'],
              engineNo: c.values.first['engineNo'],
              color: c.values.first['color'],
              model: c.values.first['model'],
              remark: c.values.first['remark'],
              buyingPrice: c.values.first['buyingPrice'],
              invoice: c.values.first['invoice'],
              ttAmount: c.values.first['ttAmount'],
              portCost: c.values.first['portCost'],
              duty: c.values.first['duty'],
              cnf: c.values.first['cnf'],
              warfrent: c.values.first['warfrent'],
              others: c.values.first['others'],
              total: c.values.first['total'],
              sellingPrice: c.values.first['sellingPrice'],
              profit: c.values.first['profit'],
              invoiceRate: c.values.first['invoiceRate'],
              invoiceBdt: c.values.first['invoiceBdt'],
              ttRate: c.values.first['ttRate'],
              ttBdt: c.values.first['ttBdt'],
              sold: c.values.first['sold'],
              vat: c.values.first['vat'],
              delivery_date: c.values.first['delivery_date'],
              km: c.values.first['km']
          );
          chassisdata.add(chassis);
          notifyListeners();
        }
        return chassis;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts');
    }
  }
  Future<void> updateLcAmount(String amount, String RootKey,) async {

    try {
      var response = await http.put(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/irc.json'),
        body: jsonEncode(
          amount
        ),
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }
  Future<void> updateLcProfit(String profit, String RootKey,) async {
    try {
      var response = await http.put(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/profit.json'),
        body: jsonEncode(
            profit
        ),
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }
  Future<void> editLcIrc(LC lc, String RootKey,) async {
    try {
      var response = await http.put(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/irc.json'),
        body: jsonEncode(
            lc.irc
        ),
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }
  Future<void> editLcShipment(LC lc, String RootKey,) async {
    try {
      var response = await http.put(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/shipment.json'),
        body: jsonEncode(
            lc.shipment
        ),
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }
  Future<void> editLcBank(LC lc, String RootKey,) async {
    try {
      var response = await http.put(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/bank.json'),
        body: jsonEncode(
            lc.bank
        ),
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }
  Future<void> editLcSupplier(LC lc, String RootKey,) async {
    try {
      var response = await http.put(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/supplier.json'),
        body: jsonEncode(
            lc.supplier
        ),
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }

  Future<void> editChassis(Chassis chassis, String RootKey,String keyNode) async {
    try {
      var response = await http.put(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey/chassis/$keyNode.json'),
        body: jsonEncode(
            chassis
        ),
      );
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
    }
  }

  Future<void> deletePost(LC post, String RootKey,) async {

    try {
      final Url = Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/lc/$RootKey.json');
      final response = await http.delete(Url);
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      HttpException(e.toString());
      print(e.toString());
    }
  }

  Future<void> creatQuotation(Quotation QData) async {
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/quotation.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(QData.toJson()),
    );
    if (response.statusCode == 200) {
    } else {
    }
  }

  Future<List<Quotation>> fetchQuotation() async {
    try {
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/quotation.json'),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);
        quotationdata.clear();
        data.forEach((key, value) {
          if (value != null && value is Map<String, dynamic>) {
            quotationdata.add(Quotation.fromJson(value));
            quotationkey.addAll(data.keys);
            notifyListeners();
          } else {
          }
        });

        return quotationdata;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> creatBill(Bill BData) async {
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/bill.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(BData.toJson()),
    );

    if (response.statusCode == 200) {
    } else {
    }
  }

  Future<List<Bill>> fetchBill() async {
    try {
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/bill.json'),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);
        billdata.clear();
        data.forEach((key, value) {
          // if(value!=null&& value is Map<dynamic, dynamic>){
          //
          // }
          if (value != null && value is Map<String, dynamic>) {
            billdata.add(Bill.fromJson(value));
            billkey.addAll(data.keys);
            notifyListeners();
          } else {
          }
        });
        return billdata;
      } else {
        throw Exception('Failed to load bill report');
      }
    } catch (e) {
      throw Exception('Failed to load bill data');
    }
  }

  Future<void> creatChallan(Challan CData) async {
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/challan.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(CData.toJson()),
    );

    if (response.statusCode == 200) {
    } else {
    }
  }

  Future<List<Challan>> fetchChallan() async {
    try {
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/challan.json'),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);
        challandata.clear();
        data.forEach((key, value) {
          if (value != null && value is Map<String, dynamic>) {
            challandata.add(Challan.fromJson(value));
            challankey.addAll(data.keys);
            notifyListeners();
          } else {
          }
        });

        return challandata;
      } else {
        throw Exception('Failed to load challan data');
      }
    } catch (e) {
      throw Exception('Failed to load challan data');
    }
  }

  Future<void> creatCustomerReceipt(Custom CuData) async {
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/customereceipt.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(CuData.toJson()),
    );

    if (response.statusCode == 200) {
    } else {
    }
  }

  Future<List<Custom>> fetchCustomerReceipt() async {
    try {
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/customereceipt.json'),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);
        customerReceiptdata.clear();
        data.forEach((key, value) {
          if (value != null && value is Map<String, dynamic>) {
            customerReceiptdata.add(Custom.fromJson(value));
            customerReceiptkey.addAll(data.keys);
            notifyListeners();
          } else {
          }
        });

        return customerReceiptdata;
      } else {
        throw Exception('Failed to load customer receipt data');
      }
    } catch (e) {
      throw Exception('Failed to load customer receipt data');
    }
  }

  Future<void> creatBankReceipt(Bank BData) async {
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/bankreceipt.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(BData.toJson()),
    );

    if (response.statusCode == 200) {
    } else {
    }
  }

  Future<List<Bank>> fetchBankReceipt() async {
    try {
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/bankreceipt.json'),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);
        bankReceiptdata.clear();
        data.forEach((key, value) {
          if (value != null && value is Map<String, dynamic>) {
            bankReceiptdata.add(Bank.fromJson(value));
            bankReceiptkey.addAll(data.keys);
            notifyListeners();
          } else {
          }
        });

        return bankReceiptdata;
      } else {
        throw Exception('Failed to load bank receipt data');
      }
    } catch (e) {
      throw Exception('Failed to load bank receipt data');
    }
  }

  Future<void> creatDirectCustomerReceipt(SaleCustom DCuData) async {
    final String apiUrl = 'https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/directcustomereceipt.json'; // Replace with your API endpoint
    final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(DCuData.toJson()),
    );

    if (response.statusCode == 200) {
    } else {
    }
  }

  Future<List<SaleCustom>> fetchDirectCustomerReceipt() async {
    try {
      var response = await http.get(
        Uri.parse('https://shop-624d0-default-rtdb.firebaseio.com/erp/$userName/report/directcustomereceipt.json'),
      );
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);
        directCustomerReceiptdata.clear();
        data.forEach((key, value) {
          if (value != null && value is Map<String, dynamic>) {
            directCustomerReceiptdata.add(SaleCustom.fromJson(value));
            directCustomerReceiptkey.addAll(data.keys);
            notifyListeners();
          } else {
          }
        });

        return directCustomerReceiptdata;
      } else {
        throw Exception('Failed to load direct customer receipt data');
      }
    } catch (e) {
      throw Exception('Failed to load direct customer receipt data');
    }
  }
}