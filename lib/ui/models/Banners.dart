// To parse this JSON data, do
//
//     final banners = bannersFromJson(jsonString);

import 'dart:convert';

Banners bannersFromJson(String str) => Banners.fromJson(json.decode(str));

String bannersToJson(Banners data) => json.encode(data.toJson());

class Banners {
  Banners({
    required this.status,
    required this.bannerList,
  });

  String status;
  List<BannerList> bannerList;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
        status: json["status"],
        bannerList: List<BannerList>.from(
            json["banner_list"].map((x) => BannerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "banner_list": List<dynamic>.from(bannerList.map((x) => x.toJson())),
      };
}

class BannerList {
  BannerList({
    required this.id,
    required this.image,
    required this.position,
    required this.pageName,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
  });

  int id;
  var image;
  var position;
  var pageName;
  int status;
  DateTime updatedAt;
  DateTime createdAt;

  factory BannerList.fromJson(Map<String, dynamic> json) => BannerList(
        id: json["id"],
        image: json["image"],
        position: json["position"],
        pageName: json["page_name"],
        status: json["status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "position": position,
        "page_name": pageName,
        "status": status,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
