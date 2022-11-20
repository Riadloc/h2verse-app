// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderConfig {
  final String payStrategy;
  final OrderCustomConfig? config;
  OrderConfig({
    required this.payStrategy,
    this.config,
  });

  OrderConfig copyWith({
    String? payStrategy,
    OrderCustomConfig? config,
  }) {
    return OrderConfig(
      payStrategy: payStrategy ?? this.payStrategy,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'payStrategy': payStrategy,
      'config': config?.toMap(),
    };
  }

  factory OrderConfig.fromMap(Map<String, dynamic> map) {
    return OrderConfig(
      payStrategy: map['payStrategy'] as String,
      config: map['config'] != null
          ? OrderCustomConfig.fromMap(map['config'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderConfig.fromJson(String source) =>
      OrderConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderConfig(payStrategy: $payStrategy, config: $config)';

  @override
  bool operator ==(covariant OrderConfig other) {
    if (identical(this, other)) return true;

    return other.payStrategy == payStrategy && other.config == config;
  }

  @override
  int get hashCode => payStrategy.hashCode ^ config.hashCode;
}

class OrderCustomConfig {
  final String key;
  final String title;
  final String desc;
  final int required;
  final int needConfirm;
  final String type;
  final List<OrderConfigOption> options;
  final String confirmMsg;
  OrderCustomConfig({
    required this.key,
    required this.title,
    required this.desc,
    required this.required,
    required this.needConfirm,
    required this.type,
    required this.options,
    required this.confirmMsg,
  });

  OrderCustomConfig copyWith({
    String? key,
    String? title,
    String? desc,
    int? required,
    int? needConfirm,
    String? type,
    List<OrderConfigOption>? options,
    String? confirmMsg,
  }) {
    return OrderCustomConfig(
      key: key ?? this.key,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      required: required ?? this.required,
      needConfirm: needConfirm ?? this.needConfirm,
      type: type ?? this.type,
      options: options ?? this.options,
      confirmMsg: confirmMsg ?? this.confirmMsg,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'title': title,
      'desc': desc,
      'required': required,
      'needConfirm': needConfirm,
      'type': type,
      'options': options.map((x) => x.toMap()).toList(),
      'confirmMsg': confirmMsg,
    };
  }

  factory OrderCustomConfig.fromMap(Map<String, dynamic> map) {
    return OrderCustomConfig(
      key: map['key'] as String,
      title: map['title'] as String,
      desc: map['desc'] as String,
      required: map['required'] as int,
      needConfirm: map['needConfirm'] as int,
      type: map['type'] as String,
      options: List<OrderConfigOption>.from(
        (map['options'] as List<dynamic>).map<OrderConfigOption>(
          (x) => OrderConfigOption.fromMap(x as Map<String, dynamic>),
        ),
      ),
      confirmMsg: map['confirmMsg'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderCustomConfig.fromJson(String source) =>
      OrderCustomConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderCustomConfig(key: $key, title: $title, desc: $desc, required: $required, needConfirm: $needConfirm, type: $type, options: $options, confirmMsg: $confirmMsg)';
  }

  @override
  bool operator ==(covariant OrderCustomConfig other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.title == title &&
        other.desc == desc &&
        other.required == required &&
        other.needConfirm == needConfirm &&
        other.type == type &&
        listEquals(other.options, options) &&
        other.confirmMsg == confirmMsg;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        title.hashCode ^
        desc.hashCode ^
        required.hashCode ^
        needConfirm.hashCode ^
        type.hashCode ^
        options.hashCode ^
        confirmMsg.hashCode;
  }
}

class OrderConfigOption {
  final String label;
  final String value;
  OrderConfigOption({
    required this.label,
    required this.value,
  });

  OrderConfigOption copyWith({
    String? label,
    String? value,
  }) {
    return OrderConfigOption(
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'value': value,
    };
  }

  factory OrderConfigOption.fromMap(Map<String, dynamic> map) {
    return OrderConfigOption(
      label: map['label'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderConfigOption.fromJson(String source) =>
      OrderConfigOption.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OrderConfigOption(label: $label, value: $value)';

  @override
  bool operator ==(covariant OrderConfigOption other) {
    if (identical(this, other)) return true;

    return other.label == label && other.value == value;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}
