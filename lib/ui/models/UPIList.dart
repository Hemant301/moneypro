class UPIList {
  UPIList({
    this.name,
    this.id,
  });

  var name;
  var id;

  factory UPIList.fromJson(Map<String, dynamic> json) => UPIList(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}