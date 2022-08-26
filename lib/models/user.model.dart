class User {
  User({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.role,
    required this.certified,
    required this.createdAt,
    required this.updatedAt,
    required this.metaAccount,
    required this.isBindPayPassword,
    required this.powers,
  });

  final String id;
  final int userId;
  final String nickname;
  final String phone;
  final String email;
  final String avatar;
  final int role;
  final int certified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String metaAccount;
  final bool isBindPayPassword;
  final List<int> powers;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userId: json["userId"],
        nickname: json["nickname"],
        phone: json["phone"],
        email: json["email"],
        avatar: json["avatar"],
        role: json["role"],
        certified: json["certified"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        metaAccount: json["metaAccount"],
        isBindPayPassword: json["isBindPayPassword"],
        powers: List<int>.from(json["powers"].map((x) => x)),
      );

  factory User.empty() => User(
      id: '',
      userId: 0,
      nickname: '',
      phone: '',
      email: '',
      avatar: '',
      role: 0,
      certified: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      metaAccount: '',
      isBindPayPassword: false,
      powers: []);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "nickname": nickname,
        "phone": phone,
        "email": email,
        "avatar": avatar,
        "role": role,
        "certified": certified,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "metaAccount": metaAccount,
        "isBindPayPassword": isBindPayPassword,
        "powers": List<dynamic>.from(powers.map((x) => x)),
      };
}
