// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Categories categoriesFromJson(String str) =>
    Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  Categories({
    required this.status,
    required this.categories,
  });

  String status;
  List<Category> categories;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        status: json["status"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.id,
    this.categoryName,
    this.mccCode,
    this.status,
  });

  var id;
  var categoryName;
  var mccCode;
  var status;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
        mccCode: json["mcc_code"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "mcc_code": mccCode,
        "status": status,
      };

  @override
  String toString() => categoryName;
}
