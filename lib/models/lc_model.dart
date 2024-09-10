
import 'package:smerp/models/chassis_model.dart';

class LC {
  String lcNo;
  String irc;
  String supplier;
  String shipment;
  List<Chassis> chassis;
  String date;
  String lcAmount;
  String bank;
  String profit;
  LC({
  required this.lcNo,
  required this.irc,
  required this.supplier,
  required this.shipment,
  required this.chassis,
    required this.date,
    required this.lcAmount,
    required this.bank,
    required this.profit
  });
  Map<String, dynamic> toJson() {
    return {
      'lcNo': lcNo,
      'irc': irc,
      'supplier': supplier,
      'shipment': shipment,
      'chassis': chassis.map((chassis) => chassis.toJson()).toList(),
      'date': date,
      'lcAmount': lcAmount,
      'bank': bank,
      'profit':profit
    };
  }

  LC.fromJson(Map<String, dynamic> json)
      : lcNo = json['lcNo'],
        irc = json['irc'],
        supplier = json['supplier'],
        shipment = json['shipment'],
        chassis = (json['chassis'] as Map<String, dynamic>).values
            .map((chassisJson) => Chassis.fromJson(chassisJson))
            .toList(),
      date = json['date'],
        lcAmount = json['lcAmount'],
        bank = json['bank'],
        profit=json['profit'];
}