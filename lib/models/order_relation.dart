// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderRelation {
  final String id;
  final String orderNo;
  final int status;
  final String cover;
  final String name;
  final int type;
  final List<String> goodIds;
  OrderRelation({
    required this.id,
    required this.orderNo,
    required this.status,
    required this.cover,
    required this.name,
    required this.type,
    required this.goodIds,
  });

  OrderRelation copyWith({
    String? id,
    String? orderNo,
    int? status,
    String? cover,
    String? name,
    int? type,
    List<String>? goodIds,
  }) {
    return OrderRelation(
      id: id ?? this.id,
      orderNo: orderNo ?? this.orderNo,
      status: status ?? this.status,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      type: type ?? this.type,
      goodIds: goodIds ?? this.goodIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'orderNo': orderNo,
      'status': status,
      'cover': cover,
      'name': name,
      'type': type,
      'goodIds': goodIds,
    };
  }

  factory OrderRelation.fromMap(Map<String, dynamic> map) {
    return OrderRelation(
      id: map['id'] as String,
      orderNo: map['orderNo'] as String,
      status: map['status'] as int,
      cover: map['cover'] as String,
      name: map['name'] as String,
      type: map['type'] as int,
      goodIds: List<String>.from((map['goodIds'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderRelation.fromJson(String source) =>
      OrderRelation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderRelation(id: $id, orderNo: $orderNo, status: $status, cover: $cover, name: $name, type: $type, goodIds: $goodIds)';
  }

  @override
  bool operator ==(covariant OrderRelation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orderNo == orderNo &&
        other.status == status &&
        other.cover == cover &&
        other.name == name &&
        other.type == type &&
        listEquals(other.goodIds, goodIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderNo.hashCode ^
        status.hashCode ^
        cover.hashCode ^
        name.hashCode ^
        type.hashCode ^
        goodIds.hashCode;
  }
}
