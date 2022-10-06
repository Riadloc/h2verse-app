class Address {
  Address({
    required this.id,
    required this.area,
    required this.address,
    required this.name,
    required this.phone,
  });
  late final String id;
  late final String area;
  late final String address;
  late final String name;
  late final String phone;

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    area = json['area'];
    address = json['address'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['area'] = area;
    _data['address'] = address;
    _data['name'] = name;
    _data['phone'] = phone;
    return _data;
  }

  factory Address.empty() =>
      Address(id: '', area: '', address: '', name: '', phone: '');
}
