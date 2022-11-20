class Bulletin {
  Bulletin({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.url,
    this.cover,
  });
  late final String id;
  late final String name;
  late final String createdAt;
  late final String? cover;
  late final String url;

  Bulletin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    cover = json['cover'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['createdAt'] = createdAt;
    _data['cover'] = cover;
    _data['url'] = url;
    return _data;
  }
}
