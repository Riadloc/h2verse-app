// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserShortInfo {
  final String id;
  final String nickname;
  final int userId;
  final String intro;
  final String avatar;
  final String background;
  final String chainAccount;
  UserShortInfo({
    required this.id,
    required this.nickname,
    required this.userId,
    required this.intro,
    required this.avatar,
    required this.background,
    required this.chainAccount,
  });

  UserShortInfo copyWith({
    String? id,
    String? nickname,
    int? userId,
    String? intro,
    String? avatar,
    String? background,
    String? chainAccount,
  }) {
    return UserShortInfo(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      userId: userId ?? this.userId,
      intro: intro ?? this.intro,
      avatar: avatar ?? this.avatar,
      background: background ?? this.background,
      chainAccount: chainAccount ?? this.chainAccount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nickname': nickname,
      'userId': userId,
      'intro': intro,
      'avatar': avatar,
      'background': background,
      'chainAccount': chainAccount,
    };
  }

  factory UserShortInfo.fromMap(Map<String, dynamic> map) {
    return UserShortInfo(
      id: map['id'] as String,
      nickname: map['nickname'] as String,
      userId: map['userId'] as int,
      intro: map['intro'] as String,
      avatar: map['avatar'] as String,
      background: map['background'] as String,
      chainAccount: map['chainAccount'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserShortInfo.fromJson(String source) =>
      UserShortInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserShortInfo(id: $id, nickname: $nickname, userId: $userId, intro: $intro, avatar: $avatar, background: $background, chainAccount: $chainAccount)';
  }

  @override
  bool operator ==(covariant UserShortInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nickname == nickname &&
        other.userId == userId &&
        other.intro == intro &&
        other.avatar == avatar &&
        other.background == background &&
        other.chainAccount == chainAccount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nickname.hashCode ^
        userId.hashCode ^
        intro.hashCode ^
        avatar.hashCode ^
        background.hashCode ^
        chainAccount.hashCode;
  }
}
