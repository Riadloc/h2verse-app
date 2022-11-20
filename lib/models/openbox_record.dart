// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BoxOpenRecord {
  final String id;
  final String cover;
  final String boxName;
  final String openName;
  final String createdAt;
  BoxOpenRecord({
    required this.id,
    required this.cover,
    required this.boxName,
    required this.openName,
    required this.createdAt,
  });

  BoxOpenRecord copyWith({
    String? id,
    String? cover,
    String? boxName,
    String? openName,
    String? createdAt,
  }) {
    return BoxOpenRecord(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      boxName: boxName ?? this.boxName,
      openName: openName ?? this.openName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cover': cover,
      'boxName': boxName,
      'openName': openName,
      'createdAt': createdAt,
    };
  }

  factory BoxOpenRecord.fromMap(Map<String, dynamic> map) {
    return BoxOpenRecord(
      id: map['id'] as String,
      cover: map['cover'] as String,
      boxName: map['boxName'] as String,
      openName: map['openName'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BoxOpenRecord.fromJson(String source) =>
      BoxOpenRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BoxOpenRecord(id: $id, cover: $cover, boxName: $boxName, openName: $openName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant BoxOpenRecord other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.cover == cover &&
        other.boxName == boxName &&
        other.openName == openName &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cover.hashCode ^
        boxName.hashCode ^
        openName.hashCode ^
        createdAt.hashCode;
  }
}
