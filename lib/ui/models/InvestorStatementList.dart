// To parse this JSON data, do
//
//     final investorStatementList = investorStatementListFromJson(jsonString);

import 'dart:convert';

InvestorStatementList investorStatementListFromJson(String str) =>
    InvestorStatementList.fromJson(json.decode(str));

String investorStatementListToJson(InvestorStatementList data) =>
    json.encode(data.toJson());

class InvestorStatementList {
  InvestorStatementList({
    required this.status,
    required this.invList,
    required this.totalPages,
  });

  String status;
  List<InvList> invList;
  int totalPages;

  factory InvestorStatementList.fromJson(Map<String, dynamic> json) =>
      InvestorStatementList(
        status: json["status"],
        invList: List<InvList>.from(
            json["inv_list"].map((x) => InvList.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "inv_list": List<dynamic>.from(invList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class InvList {
  InvList(
      {required this.date,
      required this.investAmount,
      required this.interset,
      required this.closingBal,
      required this.descp,
      required this.status,
      required this.interestDate,
      required this.merchantRefId});

  String date;
  String investAmount;
  String interset;
  String closingBal;
  String descp;
  int status;
  String interestDate;
  var merchantRefId;

  factory InvList.fromJson(Map<String, dynamic> json) => InvList(
      date: json["date"],
      investAmount: json["invest_amount"],
      interset: json["interset"],
      closingBal: json["closing_bal"],
      descp: json["descp"],
      status: json["status"],
      interestDate: json["interest_date"],
      merchantRefId: json["merchantRefId"]);

  Map<String, dynamic> toJson() => {
        "date": date,
        "invest_amount": investAmount,
        "interset": interset,
        "closing_bal": closingBal,
        "descp": descp,
        "status": status,
        "interest_date": interestDate,
        "merchantRefId": merchantRefId
      };
}
