// To parse this JSON data, do
//
//     final operators = operatorsFromJson(jsonString);

import 'dart:convert';

Operators operatorsFromJson(String str) => Operators.fromJson(json.decode(str));

String operatorsToJson(Operators data) => json.encode(data.toJson());

class Operators {
  Operators({
   required this.status,
    required  this.billerName,
  });

  String status;
  List<OperatorNames> billerName;

  factory Operators.fromJson(Map<String, dynamic> json) => Operators(
    status: json["status"],
    billerName: List<OperatorNames>.from(json["billerName"].map((x) => OperatorNames.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "billerName": List<dynamic>.from(billerName.map((x) => x.toJson())),
  };
}

class OperatorNames {
  OperatorNames({
    required   this.billerName,
    required   this.operatorCode,
    required  this.category,
    required  this.icons,
  });

  String billerName;
  String operatorCode;
  String category;
  String icons;

  factory OperatorNames.fromJson(Map<String, dynamic> json) => OperatorNames(
    billerName: json["billerName"],
    operatorCode: json["operator_code"],
    category: json["category"],
    icons: json["icons"],
  );

  Map<String, dynamic> toJson() => {
    "billerName": billerName,
    "operator_code": operatorCode,
    "category": category,
    "icons": icons,
  };
}

