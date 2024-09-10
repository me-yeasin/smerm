import 'package:smerp/models/chassis_model.dart';
class SaleCustom{
  final Chassis a;
  final String name;
  final String intro;
  final String price;
  final String address;
  final String phone;
  final String customerPay;
  final String inWord;
  final String balance;
  final dynamic currentDate;
  final String cheque;
  final String bank;
  final String branch;
  final String tyre;
  SaleCustom({
    required this.a,
    required this.name,
    required this.intro,
    required this.price,
    required this.address,
    required this.phone,
    required this.customerPay,
    required this.inWord,
    required this.balance,
    required this.currentDate,
    required this.cheque,
    required this.bank,
    required this.branch,
    required this.tyre
  });

  Map<String, dynamic> toJson() {
    return {
      'a': a.toJson(), // Assuming a.toJson() returns a Map<String, dynamic>
      'name': name,
      'intro': intro,
      'price': price.toString(),
      'address': address,
      'phone': phone,
      'customerPay': customerPay,
      'inWord': inWord,
      'balance': balance,
      'currentDate': currentDate,
      'cheque':cheque,
      'bank':bank,
      'branch':branch,
      'tyre':tyre,
    };
  }

  SaleCustom.fromJson(Map<String, dynamic> json,)
      : a = Chassis.fromJson(json['a']),
        name = json['name'],
        intro = json['intro'],
        price= json['price'],
        address= json['address'],
        phone=json['phone'],
        customerPay=json['customerPay'],
        inWord=json['inWord'],
        balance=json['balance'],
        currentDate=json['currentDate'],
        cheque=json['cheque'],
        bank=json['bank'],
        branch=json['branch'],
        tyre=json['tyre'];
}
