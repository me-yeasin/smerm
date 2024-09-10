class Chassis {
  String name;
  String cc;
  String chassis;
  String engineNo;
  String color;
  String model;
  String remark;
  double buyingPrice;
  double invoice;
  double ttAmount;
  double portCost;
  double duty;
  double cnf;
  double warfrent;
  double others;
  double total;
  double sellingPrice;
  double profit;
  double invoiceRate;
  double invoiceBdt;
  double ttRate;
  double ttBdt;
  String vat;
  String sold;
  String delivery_date;
  String km;
  Chassis({
    required this.name,
    required this.cc,
    required this.chassis,
    required this.engineNo,
    required this.color,
    required this.model,
    required this.remark,
    required this.buyingPrice,
    required this.invoice,
    required this.ttAmount,
    required this.portCost,
    required this.duty,
    required this.cnf,
    required this.warfrent,
    required this.others,
    required this.total,
    required this.sellingPrice,
    required this.profit,
    required this.invoiceRate,
    required this.invoiceBdt,
    required this.ttRate,
    required this.ttBdt,
    required this.sold,
    required this.vat,
    required this.delivery_date,
    required this.km,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cc': cc,
      'chassis': chassis,
      'engineNo': engineNo,
      'color': color,
      'model': model,
      'remark': remark,
      'buyingPrice': buyingPrice,
      'invoice': invoice,
      'ttAmount': ttAmount,
      'portCost': portCost,
      'duty': duty,
      'cnf': cnf,
      'warfrent': warfrent,
      'others': others,
      'total': total,
      'sellingPrice': sellingPrice,
      'profit': profit,
      'invoiceRate': invoiceRate,
      'invoiceBdt': invoiceBdt,
      'ttRate': ttRate,
      'ttBdt': ttBdt,
      'vat': vat,
      'sold': sold,
      'delivery_date': delivery_date,
      'km': km,
    };
  }
  Chassis.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        cc = json['cc'],
        chassis = json['chassis'],
        engineNo = json['engineNo'],
        color = json['color'],
        model = json['model'],
        remark = json['remark'],
        buyingPrice = (json['buyingPrice'] as num).toDouble(),
        invoice = (json['invoice'] as num).toDouble(),
        ttAmount = (json['ttAmount'] as num).toDouble(),
        portCost = (json['portCost'] as num).toDouble(),
        duty = (json['duty'] as num).toDouble(),
        cnf = (json['cnf'] as num).toDouble(),
        warfrent = (json['warfrent'] as num).toDouble(),
        others = (json['others'] as num).toDouble(),
        total = (json['total'] as num).toDouble(),
        sellingPrice = (json['sellingPrice'] as num).toDouble(),
        profit = (json['profit'] as num).toDouble(),
        invoiceRate = (json['invoiceRate'] as num).toDouble(),
        invoiceBdt = (json['invoiceBdt'] as num).toDouble(),
        ttRate = (json['ttRate'] as num).toDouble(),
        ttBdt = (json['ttBdt'] as num).toDouble(),
        vat = json['vat'],
        sold = json['sold'],
        delivery_date = json['delivery_date'],
        km = json['km'];

}
