class ComposeMaterial {
  ComposeMaterial({
    required this.id,
    required this.serial,
    required this.cover,
    required this.name,
  });
  late final String id;
  late final String serial;
  late final String cover;
  late final String name;

  ComposeMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serial = json['serial'];
    cover = json['cover'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['serial'] = serial;
    _data['cover'] = cover;
    _data['name'] = name;
    return _data;
  }
}
