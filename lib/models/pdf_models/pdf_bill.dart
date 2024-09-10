import '../chassis_model.dart';
class Bill{
  final Chassis a;
  final String intro;
  final String ac;
  final String price;
  final String bank;
  final String bankPay;
  final String customer;
  final String total;
  final String inWord;
  final String bcode;
  final dynamic currentDate;

  Bill({
    required this.a,
    required this.intro,
    required this.ac,
    required this.price,
    required this.bank,
    required this.bankPay,
    required this.customer,
    required this.total,
    required this.inWord,
    required this.bcode,
    required this.currentDate
  });

  Map<String, dynamic> toJson() {
    return {
      'a': a.toJson(), // Assuming a.toJson() returns a Map<String, dynamic>
      'intro': intro,
      'ac': ac,
      'price': price.toString(),
      'bank': bank,
      'bankPay': bankPay,
      'customer': customer,
      'total': total,
      'inWord':inWord,
      'bcode': bcode,
      'currentDate': currentDate
    };
  }

  Bill.fromJson(Map<String, dynamic> json,)
      : a = Chassis.fromJson(json['a']),
        intro = json['intro'],
        ac = json['ac'],
        price= json['price'],
        bank= json['bank'],
        bankPay=json['bankPay'],
        customer=json['customer'],
        total=json['total'],
        inWord=json['inWord'],
        bcode=json['bcode'],
        currentDate=json['currentDate'];
}