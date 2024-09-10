import 'package:smerp/models/chassis_model.dart';
class Challan {
  final Chassis a;
  final String intro;
  final String ac;
  final String tyre;
  final String ccode;
  final String currentDate;
  Challan({
    required this.a,
    required this.intro,
    required this.ac,
    required this.tyre,
    required this.ccode,
    required this.currentDate
});

  Map<String, dynamic> toJson() {
    return {
      'a': a.toJson(), // Assuming a.toJson() returns a Map<String, dynamic>
      'intro': intro,
      'ac': ac,
      'tyre': tyre,
      'ccode': ccode,
      'currentDate': currentDate
    };
  }

  Challan.fromJson(Map<String, dynamic> json,)
      : a = Chassis.fromJson(json['a']),
        intro = json['intro'],
        ac = json['ac'],
        tyre= json['tyre'],
        ccode=json['ccode'],
        currentDate=json['currentDate'];

}