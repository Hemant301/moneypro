// To parse this JSON data, do
//
//     final customerTransaction = customerTransactionFromJson(jsonString);

import 'dart:convert';

CustomerTransaction customerTransactionFromJson(String str) =>
    CustomerTransaction.fromJson(json.decode(str));

String customerTransactionToJson(CustomerTransaction data) =>
    json.encode(data.toJson());

class CustomerTransaction {
  CustomerTransaction({
    this.status,
    required this.custTransctionList,
  });

  var status;
  List<CustTransctionList> custTransctionList;

  factory CustomerTransaction.fromJson(Map<String, dynamic> json) =>
      CustomerTransaction(
        status: json["status"],
        custTransctionList: List<CustTransctionList>.from(
            json["cust_transction_list"]
                .map((x) => CustTransctionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cust_transction_list":
            List<dynamic>.from(custTransctionList.map((x) => x.toJson())),
      };
}

class CustTransctionList {
  CustTransctionList({
    this.date,
    this.transctionId,
    this.amount,
    this.mode,
    this.status,
  });

  var date;
  var transctionId;
  var amount;
  var mode;
  var status;

  factory CustTransctionList.fromJson(Map<String, dynamic> json) =>
      CustTransctionList(
        date: json["date"],
        transctionId: json["transction_id"],
        amount: json["amount"],
        mode: json["mode"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "transction_id": transctionId,
        "amount": amount,
        "mode": mode,
        "status": status,
      };
}
