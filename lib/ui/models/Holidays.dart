class Holidays{
  Holidays({
    this.id,
    this.date,
    this.holidayType,
    this.holidayName,
  });

  var id;
  var date;
  var holidayType;
  var holidayName;

  factory Holidays.fromJson(Map<String, dynamic> json) => Holidays(
    id: json["id"],
    date: json["date"],
    holidayType: json["holidayType"],
    holidayName: json["holidayName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "holidayType": holidayType,
    "holidayName": holidayName,
  };
}

