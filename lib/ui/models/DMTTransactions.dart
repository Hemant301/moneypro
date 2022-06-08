// To parse this JSON data, do
//
//     final dmtTransactions = dmtTransactionsFromJson(jsonString);

import 'dart:convert';

DmtTransactions dmtTransactionsFromJson(String str) =>
    DmtTransactions.fromJson(json.decode(str));

String dmtTransactionsToJson(DmtTransactions data) =>
    json.encode(data.toJson());

class DmtTransactions {
  DmtTransactions({
    required this.status,
    required this.transctionList,
    required this.totalPages,
  });

  String status;
  List<DMTList> transctionList;
  int totalPages;

  factory DmtTransactions.fromJson(Map<String, dynamic> json) =>
      DmtTransactions(
        status: json["status"],
        transctionList: List<DMTList>.from(
            json["transction_list"].map((x) => DMTList.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transction_list":
            List<dynamic>.from(transctionList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class DMTList {
  DMTList({
    required this.date,
    required this.accNo,
    required this.mobile,
    required this.transctionId,
    required this.amount,
    required this.customerCharge,
    required this.totalPayableAmnt,
    required this.merchantCommission,
    required this.mode,
    required this.status,
  });

  String date;
  String accNo;
  String mobile;
  String transctionId;
  String amount;
  String customerCharge;
  String totalPayableAmnt;
  String merchantCommission;
  String mode;
  String status;

  factory DMTList.fromJson(Map<String, dynamic> json) => DMTList(
        date: json["date"],
        accNo: json["acc_no"],
        mobile: json["mobile"],
        transctionId: json["transction_id"],
        amount: json["amount"],
        customerCharge: json["customer_charge"],
        totalPayableAmnt: json["total_payable_amnt"],
        merchantCommission: json["merchant_commission"] == null
            ? null
            : json["merchant_commission"],
        mode: json["mode"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "acc_no": accNo,
        "mobile": mobile,
        "transction_id": transctionId,
        "amount": amount,
        "customer_charge": customerCharge,
        "total_payable_amnt": totalPayableAmnt,
        "merchant_commission":
            merchantCommission == null ? null : merchantCommission,
        "mode": mode,
        "status": status,
      };
}
