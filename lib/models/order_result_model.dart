// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderResult {
  final String orderId;
  final String orderNo;
  final String? token;
  final String? url;
  OrderResult({
    required this.orderId,
    required this.orderNo,
    this.token,
    this.url,
  });

  OrderResult copyWith({
    String? orderId,
    String? orderNo,
    String? token,
    String? url,
  }) {
    return OrderResult(
      orderId: orderId ?? this.orderId,
      orderNo: orderNo ?? this.orderNo,
      token: token ?? this.token,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'orderNo': orderNo,
      'token': token,
      'url': url,
    };
  }

  factory OrderResult.fromMap(Map<String, dynamic> map) {
    return OrderResult(
      orderId: map['orderId'] as String,
      orderNo: map['orderNo'] as String,
      token: map['token'] != null ? map['token'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderResult.fromJson(String source) =>
      OrderResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderResult(orderId: $orderId, orderNo: $orderNo, token: $token, url: $url)';
  }

  @override
  bool operator ==(covariant OrderResult other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.orderNo == orderNo &&
        other.token == token &&
        other.url == url;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^ orderNo.hashCode ^ token.hashCode ^ url.hashCode;
  }
}
