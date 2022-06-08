// To parse this JSON data, do
//
//     final qrList = qrListFromJson(jsonString);

import 'dart:convert';

QrList qrListFromJson(String str) => QrList.fromJson(json.decode(str));

String qrListToJson(QrList data) => json.encode(data.toJson());

class QrList {
  QrList({
    required this.status,
    required this.qr,
  });

  String status;
  List<Qr> qr;

  factory QrList.fromJson(Map<String, dynamic> json) => QrList(
        status: json["status"],
        qr: List<Qr>.from(json["qr"].map((x) => Qr.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "qr": List<dynamic>.from(qr.map((x) => x.toJson())),
      };
}

class Qr {
  Qr({
    required this.qrString,
    required this.merchantVpa,
  });

  String qrString;
  String merchantVpa;

  factory Qr.fromJson(Map<String, dynamic> json) => Qr(
        qrString: json["qrString"],
        merchantVpa: json["merchantVpa"],
      );

  Map<String, dynamic> toJson() => {
        "qrString": qrString,
        "merchantVpa": merchantVpa,
      };
}
