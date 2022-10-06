// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppUpgradeInfo {
  final String id;
  final String version;
  final String info;
  final int force;
  final String url;
  AppUpgradeInfo({
    required this.id,
    required this.version,
    required this.info,
    required this.force,
    required this.url,
  });

  AppUpgradeInfo copyWith({
    String? id,
    String? version,
    String? info,
    int? force,
    String? url,
  }) {
    return AppUpgradeInfo(
      id: id ?? this.id,
      version: version ?? this.version,
      info: info ?? this.info,
      force: force ?? this.force,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'version': version,
      'info': info,
      'force': force,
      'url': url,
    };
  }

  factory AppUpgradeInfo.fromMap(Map<String, dynamic> map) {
    return AppUpgradeInfo(
      id: map['id'] as String,
      version: map['version'] as String,
      info: map['info'] as String,
      force: map['force'] as int,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUpgradeInfo.fromJson(String source) =>
      AppUpgradeInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUpgradeInfo(id: $id, version: $version, info: $info, force: $force, url: $url)';
  }

  @override
  bool operator ==(covariant AppUpgradeInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.version == version &&
        other.info == info &&
        other.force == force &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        version.hashCode ^
        info.hashCode ^
        force.hashCode ^
        url.hashCode;
  }
}
