// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PowerInfo {
  final String goodId;
  final String cover;
  final String name;
  final String powerId;
  final String powerName;
  final String powerDescription;
  final String? userName;
  final String? phone;
  final int? uid;
  final String? code;
  final List<PowerInfoStat> statsList;
  PowerInfo({
    required this.goodId,
    required this.cover,
    required this.name,
    required this.powerId,
    required this.powerName,
    required this.powerDescription,
    this.userName,
    this.phone,
    this.code,
    this.uid,
    required this.statsList,
  });

  PowerInfo copyWith({
    String? goodId,
    String? cover,
    String? name,
    String? powerId,
    String? powerName,
    String? powerDescription,
    String? userName,
    String? phone,
    String? code,
    int? uid,
    List<PowerInfoStat>? statsList,
  }) {
    return PowerInfo(
      goodId: goodId ?? this.goodId,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      powerId: powerId ?? this.powerId,
      powerName: powerName ?? this.powerName,
      powerDescription: powerDescription ?? this.powerDescription,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
      code: code ?? this.code,
      statsList: statsList ?? this.statsList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'goodId': goodId,
      'cover': cover,
      'name': name,
      'powerId': powerId,
      'powerName': powerName,
      'powerDescription': powerDescription,
      'userName': userName,
      'phone': phone,
      'uid': uid,
      'code': code,
      'statsList': statsList.map((x) => x.toMap()).toList(),
    };
  }

  factory PowerInfo.fromMap(Map<String, dynamic> map) {
    return PowerInfo(
      goodId: map['goodId'] as String,
      cover: map['cover'] as String,
      name: map['name'] as String,
      powerId: map['powerId'] as String,
      powerName: map['powerName'] as String,
      powerDescription: map['powerDescription'] as String,
      userName: map['userName'] != null ? map['userName'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      uid: map['uid'] != null ? map['uid'] as int : null,
      code: map['code'] != null ? map['code'] as String : null,
      statsList: List<PowerInfoStat>.from(
        (map['statsList'] as List<dynamic>).map<PowerInfoStat>(
          (x) => PowerInfoStat.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PowerInfo.fromJson(String source) =>
      PowerInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PowerInfo(goodId: $goodId, cover: $cover, name: $name, powerId: $powerId, powerName: $powerName, powerDescription: $powerDescription, userName: $userName, phone: $phone, uid: $uid, code: $code, statsList: $statsList)';
  }

  @override
  bool operator ==(covariant PowerInfo other) {
    if (identical(this, other)) return true;

    return other.goodId == goodId &&
        other.cover == cover &&
        other.name == name &&
        other.powerId == powerId &&
        other.powerName == powerName &&
        other.powerDescription == powerDescription &&
        other.userName == userName &&
        other.phone == phone &&
        other.uid == uid &&
        listEquals(other.statsList, statsList);
  }

  @override
  int get hashCode {
    return goodId.hashCode ^
        cover.hashCode ^
        name.hashCode ^
        powerId.hashCode ^
        powerName.hashCode ^
        powerDescription.hashCode ^
        userName.hashCode ^
        phone.hashCode ^
        uid.hashCode ^
        statsList.hashCode;
  }
}

class PowerInfoStat {
  final String label;
  final String value;
  PowerInfoStat({
    required this.label,
    required this.value,
  });

  PowerInfoStat copyWith({
    String? label,
    String? value,
  }) {
    return PowerInfoStat(
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'value': value,
    };
  }

  factory PowerInfoStat.fromMap(Map<String, dynamic> map) {
    return PowerInfoStat(
      label: map['label'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PowerInfoStat.fromJson(String source) =>
      PowerInfoStat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PowerInfoStat(label: $label, value: $value)';

  @override
  bool operator ==(covariant PowerInfoStat other) {
    if (identical(this, other)) return true;

    return other.label == label && other.value == value;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}
