// To parse this JSON data, do
//
//     final walletTransactions = walletTransactionsFromJson(jsonString);

import 'dart:convert';

WalletTransactions walletTransactionsFromJson(String str) =>
    WalletTransactions.fromJson(json.decode(str));

String walletTransactionsToJson(WalletTransactions data) =>
    json.encode(data.toJson());

class WalletTransactions {
  WalletTransactions({
    required this.status,
    required this.walletList,
    required this.totalPages,
  });

  String status;
  List<WalletList> walletList;
  int totalPages;

  factory WalletTransactions.fromJson(Map<String, dynamic> json) =>
      WalletTransactions(
        status: json["status"],
        walletList: List<WalletList>.from(
            json["wallet_list"].map((x) => WalletList.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "wallet_list": List<dynamic>.from(walletList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class WalletList {
  WalletList({
    required this.type,
    required this.date,
    required this.time,
    required this.transctionId,
    required this.heading,
    required this.description,
    required this.txnAmnt,
    required this.txnBal,
    required this.commission,
    required this.comBal,
    required this.headingS,
    required this.descriptionS,
    required this.txn_type,
  });

  var type;
  var txn_type;
  var date;
  var time;
  var transctionId;
  var heading;
  var description;
  var txnAmnt;
  var txnBal;
  var commission;
  var comBal;
  var headingS;
  var descriptionS;

  factory WalletList.fromJson(Map<String, dynamic> json) => WalletList(
        type: json["type"],
        txn_type: json["txn_type"],
        date: json["date"],
        time: json["time"],
        transctionId: json["transction_id"],
        heading: json["heading"],
        description: json["description"],
        txnAmnt: json["txn_amnt"],
        txnBal: json["txn_bal"],
        commission: json["commission"],
        comBal: json["com_bal"],
        headingS: json["heading_s"],
        descriptionS: json["description_s"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "date": date,
        "time": time,
        "transction_id": transctionId,
        "heading": heading,
        "description": description,
        "txn_amnt": txnAmnt,
        "txn_bal": txnBal,
        "commission": commission,
        "com_bal": comBal,
        "heading_s": headingS,
        "description_s": descriptionS,
      };
}
