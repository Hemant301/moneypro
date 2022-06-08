// To parse this JSON data, do
//
//     final duePayment = duePaymentFromJson(jsonString);

import 'dart:convert';

DuePayment duePaymentFromJson(String str) => DuePayment.fromJson(json.decode(str));

String duePaymentToJson(DuePayment data) => json.encode(data.toJson());

class DuePayment {
  DuePayment({
  required  this.status,
    required   this.dueList,
  });

  String status;
  List<DueList> dueList;

  factory DuePayment.fromJson(Map<String, dynamic> json) => DuePayment(
    status: json["status"],
    dueList: List<DueList>.from(json["due_list"].map((x) => DueList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "due_list": List<dynamic>.from(dueList.map((x) => x.toJson())),
  };
}

class DueList {
  DueList({
    required   this.id,
    required   this.dueamount,
    required   this.duedate,
    required   this.loanAppId,
  });

  int id;
  String dueamount;
  dynamic duedate;
  String loanAppId;

  factory DueList.fromJson(Map<String, dynamic> json) => DueList(
    id: json["id"],
    dueamount: json["dueamount"],
    duedate: json["duedate"],
    loanAppId: json["loan_app_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dueamount": dueamount,
    "duedate": duedate,
    "loan_app_id": loanAppId,
  };
}
