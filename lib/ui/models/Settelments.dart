// To parse this JSON data, do
//
//     final settelments = settelmentsFromJson(jsonString);

import 'dart:convert';

Settelments settelmentsFromJson(String str) =>
    Settelments.fromJson(json.decode(str));

String settelmentsToJson(Settelments data) => json.encode(data.toJson());

class Settelments {
  Settelments({
    required this.status,
    required this.requestList,
    required this.totalPages,
  });

  String status;
  List<RequestList> requestList;
  int totalPages;

  factory Settelments.fromJson(Map<String, dynamic> json) => Settelments(
        status: json["status"],
        requestList: List<RequestList>.from(
            json["request_list"].map((x) => RequestList.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "request_list": List<dynamic>.from(requestList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class RequestList {
  RequestList(
      {required this.date,
      required this.transctionId,
      required this.amount,
      required this.status,
      required this.bankName,
      required this.branch});

  var date;
  var transctionId;
  var amount;
  var status;
  var bankName;
  var branch;

  factory RequestList.fromJson(Map<String, dynamic> json) => RequestList(
        date: json["date"],
        transctionId: json["transction_id"],
        amount: json["amount"],
        status: json["status"],
        bankName: json["bank_name"],
        branch: json["branch"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "transction_id": transctionId,
        "amount": amount,
        "status": status,
        "bank_name": bankName,
        "branch": branch,
      };
}
