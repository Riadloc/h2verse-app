class ComposeItem {
  ComposeItem(
      {required this.id,
      required this.name,
      required this.cover,
      required this.copies,
      required this.start,
      required this.end,
      required this.createdAt,
      required this.updatedAt,
      this.materials,
      this.remain});
  late final String id;
  late final String name;
  late final int copies;
  late final String cover;
  late final String start;
  late final String end;
  late final String createdAt;
  late final String updatedAt;
  late final List<ComposeMaterials>? materials;
  late final int? remain;

  ComposeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    copies = json['copies'];
    cover = json['cover'];
    start = json['start'];
    end = json['end'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    materials = json['materials'] != null
        ? List.from(json['materials'])
            .map((e) => ComposeMaterials.fromJson(e))
            .toList()
        : null;
    remain = json['remain'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['cover'] = cover;
    _data['copies'] = copies;
    _data['start'] = start;
    _data['end'] = end;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['materials'] =
        materials != null ? materials!.map((e) => e.toJson()).toList() : null;
    _data['remain'] = remain;
    return _data;
  }
}

class ComposeMaterials {
  ComposeMaterials({
    required this.count,
    required this.objectId,
    required this.objectName,
  });
  late final int count;
  late final String objectId;
  late final String objectName;

  ComposeMaterials.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    objectId = json['objectId'];
    objectName = json['objectName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['objectId'] = objectId;
    _data['objectName'] = objectName;
    return _data;
  }
}
