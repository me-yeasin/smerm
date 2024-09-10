import '../chassis_model.dart';
class Bank{
  final Chassis a;
  final String intro;
  final String ac;
  final String price;
  final String bank;
  final String branch;
  final String bankPay;
  final String po;
  final String inWord;
  final String bacode;
  final dynamic currentDate;
  Bank({
    required this.a,
    required this.intro,
    required this.ac,
    required this.price,
    required this.bank,
    required this.branch,
    required this.bankPay,
    required this.po,
    required this.inWord,
    required this.bacode,
    required this.currentDate
  });
  Map<String, dynamic> toJson() {
    return {
      'a': a.toJson(), // Assuming a.toJson() returns a Map<String, dynamic>
      'intro': intro,
      'ac': ac,
      'price': price.toString(),
      'bank': bank,
      'branch': branch,
      'bankPay': bankPay,
      'po': po,
      'inWord': inWord,
      'bacode': bacode,
      'currentDate': currentDate
    };
  }

  Bank.fromJson(Map<String, dynamic> json,)
      : a = Chassis.fromJson(json['a']),
        intro = json['intro'],
        ac = json['ac'],
        price= json['price'],
        bank= json['bank'],
        branch= json['branch'],
        bankPay=json['bankPay'],
        po=json['po'],
        inWord=json['inWord'],
        bacode=json['bacode'],
        currentDate=json['currentDate'];
}