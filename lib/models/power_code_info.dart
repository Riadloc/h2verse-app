// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PowerCodeInfo {
  final String qrcode;
  final String code;
  PowerCodeInfo({
    required this.qrcode,
    required this.code,
  });

  PowerCodeInfo copyWith({
    String? qrcode,
    String? code,
  }) {
    return PowerCodeInfo(
      qrcode: qrcode ?? this.qrcode,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qrcode': qrcode,
      'code': code,
    };
  }

  factory PowerCodeInfo.fromMap(Map<String, dynamic> map) {
    return PowerCodeInfo(
      qrcode: map['qrcode'] as String,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PowerCodeInfo.fromJson(String source) =>
      PowerCodeInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PowerCodeInfo(qrcode: $qrcode, code: $code)';

  @override
  bool operator ==(covariant PowerCodeInfo other) {
    if (identical(this, other)) return true;

    return other.qrcode == qrcode && other.code == code;
  }

  @override
  int get hashCode => qrcode.hashCode ^ code.hashCode;
}
