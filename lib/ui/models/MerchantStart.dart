class MerchantStart {
  MerchantStart({
    this.image,
    this.title,
    this.subTitle,
  });

  var image;
  var title;
  var subTitle;

  factory MerchantStart.fromJson(Map<String, dynamic> json) => MerchantStart(
    image: json["image"],
    title: json["title"],
    subTitle: json["subTitle"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
    "subTitle": subTitle,
  };
}