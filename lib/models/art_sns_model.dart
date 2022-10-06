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
  final num price;
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
