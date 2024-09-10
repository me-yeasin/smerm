import 'package:smerp/models/chassis_model.dart';
class Custom {
  final Chassis a;
  final String name;
  final String intro;
  final String price;
  final String address;
  final String phone;
  final String customerPay;
  final String inWord;
  final String cocode;
  final dynamic currentDate;
  Custom({
    required this.a,
    required this.name,
    required this.intro,
    required this.price,
    required this.address,
    required this.phone,
    required this.customerPay,
    required this.inWord,
    required this.cocode,
    required this.currentDate
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
      'cocode': cocode,
      'currentDate': currentDate
    };
  }

  Custom.fromJson(Map<String, dynamic> json,)
      : a = Chassis.fromJson(json['a']),
        name = json['name'],
        intro = json['intro'],
        price= json['price'],
        address= json['address'],
        phone=json['phone'],
        customerPay=json['customerPay'],
        inWord=json['inWord'],
        cocode=json['cocode'],
        currentDate=json['currentDate'];
}
