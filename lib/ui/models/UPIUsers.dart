// To parse this JSON data, do
//
//     final upiUsers = upiUsersFromJson(jsonString);

import 'dart:convert';

UpiUsers upiUsersFromJson(String str) => UpiUsers.fromJson(json.decode(str));

String upiUsersToJson(UpiUsers data) => json.encode(data.toJson());

class UpiUsers {
  UpiUsers({
    required this.status,
    required this.data,
  });

  String status;
  List<UPIUserList> data;

  factory UpiUsers.fromJson(Map<String, dynamic> json) => UpiUsers(
        status: json["status"],
        data: List<UPIUserList>.from(
            json["data"].map((x) => UPIUserList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class UPIUserList {
  UPIUserList(
      {required this.upiId, required this.holderName, required this.status});

  String upiId;
  String holderName;
  var status;

  factory UPIUserList.fromJson(Map<String, dynamic> json) => UPIUserList(
        upiId: json["upi_id"],
        holderName: json["holder_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {"upi_id": upiId, "holder_name": holderName, "status": status};
}
