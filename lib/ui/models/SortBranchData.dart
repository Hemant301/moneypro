// To parse this JSON data, do
//
//     final sortBranchData = sortBranchDataFromJson(jsonString);

import 'dart:convert';

SortBranchData sortBranchDataFromJson(String str) =>
    SortBranchData.fromJson(json.decode(str));

String sortBranchDataToJson(SortBranchData data) => json.encode(data.toJson());

class SortBranchData {
  SortBranchData({
    required this.status,
    required this.todayTxn,
    required this.totalAmount,
  });

  String status;
  List<TodayTxn> todayTxn;
  var totalAmount;

  factory SortBranchData.fromJson(Map<String, dynamic> json) => SortBranchData(
        status: json["status"],
        todayTxn: List<TodayTxn>.from(
            json["today_txn"].map((x) => TodayTxn.fromJson(x))),
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "today_txn": List<dynamic>.from(todayTxn.map((x) => x.toJson())),
        "total_amount": totalAmount,
      };
}

class TodayTxn {
  TodayTxn({
    required this.date,
    required this.time,
    required this.name,
    required this.transctionId,
    required this.amount,
    required this.status,
  });

  var date;
  String time;
  String name;
  String transctionId;
  String amount;
  String status;

  factory TodayTxn.fromJson(Map<String, dynamic> json) => TodayTxn(
        date: json["date"],
        time: json["time"],
        name: json["name"],
        transctionId: json["transction_id"],
        amount: json["amount"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "date":date,
        "time": time,
        "name": name,
        "transction_id": transctionId,
        "amount": amount,
        "status": status,
      };
}
