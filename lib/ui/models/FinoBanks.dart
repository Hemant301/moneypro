// To parse this JSON data, do
//
//     final finoBanks = finoBanksFromJson(jsonString);

import 'dart:convert';

FinoBanks finoBanksFromJson(String str) => FinoBanks.fromJson(json.decode(str));

String finoBanksToJson(FinoBanks data) => json.encode(data.toJson());

class FinoBanks {
  FinoBanks({
    required this.status,
    required this.response,
  });

  String status;
  Response response;

  factory FinoBanks.fromJson(Map<String, dynamic> json) => FinoBanks(
        status: json["status"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  Response({
    required this.status,
    required this.responseCode,
    required this.banklist,
    required this.message,
  });

  bool status;
  int responseCode;
  Banklist banklist;
  String message;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        responseCode: json["response_code"],
        banklist: Banklist.fromJson(json["banklist"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response_code": responseCode,
        "banklist": banklist.toJson(),
        "message": message,
      };
}

class Banklist {
  Banklist({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Banklist.fromJson(Map<String, dynamic> json) => Banklist(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.bankName,
    required this.iinno,
    required this.activeFlag,
    required this.aadharpayiinno,
  });

  var id;
  var bankName;
  var iinno;
  var activeFlag;
  var aadharpayiinno;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        bankName: json["bankName"],
        iinno: json["iinno"],
        activeFlag: json["activeFlag"],
        aadharpayiinno: json["aadharpayiinno"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bankName": bankName,
        "iinno": iinno,
        "activeFlag": activeFlag,
        "aadharpayiinno": aadharpayiinno,
      };
}
