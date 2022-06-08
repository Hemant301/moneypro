// To parse this JSON data, do
//
//     final aeps = aepsFromJson(jsonString);

import 'dart:convert';

Aeps aepsFromJson(String str) => Aeps.fromJson(json.decode(str));

String aepsToJson(Aeps data) => json.encode(data.toJson());

class Aeps {
  Aeps({
    required this.status,
    required this.transctionList,
    required this.totalPages,
  });

  String status;
  List<AEPSTransaction> transctionList;
  int totalPages;

  factory Aeps.fromJson(Map<String, dynamic> json) => Aeps(
        status: json["status"],
        transctionList: List<AEPSTransaction>.from(
            json["transction_list"].map((x) => AEPSTransaction.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transction_list":
            List<dynamic>.from(transctionList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class AEPSTransaction {
  AEPSTransaction(
      {required this.date,
      required this.transctionId,
      required this.refId,
      required this.amount,
      required this.mode,
      required this.status,
      required this.mobile,
      required this.adhar,
      required this.merchantCommission,
      required this.txnid});

  var date;
  var transctionId;
  var refId;
  var amount;
  var mode;
  var status;
  var mobile;
  var adhar;
  var merchantCommission;
  var txnid;

  factory AEPSTransaction.fromJson(Map<String, dynamic> json) =>
      AEPSTransaction(
        date: json["date"],
        transctionId: json["transction_id"],
        refId: json["refId"],
        amount: json["amount"],
        mode: json["mode"],
        status: json["status"],
        mobile: json["mobile"],
        adhar: json["adhar"],
        merchantCommission: json["merchant_commission"],
        txnid: json['txnid'],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "transction_id": transctionId,
        "refId": refId,
        "amount": amount,
        "mode": mode,
        "status": status,
        "mobile": mobile,
        "adhar": adhar,
        "merchant_commission": merchantCommission,
        "txnid": txnid
      };
}
