import 'package:smerp/models/chassis_model.dart';
class Quotation{
  final Chassis a;
  final String intro;
  final String ac;
  final String fittings;
  final String validity;
  final String price;
  final String payment_method;
  final String qcode;
  final String currentDate;
  Quotation({
    required this.a,
    required this.intro,
    required this.ac,
    required this.fittings,
    required this.validity,
    required this.price,
    required this.payment_method,
    required this.qcode,
    required this.currentDate
  });

  Map<String, dynamic> toJson() {
    return {
      'a': a.toJson(), // Assuming a.toJson() returns a Map<String, dynamic>
      'intro': intro,
      'ac': ac,
      'fittings': fittings,
      'validity': validity,
      'price': price.toString(),
      'payment_method': payment_method,
      'qcode': qcode,
      'currentDate': currentDate
    };
  }

  Quotation.fromJson(Map<String, dynamic> json)
      : a = Chassis.fromJson(json['a']),
        intro = json['intro'],
        ac = json['ac'],
        fittings = json['fittings'],
        validity = json['validity'],
        price = json['price'],
        payment_method = json['payment_method'],
        qcode = json['qcode'],
        currentDate = json['currentDate'];


}