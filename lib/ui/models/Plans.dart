// To parse this JSON data, do
//
//     final plans = plansFromJson(jsonString);

import 'dart:convert';

Plans plansFromJson(String str) => Plans.fromJson(json.decode(str));

String plansToJson(Plans data) => json.encode(data.toJson());

class Plans {
  Plans({
    required this.status,
    required this.planList,
  });

  String status;
  List<PlanList> planList;

  factory Plans.fromJson(Map<String, dynamic> json) => Plans(
        status: json["status"],
        planList: List<PlanList>.from(
            json["plan_list"].map((x) => PlanList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "plan_list": List<dynamic>.from(planList.map((x) => x.toJson())),
      };
}

class PlanList {
  PlanList({
    required this.id,
    required this.operatorId,
    required this.circleId,
    required this.rechargeAmount,
    required this.rechargeTalktime,
    required this.rechargeValidity,
    required this.rechargeShortDesc,
    required this.rechargeLongDesc,
    required this.rechargeType,
  });

  String id;
  String operatorId;
  String circleId;
  String rechargeAmount;
  String rechargeTalktime;
  String rechargeValidity;
  String rechargeShortDesc;
  String rechargeLongDesc;
  String rechargeType;

  factory PlanList.fromJson(Map<String, dynamic> json) => PlanList(
        id: json["id"],
        operatorId: json["operator_id"],
        circleId: json["circle_id"],
        rechargeAmount: json["recharge_amount"],
        rechargeTalktime: json["recharge_talktime"],
        rechargeValidity: json["recharge_validity"],
        rechargeShortDesc: json["recharge_short_desc"],
        rechargeLongDesc: json["recharge_long_desc"],
        rechargeType: json["recharge_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "operator_id": operatorId,
        "circle_id": circleId,
        "recharge_amount": rechargeAmount,
        "recharge_talktime": rechargeTalktime,
        "recharge_validity": [rechargeValidity],
        "recharge_short_desc": [rechargeShortDesc],
        "recharge_long_desc": rechargeLongDesc,
        "recharge_type": [rechargeType],
      };
}
