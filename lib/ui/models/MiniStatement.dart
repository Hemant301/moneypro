// To parse this JSON data, do
//
//     final miniStatement = miniStatementFromJson(jsonString);

import 'dart:convert';

MiniStatement miniStatementFromJson(String str) =>
    MiniStatement.fromJson(json.decode(str));

String miniStatementToJson(MiniStatement data) => json.encode(data.toJson());

class MiniStatement {
  MiniStatement({
    required this.isSuccess,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  bool isSuccess;
  String message;
  Data data;
  String statusCode;

  factory MiniStatement.fromJson(Map<String, dynamic> json) => MiniStatement(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": data.toJson(),
        "statusCode": statusCode,
      };
}

class Data {
  Data({
    required this.terminalId,
    required this.bankResponseMsg,
    required this.remainingBalance,
    required this.rrn,
    required this.stan,
    required this.npciCode,
    required this.customerMobileNo,
    required this.customerName,
    required this.partnerRefId,
    required this.passbook,
    required this.aadhaarNo,
    required this.merchantMobileNo,
    required this.merchantEmailId,
    required this.merchantName,
    required this.bankIin,
    required this.amount,
    required this.merchantLocation,
    required this.merchantId,
    required this.txnCode,
    required this.txnDate,
    required this.bankName,
  });

  var terminalId;
  var bankResponseMsg;
  var remainingBalance;
  var rrn;
  var stan;
  var npciCode;
  var customerMobileNo;
  var customerName;
  var partnerRefId;
  List<Passbook> passbook;
  var aadhaarNo;
  var merchantMobileNo;
  var merchantEmailId;
  var merchantName;
  var bankIin;
  var amount;
  var merchantLocation;
  var merchantId;
  var txnCode;
  var txnDate;
  var bankName;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        terminalId: json["terminalId"],
        bankResponseMsg: json["bankResponseMsg"],
        remainingBalance: json["remainingBalance"].toDouble(),
        rrn: json["rrn"],
        stan: json["stan"],
        npciCode: json["npciCode"],
        customerMobileNo: json["customerMobileNo"],
        customerName: json["customerName"],
        partnerRefId: json["partnerRefId"],
        passbook: List<Passbook>.from(
            json["passbook"].map((x) => Passbook.fromJson(x))),
        aadhaarNo: json["aadhaarNo"],
        merchantMobileNo: json["merchantMobileNo"],
        merchantEmailId: json["merchantEmailId"],
        merchantName: json["merchantName"],
        bankIin: json["bankIIN"],
        amount: json["amount"],
        merchantLocation: json["merchantLocation"],
        merchantId: json["merchant_Id"],
        txnCode: json["txnCode"],
        txnDate: DateTime.parse(json["txnDate"]),
        bankName: json["bankName"],
      );

  Map<String, dynamic> toJson() => {
        "terminalId": terminalId,
        "bankResponseMsg": bankResponseMsg,
        "remainingBalance": remainingBalance,
        "rrn": rrn,
        "stan": stan,
        "npciCode": npciCode,
        "customerMobileNo": customerMobileNo,
        "customerName": customerName,
        "partnerRefId": partnerRefId,
        "passbook": List<dynamic>.from(passbook.map((x) => x.toJson())),
        "aadhaarNo": aadhaarNo,
        "merchantMobileNo": merchantMobileNo,
        "merchantEmailId": merchantEmailId,
        "merchantName": merchantName,
        "bankIIN": bankIin,
        "amount": amount,
        "merchantLocation": merchantLocation,
        "merchant_Id": merchantId,
        "txnCode": txnCode,
        "txnDate": txnDate.toIso8601String(),
        "bankName": bankName,
      };
}

class Passbook {
  Passbook({
    required this.date,
    required this.txnType,
    required this.amount,
    required this.narration,
  });

  var date;
  var txnType;
  var amount;
  var narration;

  factory Passbook.fromJson(Map<String, dynamic> json) => Passbook(
        date: json["date"],
        txnType: json["txnType"],
        amount: json["amount"],
        narration: json["narration"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "txnType": txnType,
        "amount": amount,
        "narration": narration,
      };
}
