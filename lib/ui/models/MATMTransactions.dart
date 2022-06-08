// To parse this JSON data, do
//
//     final matmTransactions = matmTransactionsFromJson(jsonString);

import 'dart:convert';

MatmTransactions matmTransactionsFromJson(String str) =>
    MatmTransactions.fromJson(json.decode(str));

String matmTransactionsToJson(MatmTransactions data) =>
    json.encode(data.toJson());

class MatmTransactions {
  MatmTransactions({
    required this.status,
    required this.transctionList,
    required this.totalPages,
  });

  String status;
  List<MATMTransaction> transctionList;
  int totalPages;

  factory MatmTransactions.fromJson(Map<String, dynamic> json) =>
      MatmTransactions(
        status: json["status"],
        transctionList: List<MATMTransaction>.from(
            json["transction_list"].map((x) => MATMTransaction.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transction_list":
            List<dynamic>.from(transctionList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class MATMTransaction {
  MATMTransaction(
      {required this.date,
      required this.transctionId,
      required this.refId,
      required this.amount,
      required this.bankName,
      required this.status,
      required this.cardNo,
      required this.terminalId,
      required this.merchantCommission,
      required this.rrn,
      required this.txnid});

  var date;
  var transctionId;
  var refId;
  var amount;
  var bankName;
  var status;
  var cardNo;
  var terminalId;
  var merchantCommission;
  var rrn;
  var txnid;

  factory MATMTransaction.fromJson(Map<String, dynamic> json) =>
      MATMTransaction(
        date: json["date"],
        transctionId: json["transction_id"],
        refId: json["refId"],
        amount: json["amount"],
        bankName: json["bank_name"],
        status: json["status"],
        cardNo: json["card_no"],
        terminalId: json["terminalId"],
        merchantCommission: json["merchant_commission"],
        rrn: json["rrn"],
        txnid: json["txnid"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "transction_id": transctionId,
        "refId": refId,
        "amount": amount,
        "bank_name": bankName,
        "status": status,
        "card_no": cardNo,
        "terminalId": terminalId,
        "merchant_commission": merchantCommission,
        "rrn": rrn,
        "txnid": txnid,
      };
}
