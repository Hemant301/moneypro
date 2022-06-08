// To parse this JSON data, do
//
//     final billerList = billerListFromJson(jsonString);

import 'dart:convert';

BillerList billerListFromJson(String str) =>
    BillerList.fromJson(json.decode(str));

String billerListToJson(BillerList data) => json.encode(data.toJson());

class BillerList {
  BillerList({
    required this.status,
    required this.billerList,
  });

  String status;
  List<BillerListElement> billerList;

  factory BillerList.fromJson(Map<String, dynamic> json) => BillerList(
        status: json["status"],
        billerList: List<BillerListElement>.from(
            json["biller_list"].map((x) => BillerListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "biller_list": List<dynamic>.from(billerList.map((x) => x.toJson())),
      };
}

class BillerListElement {
  BillerListElement({
    required this.billerId,
    required this.billerName,
    required this.paramName,
    required this.paramName1,
    required this.paramName2,
    required this.paramName3,
    required this.paramName4,
    required this.icon,
    required this.isAdhoc,
    required this.fetchOption,
    required this.state,
    required this.position,
    required this.minLimit,
    required this.maxLimit,
  });

  var billerId;
  var billerName;
  var paramName;
  var paramName1;
  var paramName2;
  var paramName3;
  var paramName4;
  var icon;
  var isAdhoc;
  var fetchOption;
  var state;
  int position;
  var minLimit;
  var maxLimit;

  factory BillerListElement.fromJson(Map<String, dynamic> json) =>
      BillerListElement(
        billerId: json["billerId"],
        billerName: json["billerName"],
        paramName: json["paramName"],
        paramName1: json["paramName_1"],
        paramName2: json["paramName_2"],
        paramName3: json["paramName_3"],
        paramName4: json["paramName_4"],
        icon: json["icon"],
        isAdhoc: json["isAdhoc"],
        fetchOption: json["fetchOption"],
        state: json["state"],
        position: json["position"],
        minLimit: json["min_limit"],
        maxLimit: json["max_limit"],
      );

  Map<String, dynamic> toJson() => {
        "billerId": billerId,
        "billerName": billerName,
        "paramName": paramName,
        "paramName_1": paramName1,
        "paramName_2": paramName2,
        "paramName_3": paramName3,
        "paramName_4": paramName4,
        "icon": icon,
        "isAdhoc": isAdhoc,
        "fetchOption": fetchOption,
        "state": state,
        "position": position,
        "min_limit": minLimit,
        "max_limit": maxLimit,
      };
}
