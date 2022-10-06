class Order {
  Order({
    required this.id,
    required this.orderNo,
    required this.price,
    required this.seller,
    required this.cover,
    required this.name,
    required this.buyCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String orderNo;
  late final num? price;
  late final String seller;
  late final String cover;
  late final String name;
  late final int buyCount;
  late final int status;
  late final String createdAt;
  late final String updatedAt;

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['orderNo'];
    price = json['price'];
    seller = json['seller'];
    cover = json['cover'];
    name = json['name'];
    buyCount = json['buyCount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['orderNo'] = orderNo;
    _data['price'] = price;
    _data['seller'] = seller;
    _data['cover'] = cover;
    _data['name'] = name;
    _data['buyCount'] = buyCount;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }

  factory Order.empty() => Order(
        id: '',
        orderNo: '',
        price: 0,
        seller: '',
        cover: '',
        name: '',
        buyCount: 1,
        status: -1,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );
}
