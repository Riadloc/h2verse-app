class BankCard {
  BankCard({
    required this.id,
    required this.bankNo,
    this.bankName,
    required this.idNo,
  });
  late final String id;
  late final String bankNo;
  late final String? bankName;
  late final String idNo;

  BankCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankNo = json['bankNo'];
    bankName = null;
    idNo = json['idNo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['bankNo'] = bankNo;
    _data['bankName'] = bankName;
    _data['idNo'] = idNo;
    return _data;
  }
}
