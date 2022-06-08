// To parse this JSON data, do
//
//     final branchTransHistory = branchTransHistoryFromJson(jsonString);

import 'dart:convert';

BranchTransHistory branchTransHistoryFromJson(String str) =>
    BranchTransHistory.fromJson(json.decode(str));

String branchTransHistoryToJson(BranchTransHistory data) =>
    json.encode(data.toJson());

class BranchTransHistory {
  BranchTransHistory({
    required this.status,
    required this.transctionList,
    required this.totalPages,
  });

  String status;
  List<TransctionList> transctionList;
  int totalPages;

  factory BranchTransHistory.fromJson(Map<String, dynamic> json) =>
      BranchTransHistory(
        status: json["status"],
        transctionList: List<TransctionList>.from(
            json["transction_list"].map((x) => TransctionList.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transction_list":
            List<dynamic>.from(transctionList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class TransctionList {
  TransctionList({
    required this.date,
    required this.transctionId,
    required this.amount,
    required this.branchName,
    required this.time,
    required this.name,
  });

  var date;
  var transctionId;
  var amount;
  var branchName;
  var time;
  var name;

  factory TransctionList.fromJson(Map<String, dynamic> json) => TransctionList(
        date: json["date"],
        transctionId: json["transction_id"],
        amount: json["amount"],
        branchName: json["branch_name"],
        time: json["time"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "transction_id": transctionId,
        "amount": amount,
        "time": time,
        "name": name,
      };
}
