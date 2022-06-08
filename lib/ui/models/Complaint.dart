// To parse this JSON data, do
//
//     final complaint = complaintFromJson(jsonString);

import 'dart:convert';

Complaint complaintFromJson(String str) => Complaint.fromJson(json.decode(str));

String complaintToJson(Complaint data) => json.encode(data.toJson());

class Complaint {
  Complaint({
    required this.status,
    required this.comList,
  });

  String status;
  List<ComList> comList;

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        status: json["status"],
        comList: List<ComList>.from(
            json["com_list"].map((x) => ComList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "com_list": List<dynamic>.from(comList.map((x) => x.toJson())),
      };
}

class ComList {
  ComList({
    required this.ticketId,
    required this.comListOperator,
    required this.amount,
    required this.status,
  });

  String ticketId;
  String comListOperator;
  String amount;
  String status;

  factory ComList.fromJson(Map<String, dynamic> json) => ComList(
        ticketId: json["ticket_id"],
        comListOperator: json["operator"],
        amount: json["amount"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "ticket_id": ticketId,
        "operator": comListOperator,
        "amount": amount,
        "status": status,
      };
}
