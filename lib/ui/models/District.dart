// To parse this JSON data, do
//
//     final district = districtFromJson(jsonString);

import 'dart:convert';

District districtFromJson(String str) => District.fromJson(json.decode(str));

String districtToJson(District data) => json.encode(data.toJson());

class District {
  District({
   required this.isSuccess,
    required  this.message,
    required this.data,
    required this.statusCode,
  });

  bool isSuccess;
  String message;
  List<DistrictList> data;
  String statusCode;

  factory District.fromJson(Map<String, dynamic> json) => District(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<DistrictList>.from(json["data"].map((x) => DistrictList.fromJson(x))),
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "statusCode": statusCode,
  };
}

class DistrictList {
  DistrictList({
      this.key,
    this.value,
  });

  var key;
  var value;

  factory DistrictList.fromJson(Map<String, dynamic> json) => DistrictList(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}
