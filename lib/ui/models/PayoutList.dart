// To parse this JSON data, do
//
//     final payoutList = payoutListFromJson(jsonString);

import 'dart:convert';

PayoutList payoutListFromJson(String str) =>
    PayoutList.fromJson(json.decode(str));

String payoutListToJson(PayoutList data) => json.encode(data.toJson());

class PayoutList {
  PayoutList({
    required this.status,
    required this.payoutList,
    required this.totalPages,
  });

  String status;
  List<PayoutListElement> payoutList;
  int totalPages;

  factory PayoutList.fromJson(Map<String, dynamic> json) => PayoutList(
        status: json["status"],
        payoutList: List<PayoutListElement>.from(
            json["payout_list"].map((x) => PayoutListElement.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "payout_list": List<dynamic>.from(payoutList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class PayoutListElement {
  PayoutListElement({
    required this.date,
    required this.merchantRefId,
    required this.beneAccount,
    required this.ifscJcode,
    required this.beneName,
    required this.mobile,
    required this.amount,
    required this.status,
    required this.walletType
  });

  var date;
  var merchantRefId;
  var beneAccount;
  var ifscJcode;
  var beneName;
  var mobile;
  var amount;
  var status;
  var walletType;

  factory PayoutListElement.fromJson(Map<String, dynamic> json) =>
      PayoutListElement(
        date: json["date"],
        merchantRefId: json["merchantRefId"],
        beneAccount: json["bene_account"],
        ifscJcode: json["ifsc_jcode"],
        beneName: json["bene_name"],
        mobile: json["mobile"],
        amount: json["amount"],
        status: json["status"],
        walletType:json["wallet_type"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "merchantRefId": merchantRefId,
        "bene_account": beneAccount,
        "ifsc_jcode": ifscJcode,
        "bene_name": beneName,
        "mobile": mobile,
        "amount": amount,
        "status": status,
    "wallet_type":walletType
      };
}
