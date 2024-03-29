class MarketItem {
  MarketItem({
    required this.id,
    required this.price,
    required this.name,
    required this.originPrice,
    required this.cover,
    required this.goodNo,
    this.serial,
    this.copies,
  });
  late final String id;
  late final num price;
  late final String? serial;
  late final String name;
  late final String goodNo;
  late final int? copies;
  late final String cover;
  late final num? originPrice;

  MarketItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    serial = json['serial'];
    name = json['name'];
    goodNo = json['goodNo'];
    copies = json['copies'];
    cover = json['cover'];
    originPrice = json['originPrice'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['price'] = price;
    _data['serial'] = serial;
    _data['name'] = name;
    _data['goodNo'] = goodNo;
    _data['copies'] = copies;
    _data['cover'] = cover;
    _data['originPrice'] = originPrice;
    return _data;
  }
}
