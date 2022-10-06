// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BankCard {
  final String id;
  final String bankNo;
  final String? bankName;
  final String? bankCode;
  final String idNo;
  BankCard({
    required this.id,
    required this.bankNo,
    this.bankName,
    this.bankCode,
    required this.idNo,
  });

  BankCard copyWith({
    String? id,
    String? bankNo,
    String? bankName,
    String? bankCode,
    String? idNo,
  }) {
    return BankCard(
      id: id ?? this.id,
      bankNo: bankNo ?? this.bankNo,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      idNo: idNo ?? this.idNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bankNo': bankNo,
      'bankName': bankName,
      'bankCode': bankCode,
      'idNo': idNo,
    };
  }

  factory BankCard.fromMap(Map<String, dynamic> map) {
    return BankCard(
      id: map['id'] as String,
      bankNo: map['bankNo'] as String,
      bankName: map['bankName'] != null ? map['bankName'] as String : null,
      bankCode: map['bankCode'] != null ? map['bankCode'] as String : null,
      idNo: map['idNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BankCard.fromJson(String source) =>
      BankCard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BankCard(id: $id, bankNo: $bankNo, bankName: $bankName, bankCode: $bankCode, idNo: $idNo)';
  }

  @override
  bool operator ==(covariant BankCard other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.bankNo == bankNo &&
        other.bankName == bankName &&
        other.bankCode == bankCode &&
        other.idNo == idNo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bankNo.hashCode ^
        bankName.hashCode ^
        bankCode.hashCode ^
        idNo.hashCode;
  }
}
