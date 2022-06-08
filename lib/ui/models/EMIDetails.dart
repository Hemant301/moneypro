class EMIDetails{
  EMIDetails({
    this.year,
    this.per1,
    this.per2,
    this.per3,
  });

  var year;
  var per1;
  var per2;
  var per3;

  factory EMIDetails.fromJson(Map<String, dynamic> json) => EMIDetails(
    year: json["year"],
    per1: json["per1"],
    per2: json["per2"],
    per3: json["per3"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "per1": per1,
    "per2": per2,
    "per3": per3,
  };
}