class WalletRecord {
  WalletRecord({
    required this.id,
    required this.uid,
    required this.recordNo,
    required this.type,
    required this.status,
    required this.change,
    this.changeTo,
    required this.payInfo,
    this.relatedGoodId,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String uid;
  late final String recordNo;
  late final int type;
  late final int status;
  late final num change;
  late final String? changeTo;
  late final PayInfo payInfo;
  late final String? relatedGoodId;
  late final String createdAt;
  late final String updatedAt;

  WalletRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    recordNo = json['recordNo'];
    type = json['type'];
    status = json['status'];
    change = json['change'];
    changeTo = json['changeTo'];
    payInfo = PayInfo.fromJson(json['payInfo']);
    relatedGoodId = json['relatedGoodId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['recordNo'] = recordNo;
    _data['type'] = type;
    _data['status'] = status;
    _data['change'] = change;
    _data['changeTo'] = changeTo;
    _data['payInfo'] = payInfo.toJson();
    _data['relatedGoodId'] = relatedGoodId;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class PayInfo {
  PayInfo({this.goodType, this.payId, this.remark});
  late final int? goodType;
  late final String? payId;
  late final String? remark;

  PayInfo.fromJson(Map<String, dynamic> json) {
    goodType = json['goodType'];
    payId = json['payId'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['goodType'] = goodType;
    _data['payId'] = payId;
    _data['remark'] = remark;
    return _data;
  }
}
