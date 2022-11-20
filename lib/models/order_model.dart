// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Order {
  final String id;
  final String orderNo;
  final num? price;
  final String seller;
  final String cover;
  final String name;
  final int buyCount;
  final int status;
  final String? url;
  final String createdAt;
  final String updatedAt;
  Order({
    required this.id,
    required this.orderNo,
    this.price,
    required this.seller,
    required this.cover,
    required this.name,
    required this.buyCount,
    required this.status,
    this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  Order copyWith({
    String? id,
    String? orderNo,
    num? price,
    String? seller,
    String? cover,
    String? name,
    int? buyCount,
    int? status,
    String? url,
    String? createdAt,
    String? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      orderNo: orderNo ?? this.orderNo,
      price: price ?? this.price,
      seller: seller ?? this.seller,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      buyCount: buyCount ?? this.buyCount,
      status: status ?? this.status,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'orderNo': orderNo,
      'price': price,
      'seller': seller,
      'cover': cover,
      'name': name,
      'buyCount': buyCount,
      'status': status,
      'url': url,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      orderNo: map['orderNo'] as String,
      price: map['price'] != null ? map['price'] as num : null,
      seller: map['seller'] as String,
      cover: map['cover'] as String,
      name: map['name'] as String,
      buyCount: map['buyCount'] as int,
      status: map['status'] as int,
      url: map['url'] != null ? map['url'] as String : null,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
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

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, orderNo: $orderNo, price: $price, seller: $seller, cover: $cover, name: $name, buyCount: $buyCount, status: $status, url: $url, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orderNo == orderNo &&
        other.price == price &&
        other.seller == seller &&
        other.cover == cover &&
        other.name == name &&
        other.buyCount == buyCount &&
        other.status == status &&
        other.url == url &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderNo.hashCode ^
        price.hashCode ^
        seller.hashCode ^
        cover.hashCode ^
        name.hashCode ^
        buyCount.hashCode ^
        status.hashCode ^
        url.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
