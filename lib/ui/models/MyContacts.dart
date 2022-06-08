class MyContacts {
  MyContacts({this.name, this.phone, this.isMP});

  var name;
  var phone;
  var isMP;

  factory MyContacts.fromJson(Map<String, dynamic> json) =>
      MyContacts(name: json["name"], phone: json["phone"], isMP: json["isMP"]);

  Map<String, dynamic> toJson() => {"name": name, "phone": phone, "isMP": isMP};

  @override
  String toString() {
    return """
{
  'name': $name,
  'phone': $phone,
  'isMP': $isMP,
}""";
  }

  @override
  bool operator ==(other) {
    if (other is! MyContacts) {
      return false;
    }

    return name == other.name && phone == other.phone;
  }

  @override
  int get hashCode => (name + phone).hashCode;
}
