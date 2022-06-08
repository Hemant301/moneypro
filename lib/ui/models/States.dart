// To parse this JSON data, do
//
//     final states = statesFromJson(jsonString);

import 'dart:convert';

States statesFromJson(String str) => States.fromJson(json.decode(str));

String statesToJson(States data) => json.encode(data.toJson());

class States {
  States({
    required this.isSuccess,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  bool isSuccess;
  String message;
  List<Datum> data;
  String statusCode;

  factory States.fromJson(Map<String, dynamic> json) => States(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "statusCode": statusCode,
      };
}

class Datum {
  Datum({
     this.key,
     this.value,
  });

  var key;
  var value;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
