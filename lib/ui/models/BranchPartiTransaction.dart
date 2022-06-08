// To parse this JSON data, do
//
//     final branchPartiTransaction = branchPartiTransactionFromJson(jsonString);

import 'dart:convert';

BranchPartiTransaction branchPartiTransactionFromJson(String str) => BranchPartiTransaction.fromJson(json.decode(str));

String branchPartiTransactionToJson(BranchPartiTransaction data) => json.encode(data.toJson());

class BranchPartiTransaction {
  BranchPartiTransaction({
   required this.status,
    required this.transctionList,
    required this.totalPages,
  });

  String status;
  List<BranchSelfTrans> transctionList;
  int totalPages;

  factory BranchPartiTransaction.fromJson(Map<String, dynamic> json) => BranchPartiTransaction(
    status: json["status"],
    transctionList: List<BranchSelfTrans>.from(json["transction_list"].map((x) => BranchSelfTrans.fromJson(x))),
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "transction_list": List<dynamic>.from(transctionList.map((x) => x.toJson())),
    "total_pages": totalPages,
  };
}

class BranchSelfTrans {
  BranchSelfTrans({
    required  this.date,
    required   this.transctionId,
    required   this.amount,
    required  this.branchName,
    required  this.time,
    required  this.name,
  });

  var date;
  var transctionId;
  var amount;
  var branchName;
  var time;
  var name;

  factory BranchSelfTrans.fromJson(Map<String, dynamic> json) => BranchSelfTrans(
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
    "branch_name": branchName,
    "time": time,
    "name": name,
  };
}
