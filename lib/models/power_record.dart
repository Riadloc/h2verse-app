// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PowerRecord {
  final String id;
  final String name;
  final String creator;
  final String cover;
  final String extend;
  final String createdAt;
  PowerRecord({
    required this.id,
    required this.name,
    required this.creator,
    required this.cover,
    required this.extend,
    required this.createdAt,
  });

  PowerRecord copyWith({
    String? id,
    String? name,
    String? creator,
    String? cover,
    String? extend,
    String? createdAt,
  }) {
    return PowerRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      creator: creator ?? this.creator,
      cover: cover ?? this.cover,
      extend: extend ?? this.extend,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'creator': creator,
      'cover': cover,
      'extend': extend,
      'createdAt': createdAt,
    };
  }

  factory PowerRecord.fromMap(Map<String, dynamic> map) {
    return PowerRecord(
      id: map['id'] as String,
      name: map['name'] as String,
      creator: map['creator'] as String,
      cover: map['cover'] as String,
      extend: map['extend'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PowerRecord.fromJson(String source) =>
      PowerRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PowerRecord(id: $id, name: $name, creator: $creator, cover: $cover, extend: $extend, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant PowerRecord other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.creator == creator &&
        other.cover == cover &&
        other.extend == extend &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        creator.hashCode ^
        cover.hashCode ^
        extend.hashCode ^
        createdAt.hashCode;
  }
}
