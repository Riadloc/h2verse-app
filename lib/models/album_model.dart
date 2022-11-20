// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Album {
  final String id;
  final String cover;
  final String name;
  Album({
    required this.id,
    required this.cover,
    required this.name,
  });

  Album copyWith({
    String? id,
    String? cover,
    String? name,
  }) {
    return Album(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cover': cover,
      'name': name,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as String,
      cover: map['cover'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Album(id: $id, cover: $cover, name: $name)';

  @override
  bool operator ==(covariant Album other) {
    if (identical(this, other)) return true;

    return other.id == id && other.cover == cover && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ cover.hashCode ^ name.hashCode;
}
