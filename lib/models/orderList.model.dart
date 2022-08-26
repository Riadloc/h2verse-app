class OrderList {
  OrderList({
    required this.list,
    required this.count,
  });
  late final List<Order> list;
  late final int count;

  OrderList.fromJson(Map<String, dynamic> json) {
    list = List.from(json['list']).map((e) => Order.fromJson(e)).toList();
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['list'] = list.map((e) => e.toJson()).toList();
    _data['count'] = count;
    return _data;
  }
}

class Order {
  Order({
    required this.id,
    required this.orderNo,
    required this.price,
    required this.seller,
    required this.cover,
    required this.name,
  });
  late final String id;
  late final String orderNo;
  late final num? price;
  late final String seller;
  late final String cover;
  late final String name;

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['orderNo'];
    price = json['price'];
    seller = json['seller'];
    cover = json['cover'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['orderNo'] = orderNo;
    _data['price'] = price;
    _data['seller'] = seller;
    _data['cover'] = cover;
    _data['name'] = name;
    return _data;
  }
}
