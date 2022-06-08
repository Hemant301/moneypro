// To parse this JSON data, do
//
//     final mpContacts = mpContactsFromJson(jsonString);

import 'dart:convert';

MpContacts mpContactsFromJson(String str) => MpContacts.fromJson(json.decode(str));

String mpContactsToJson(MpContacts data) => json.encode(data.toJson());

class MpContacts {
  MpContacts({
  required  this.status,
    required  this.phoneList,
  });

  String status;
  List<Map<String, bool>> phoneList;

  factory MpContacts.fromJson(Map<String, dynamic> json) => MpContacts(
    status: json["status"],
    phoneList: List<Map<String, bool>>.from(json["phone_list"].map((x) => Map.from(x).map((k, v) => MapEntry<String, bool>(k, v)))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "phone_list": List<dynamic>.from(phoneList.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}
