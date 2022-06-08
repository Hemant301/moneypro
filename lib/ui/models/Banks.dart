// To parse this JSON data, do
//
//     final banks = banksFromJson(jsonString);

import 'dart:convert';

Banks banksFromJson(String str) => Banks.fromJson(json.decode(str));

String banksToJson(Banks data) => json.encode(data.toJson());

class Banks {
  Banks({
    required this.status,
    required this.data,
  });

  String status;
  List<BankList> data;

  factory Banks.fromJson(Map<String, dynamic> json) => Banks(
        status: json["status"],
        data: List<BankList>.from(json["data"].map((x) => BankList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BankList {
  BankList({
     this.id,
     this.bankName,
     this.logo,
     this.status,
     this.createdAt,
     this.updatedAt,
  });

  var id;
  var bankName;
  var logo;
  var status;
  var createdAt;
  var updatedAt;

  factory BankList.fromJson(Map<String, dynamic> json) => BankList(
        id: json["id"],
        bankName: json["bank_name"],
        logo: json["logo"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank_name": bankName,
        "logo": logo,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
