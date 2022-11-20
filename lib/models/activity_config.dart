// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ActivityConfig {
  final String goodId;
  ActivityConfig({
    required this.goodId,
  });

  ActivityConfig copyWith({
    String? goodId,
  }) {
    return ActivityConfig(
      goodId: goodId ?? this.goodId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'goodId': goodId,
    };
  }

  factory ActivityConfig.fromMap(Map<String, dynamic> map) {
    return ActivityConfig(
      goodId: map['goodId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityConfig.fromJson(String source) =>
      ActivityConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ActivityConfig(goodId: $goodId)';

  @override
  bool operator ==(covariant ActivityConfig other) {
    if (identical(this, other)) return true;

    return other.goodId == goodId;
  }

  @override
  int get hashCode => goodId.hashCode;
}
