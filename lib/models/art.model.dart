class Art {
  Art({
    required this.id,
    required this.cover,
    required this.name,
    required this.price,
    this.copies,
    this.ownner,
    this.realCopies,
    this.serial,
    this.status,
    this.ownerUuid,
    this.description,
    this.pictures,
    this.isBox,
    this.type,
    this.level,
    this.boxs,
    this.tokenId,
    this.contract,
  });
  late final String id;
  late final String cover;
  late final String name;
  late final int price;
  late final String? ownner;
  late final int? copies;
  late final int? realCopies;
  late final String? serial;
  late final int? status;
  late final String? ownerUuid;
  late final String? description;
  late final List<dynamic>? pictures;
  late final bool? isBox;
  late final int? type;
  late final int? level;
  late final List<dynamic>? boxs;
  late final String? tokenId;
  late final String? contract;
  late final String? goodNo;
  late final int? count;

  factory Art.empty() => Art(id: '', cover: '', name: '', price: 0);

  Art.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownner = json['ownner'];
    cover = json['cover'];
    name = json['name'];
    copies = json['copies'];
    realCopies = json['realCopies'];
    serial = json['serial'];
    status = json['status'];
    ownerUuid = json['ownerUuid'];
    description = json['description'];
    pictures = json['pictures'] != null
        ? List.castFrom<dynamic, dynamic>(json['pictures'])
        : null;
    price = json['price'];
    isBox = json['isBox'];
    type = json['type'];
    level = json['level'];
    boxs = json['boxs'] != null
        ? List.castFrom<dynamic, dynamic>(json['boxs'])
        : null;
    tokenId = json['tokenId'];
    contract = json['contract'];
    goodNo = json['goodNo'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ownner'] = ownner;
    _data['cover'] = cover;
    _data['name'] = name;
    _data['copies'] = copies;
    _data['realCopies'] = realCopies;
    _data['serial'] = serial;
    _data['status'] = status;
    _data['ownerUuid'] = ownerUuid;
    _data['description'] = description;
    _data['pictures'] = pictures;
    _data['price'] = price;
    _data['isBox'] = isBox;
    _data['type'] = type;
    _data['level'] = level;
    _data['boxs'] = boxs;
    _data['tokenId'] = tokenId;
    _data['contract'] = contract;
    _data['goodNo'] = goodNo;
    _data['count'] = count;
    return _data;
  }
}
