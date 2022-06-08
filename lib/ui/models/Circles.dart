// To parse this JSON data, do
//
//     final circles = circlesFromJson(jsonString);

import 'dart:convert';

Circles circlesFromJson(String str) => Circles.fromJson(json.decode(str));

String circlesToJson(Circles data) => json.encode(data.toJson());

class Circles {
  Circles({
   required this.status,
    required this.stateList,
  });

  String status;
  List<StateList> stateList;

  factory Circles.fromJson(Map<String, dynamic> json) => Circles(
    status: json["status"],
    stateList: List<StateList>.from(json["state"].map((x) => StateList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "state": List<dynamic>.from(stateList.map((x) => x.toJson())),
  };
}

class StateList {
  StateList({
    required  this.state,
    required  this.code,
  });

  String state;
  String code;

  factory StateList.fromJson(Map<String, dynamic> json) => StateList(
    state: json["state"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "state": state,
    "code": code,
  };
}
