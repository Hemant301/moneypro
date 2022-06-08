// To parse this JSON data, do
//
//     final qrImages = qrImagesFromJson(jsonString);

import 'dart:convert';

QrImages qrImagesFromJson(String str) => QrImages.fromJson(json.decode(str));

String qrImagesToJson(QrImages data) => json.encode(data.toJson());

class QrImages {
  QrImages({
    required this.status,
    required  this.qrimages,
  });

  String status;
  List<Qrimage> qrimages;

  factory QrImages.fromJson(Map<String, dynamic> json) => QrImages(
    status: json["status"],
    qrimages: List<Qrimage>.from(json["qrimages"].map((x) => Qrimage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "qrimages": List<dynamic>.from(qrimages.map((x) => x.toJson())),
  };
}

class Qrimage {
  Qrimage({
    required   this.id,
    required this.image,
    required this.status,
  });

  var id;
  var image;
  var status;

  factory Qrimage.fromJson(Map<String, dynamic> json) => Qrimage(
    id: json["id"],
    image: json["image"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "status": status,
  };
}
