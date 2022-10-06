// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RealUserInfo {
  final String realName;
  final String idNo;
  RealUserInfo({
    required this.realName,
    required this.idNo,
  });

  RealUserInfo copyWith({
    String? realName,
    String? idNo,
  }) {
    return RealUserInfo(
      realName: realName ?? this.realName,
      idNo: idNo ?? this.idNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'realName': realName,
      'idNo': idNo,
    };
  }

  factory RealUserInfo.fromMap(Map<String, dynamic> map) {
    return RealUserInfo(
      realName: map['realName'] as String,
      idNo: map['idNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RealUserInfo.fromJson(String source) =>
      RealUserInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  factory RealUserInfo.empty() => RealUserInfo(idNo: '', realName: '');

  @override
  String toString() => 'RealUserInfo(realName: $realName, idNo: $idNo)';

  @override
  bool operator ==(covariant RealUserInfo other) {
    if (identical(this, other)) return true;

    return other.realName == realName && other.idNo == idNo;
  }

  @override
  int get hashCode => realName.hashCode ^ idNo.hashCode;
}
