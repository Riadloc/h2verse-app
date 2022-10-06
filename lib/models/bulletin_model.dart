class Bulletin {
  Bulletin({
    required this.id,
    required this.title,
    required this.publishedAt,
    required this.slug,
    this.cover,
  });
  late final int id;
  late final String title;
  late final String publishedAt;
  late final String? cover;
  late final String slug;

  Bulletin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    publishedAt = json['published_at'];
    cover = json['cover'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['published_at'] = publishedAt;
    _data['cover'] = cover;
    _data['slug'] = slug;
    return _data;
  }
}
