class MobilePlan{
  MobilePlan({
    this.planName,
    this.price,
    this.validity,
    this.talkTime,
    this.validityDescription,
    this.packageDescription,
    this.planType,
  });

  var planName;
  var price;
  var validity;
  var talkTime;
  var validityDescription;
  var packageDescription;
  var planType;

  factory MobilePlan.fromJson(Map<String, dynamic> json) => MobilePlan(
    planName: json["planName"],
    price: json["price"],
    validity: json["validity"],
    talkTime: json["talkTime"],
    validityDescription: json["validityDescription"],
    packageDescription: json["packageDescription"],
    planType: json["planType"],

  );

  Map<String, dynamic> toJson() => {
    "planName": planName,
    "price": price,
    "validity": validity,
    "talkTime": talkTime,
    "validityDescription": validityDescription,
    "packageDescription": packageDescription,
    "planType": planType,

  };
}