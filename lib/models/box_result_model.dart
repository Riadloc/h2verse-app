import 'dart:convert';

class BoxResult {
  final BoxMiniInfo data;
  final int count;
  BoxResult({
    required this.data,
    required this.count,
  });

  BoxResult copyWith({
    BoxMiniInfo? data,
    int? count,
  }) {
    return BoxResult(
      data: data ?? this.data,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.toMap(),
      'count': count,
    };
  }

  factory BoxResult.fromMap(Map<String, dynamic> map) {
    return BoxResult(
      data: BoxMiniInfo.fromMap(map['data'] as Map<String, dynamic>),
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BoxResult.fromJson(String source) =>
      BoxResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BoxResult(data: $data, count: $count)';

  @override
  bool operator ==(covariant BoxResult other) {
    if (identical(this, other)) return true;

    return other.data == data && other.count == count;
  }

  @override
  int get hashCode => data.hashCode ^ count.hashCode;
}

class BoxMiniInfo {
  final String cover;
  final String name;
  final String id;
  BoxMiniInfo({
    required this.cover,
    required this.name,
    required this.id,
  });

  BoxMiniInfo copyWith({
    String? cover,
    String? name,
    String? id,
  }) {
    return BoxMiniInfo(
      cover: cover ?? this.cover,
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cover': cover,
      'name': name,
      'id': id,
    };
  }

  factory BoxMiniInfo.fromMap(Map<String, dynamic> map) {
    return BoxMiniInfo(
      cover: map['cover'] as String,
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BoxMiniInfo.fromJson(String source) =>
      BoxMiniInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BoxMiniInfo(cover: $cover, name: $name, id: $id)';

  @override
  bool operator ==(covariant BoxMiniInfo other) {
    if (identical(this, other)) return true;

    return other.cover == cover && other.name == name && other.id == id;
  }

  @override
  int get hashCode => cover.hashCode ^ name.hashCode ^ id.hashCode;
}
