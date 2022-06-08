class BBPSTransaction {
  BBPSTransaction({
    required this.date,
    required this.transction_id,
    required this.refId,
    required this.amount,
    required this.category,
    required this.operator_name,
    required this.status,
    required this.parameter,
    required this.wallet,
    required this.paymentgateway_amount,
    required this.paymentgateway_txn,
    required this.commission,
    required this.txnKey,
  });

  var date;
  var transction_id;
  var refId;
  var amount;
  var operator_name;
  var category;
  var status;
  var parameter;
  var wallet;
  var paymentgateway_amount;
  var paymentgateway_txn;
  var commission;
  var txnKey;

  factory BBPSTransaction.fromJson(Map<String, dynamic> json) =>
      BBPSTransaction(
        date: json["date"],
        transction_id: json["transction_id"],
        refId: json["refId"],
        amount: json["amount"],
        category: json["category"],
        operator_name: json["operator_name"],
        status: json["status"],
        parameter: json["parameter"],
        wallet: json["wallet"],
        paymentgateway_amount: json["paymentgateway_amount"],
        paymentgateway_txn: json["paymentgateway_txn"],
        commission: json["commission"],
        txnKey: json['txn_key'],

      );

  Map<String, dynamic> toJson() =>
      {
        "date": date,
        "transction_id": transction_id,
        "refId": refId,
        "amount": amount,
        "category": category,
        "operator_name": operator_name,
        "status": status,
        "parameter": parameter,
        "wallet": wallet,
        "paymentgateway_amount": paymentgateway_amount,
        "paymentgateway_txn": paymentgateway_txn,
        "commission": commission,
        "txn_key": txnKey,
      };
}
