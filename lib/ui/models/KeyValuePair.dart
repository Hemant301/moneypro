class KeyValuePair {
  KeyValuePair({
    this.key,
    this.value,
  });

  var key;
  var value;

  factory KeyValuePair.fromJson(Map<String, dynamic> json) => KeyValuePair(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}