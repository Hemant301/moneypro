// To parse this JSON data, do
//
//     final favourites = favouritesFromJson(jsonString);

import 'dart:convert';

Favourites favouritesFromJson(String str) =>
    Favourites.fromJson(json.decode(str));

String favouritesToJson(Favourites data) => json.encode(data.toJson());

class Favourites {
  Favourites({
    required this.status,
    required this.customerList,
  });

  String status;
  List<CustomerList> customerList;

  factory Favourites.fromJson(Map<String, dynamic> json) => Favourites(
        status: json["status"],
        customerList: List<CustomerList>.from(
            json["customer_list"].map((x) => CustomerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "customer_list":
            List<dynamic>.from(customerList.map((x) => x.toJson())),
      };
}

class CustomerList {
  CustomerList({
    required this.customerId,
    required this.customerName,
    required this.mobile,
  });

  String customerId;
  String customerName;
  String mobile;

  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "customer_name": customerName,
        "mobile": mobile,
      };
}
