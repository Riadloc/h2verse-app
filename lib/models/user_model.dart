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
    required this.stats,
    required this.chainAccount,
  });
  late final String id;
  late final int userId;
  late final String nickname;
  late final String phone;
  late final String email;
  late final String avatar;
  late final int role;
  late final int certified;
  late final String createdAt;
  late final String updatedAt;
  late final Stats stats;
  late final String chainAccount;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    nickname = json['nickname'];
    phone = json['phone'];
    email = json['email'];
    avatar = json['avatar'];
    role = json['role'];
    certified = json['certified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    chainAccount = json['chainAccount'];
    stats = Stats.fromJson(json['stats']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['nickname'] = nickname;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['avatar'] = avatar;
    _data['role'] = role;
    _data['certified'] = certified;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['chainAccount'] = chainAccount;
    _data['stats'] = stats.toJson();
    return _data;
  }

  factory User.empty() => User(
      id: '',
      userId: 0,
      nickname: '',
      phone: '',
      email: '',
      avatar: '',
      role: 0,
      certified: 0,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      chainAccount: '',
      stats: Stats(order: 0, art: 0, balance: 0, trade: 0));

  factory User.copyWith(User a, Map<String, dynamic> b) => User(
        id: b['id'] ?? a.id,
        userId: b['userId'] ?? a.userId,
        nickname: b['nickname'] ?? a.nickname,
        phone: b['phone'] ?? a.phone,
        email: b['email'] ?? a.email,
        avatar: b['avatar'] ?? a.avatar,
        role: b['role'] ?? a.role,
        certified: b['certified'] ?? a.certified,
        createdAt: b['createdAt'] ?? a.createdAt,
        updatedAt: b['updatedAt'] ?? a.updatedAt,
        stats: b['stats'],
        chainAccount: b['chainAccount'],
      );
}

class Stats {
  Stats({
    required this.order,
    required this.art,
    required this.balance,
    required this.trade,
  });
  late final num order;
  late final num art;
  late final num balance;
  late final num trade;

  Stats.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    art = json['art'];
    balance = json['balance'];
    trade = json['trade'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order'] = order;
    _data['art'] = art;
    _data['balance'] = balance;
    _data['trade'] = trade;
    return _data;
  }
}
