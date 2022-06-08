// To parse this JSON data, do
//
//     final history = historyFromJson(jsonString);

import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  History({
    required this.status,
    required this.qrResponse,
  });

  String status;
  List<QrResponse> qrResponse;

  factory History.fromJson(Map<String, dynamic> json) => History(
        status: json["status"],
        qrResponse: List<QrResponse>.from(
            json["qr_response"].map((x) => QrResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "qr_response": List<dynamic>.from(qrResponse.map((x) => x.toJson())),
      };
}

class QrResponse {
  QrResponse({
    required this.date,
    required this.name,
    required this.amount,
    required this.status,
    required this.time,
  });

  String date;
  String name;
  String amount;
  String status;
  var time;

  factory QrResponse.fromJson(Map<String, dynamic> json) => QrResponse(
        date: json["date"],
        name: json["name"],
        amount: json["amount"],
        status: json["status"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "name": name,
        "amount": amount,
        "status": status,
        "time": time
      };
}
