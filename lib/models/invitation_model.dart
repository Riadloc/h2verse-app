class Invitation {
  Invitation({
    required this.id,
    required this.phone,
    required this.createdAt,
  });
  late final String id;
  late final String phone;
  late final String createdAt;

  Invitation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['phone'] = phone;
    _data['createdAt'] = createdAt;
    return _data;
  }
}
