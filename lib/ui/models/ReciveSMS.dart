class ReciveSMS {
  ReciveSMS({
    this.title,
    this.body,
    this.smsForm
  });

  var title;
  var body;
  var smsForm;

  factory ReciveSMS.fromJson(Map<String, dynamic> json) => ReciveSMS(
    title: json["title"],
    body: json["body"],
    smsForm: json["smsForm"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "smsForm": smsForm,
  };
}

class CreditCardSMS {
  CreditCardSMS({
    this.cardNo,
    this.totalAmt,
    this.minAmt,
    this.date
  });

  var cardNo;
  var totalAmt;
  var minAmt;
  var date;

  factory CreditCardSMS.fromJson(Map<String, dynamic> json) => CreditCardSMS(
    cardNo: json["cardNo"],
    totalAmt: json["totalAmt"],
    minAmt: json["minAmt"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "cardNo": cardNo,
    "totalAmt": totalAmt,
    "minAmt": minAmt,
    "date": date,
  };
}