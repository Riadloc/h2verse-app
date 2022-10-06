// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderResult {
  final String orderId;
  final String orderNo;
  final String token;
  OrderResult({
    required this.orderId,
    required this.orderNo,
    required this.token,
  });

  OrderResult copyWith({
    String? orderId,
    String? orderNo,
    String? token,
  }) {
    return OrderResult(
      orderId: orderId ?? this.orderId,
      orderNo: orderNo ?? this.orderNo,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'orderNo': orderNo,
      'token': token,
    };
  }

  factory OrderResult.fromMap(Map<String, dynamic> map) {
    return OrderResult(
      orderId: map['orderId'] as String,
      orderNo: map['orderNo'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderResult.fromJson(String source) =>
      OrderResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderResult(orderId: $orderId, orderNo: $orderNo, token: $token)';

  @override
  bool operator ==(covariant OrderResult other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.orderNo == orderNo &&
        other.token == token;
  }

  @override
  int get hashCode => orderId.hashCode ^ orderNo.hashCode ^ token.hashCode;
}
