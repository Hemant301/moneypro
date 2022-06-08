// To parse this JSON data, do
//
//     final reward = rewardFromJson(jsonString);

import 'dart:convert';

Reward rewardFromJson(String str) => Reward.fromJson(json.decode(str));

String rewardToJson(Reward data) => json.encode(data.toJson());

class Reward {
  Reward({
    required this.status,
    required this.comissionList,
    required this.totalPages,
  });

  String status;
  List<ComissionList> comissionList;
  int totalPages;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        status: json["status"],
        comissionList: List<ComissionList>.from(
            json["comission_list"].map((x) => ComissionList.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "comission_list":
            List<dynamic>.from(comissionList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class ComissionList {
  ComissionList({
    required this.txnId,
    required this.commission,
    required this.scratchSttatus,
  });

  String txnId;
  String commission;
  int scratchSttatus;

  factory ComissionList.fromJson(Map<String, dynamic> json) => ComissionList(
        txnId: json["txn_id"],
        commission: json["commission"],
        scratchSttatus: json["scratch_sttatus"],
      );

  Map<String, dynamic> toJson() => {
        "txn_id": txnId,
        "commission": commission,
        "scratch_sttatus": scratchSttatus,
      };
}
