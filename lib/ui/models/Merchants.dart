// To parse this JSON data, do
//
//     final merchants = merchantsFromJson(jsonString);

import 'dart:convert';

Merchants merchantsFromJson(String str) => Merchants.fromJson(json.decode(str));

String merchantsToJson(Merchants data) => json.encode(data.toJson());

class Merchants {
  Merchants({
    required this.status,
    required this.merchantData,
  });

  String status;
  List<MerchantDatum> merchantData;

  factory Merchants.fromJson(Map<String, dynamic> json) => Merchants(
        status: json["status"],
        merchantData: List<MerchantDatum>.from(
            json["merchant_data"].map((x) => MerchantDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "merchant_data":
            List<dynamic>.from(merchantData.map((x) => x.toJson())),
      };
}

class MerchantDatum {
  MerchantDatum(
      {required this.firstName,
      required this.lastName,
      required this.merchantId,
      required this.mToken,
      required this.email,
      required this.mobile,
      required this.qr,
      required this.investor,
      required this.wpMsgStatus});

  var firstName;
  var lastName;
  var merchantId;
  var mToken;
  var email;
  var mobile;
  var qr;
  var investor;
  var wpMsgStatus;

  factory MerchantDatum.fromJson(Map<String, dynamic> json) => MerchantDatum(
        firstName: json["first_name"],
        lastName: json["last_name"],
        merchantId: json["merchant_id"],
        mToken: json["m_token"],
        email: json["email"],
        mobile: json["mobile"],
        qr: json["qr"] == null ? null : json["qr"],
        investor: json["investor"],
        wpMsgStatus: json["wp_msg_status"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "merchant_id": merchantId,
        "m_token": mToken,
        "email": email,
        "mobile": mobile,
        "qr": qr == null ? null : qr,
        "investor": investor,
        "wp_msg_status": wpMsgStatus,
      };
}
