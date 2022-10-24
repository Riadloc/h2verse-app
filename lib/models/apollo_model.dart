// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Apollo {
  final String payStrategy;
  Apollo({
    required this.payStrategy,
  });

  Apollo copyWith({
    String? payStrategy,
  }) {
    return Apollo(
      payStrategy: payStrategy ?? this.payStrategy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'payStrategy': payStrategy,
    };
  }

  factory Apollo.fromMap(Map<String, dynamic> map) {
    return Apollo(
      payStrategy: map['payStrategy'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Apollo.fromJson(String source) =>
      Apollo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Apollo(payStrategy: $payStrategy)';

  @override
  bool operator ==(covariant Apollo other) {
    if (identical(this, other)) return true;

    return other.payStrategy == payStrategy;
  }

  @override
  int get hashCode => payStrategy.hashCode;
}
