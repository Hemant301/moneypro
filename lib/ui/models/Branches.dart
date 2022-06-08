// To parse this JSON data, do
//
//     final branches = branchesFromJson(jsonString);

import 'dart:convert';

Branches branchesFromJson(String str) => Branches.fromJson(json.decode(str));

String branchesToJson(Branches data) => json.encode(data.toJson());

class Branches {
  Branches({
    required this.status,
    required this.transctionList,
    required this.totalPages,
  });

  String status;
  List<BranchList> transctionList;
  int totalPages;

  factory Branches.fromJson(Map<String, dynamic> json) => Branches(
        status: json["status"],
        transctionList: List<BranchList>.from(
            json["transction_list"].map((x) => BranchList.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transction_list":
            List<dynamic>.from(transctionList.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class BranchList {
  BranchList({
    required this.id,
    required this.branchName,
    required this.mobile,
    required this.managerName,
    required this.branchWallet,
    required this.photo,
    required this.branchQrId,
  });

  var id;
  var branchName;
  var mobile;
  var managerName;
  var branchWallet;
  var photo;
  var branchQrId;

  factory BranchList.fromJson(Map<String, dynamic> json) => BranchList(
      id: json["id"],
      branchName: json["branch_name"],
      mobile: json["mobile"],
      managerName: json["manager_name"],
      branchWallet: json["branch_wallet"],
      photo: json["photo"],
      branchQrId: json["branch_qrid"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_name": branchName,
        "mobile": mobile,
        "manager_name": managerName,
        "branch_wallet": branchWallet,
        "photo": photo,
        "branch_qrid": branchQrId
      };
}
