// To parse this JSON data, do
//
//     final accountList = accountListFromJson(jsonString);

import 'dart:convert';

AccountList accountListFromJson(String str) =>
    AccountList.fromJson(json.decode(str));

String accountListToJson(AccountList data) => json.encode(data.toJson());

class AccountList {
  AccountList({
    required this.status,
    required this.data,
  });

  String status;
  List<Datum> data;

  factory AccountList.fromJson(Map<String, dynamic> json) => AccountList(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {required this.accountNo,
      required this.ifsc,
      required this.accHolderName,
      required this.logo,
      required this.status});

  String accountNo;
  String ifsc;
  String accHolderName;
  var logo;
  var status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        accountNo: json["account_no"],
        ifsc: json["ifsc"],
        accHolderName: json["acc_holder_name"],
        logo: json["logo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "account_no": accountNo,
        "ifsc": ifsc,
        "acc_holder_name": accHolderName,
        "logo": logo,
        "status": status
      };
}
