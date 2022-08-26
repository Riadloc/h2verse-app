class ArtSnsList {
  ArtSnsList({
    required this.list,
    required this.count,
  });

  final List<ArtSns> list;
  final int count;

  Map<String, Object> toJson(ArtSnsList instance) => {
        "list": instance.list,
        "count": instance.count,
      };

  factory ArtSnsList.fromJson(Map<String, dynamic> json) => ArtSnsList(
        list: List<ArtSns>.from(json["list"].map((x) => ArtSns.fromJson(x))),
        count: json["count"],
      );
}

class ArtSns {
  ArtSns({
    required this.id,
    required this.copies,
    required this.realCopies,
    required this.serial,
    required this.price,
    required this.goodNo,
    required this.status,
  });

  final String id;
  final int copies;
  final dynamic realCopies;
  final String serial;
  final int price;
  final String goodNo;
  final int status;

  factory ArtSns.fromJson(Map<String, dynamic> json) => ArtSns(
        id: json["id"],
        copies: json["copies"],
        realCopies: json["realCopies"],
        serial: json["serial"],
        price: json["price"],
        goodNo: json["goodNo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "copies": copies,
        "realCopies": realCopies,
        "serial": serial,
        "price": price,
        "goodNo": goodNo,
        "status": status,
      };
}
