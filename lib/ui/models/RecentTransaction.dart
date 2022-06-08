// To parse this JSON data, do
//
//     final recentTransaction = recentTransactionFromJson(jsonString);

import 'dart:convert';

RecentTransaction recentTransactionFromJson(String str) => RecentTransaction.fromJson(json.decode(str));

String recentTransactionToJson(RecentTransaction data) => json.encode(data.toJson());

class RecentTransaction {
  RecentTransaction({
   required this.status,
    required this.resentList,
  });

  String status;
  List<ResentList> resentList;

  factory RecentTransaction.fromJson(Map<String, dynamic> json) => RecentTransaction(
    status: json["status"],
    resentList: List<ResentList>.from(json["resent_list"].map((x) => ResentList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "resent_list": List<dynamic>.from(resentList.map((x) => x.toJson())),
  };
}

class ResentList {
  ResentList({
    this.date,
    this.transctionId,
    this.amount,
    this.category,
    this.operatorName,
    this.param,
  });

  var date;
  var transctionId;
  var amount;
  var category;
  var operatorName;
  var param;

  factory ResentList.fromJson(Map<String, dynamic> json) => ResentList(
    date: json["date"],
    transctionId: json["transction_id"],
    amount: json["amount"],
    category: json["category"],
    operatorName: json["operator_name"],
    param: json["param"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "transction_id": transctionId,
    "amount": amount,
    "category": category,
    "operator_name": operatorName,
    "param": param,
  };
}
