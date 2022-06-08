class NewMobilePlans{
  NewMobilePlans({
    this.rs,
    this.desc,
    this.validity,
    this.last_update,
    this.planType,
  });

  var rs;
  var desc;
  var validity;
  var last_update;
  var planType;

  factory NewMobilePlans.fromJson(Map<String, dynamic> json) => NewMobilePlans(
    rs: json["rs"],
    desc: json["desc"],
    validity: json["validity"],
    last_update: json["last_update"],
    planType: json["planType"],

  );

  Map<String, dynamic> toJson() => {
    "rs": rs,
    "desc": desc,
    "validity": validity,
    "last_update": last_update,
    "planType": planType,
  };
}