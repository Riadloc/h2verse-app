// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Planet {
  final String id;
  final String name;
  final String description;
  final String avatar;
  final String background;
  Planet({
    required this.id,
    required this.name,
    required this.description,
    required this.avatar,
    required this.background,
  });

  Planet copyWith({
    String? id,
    String? name,
    String? description,
    String? avatar,
    String? background,
  }) {
    return Planet(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      background: background ?? this.background,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'background': background,
    };
  }

  factory Planet.fromMap(Map<String, dynamic> map) {
    return Planet(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      avatar: map['avatar'] as String,
      background: map['background'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Planet.fromJson(String source) =>
      Planet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Planet(id: $id, name: $name, description: $description, avatar: $avatar, background: $background)';
  }

  @override
  bool operator ==(covariant Planet other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.avatar == avatar &&
        other.background == background;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        avatar.hashCode ^
        background.hashCode;
  }
}
