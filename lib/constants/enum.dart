// ignore_for_file: constant_identifier_names

/// 藏品类型
enum ArtType {
  /// 主藏品
  main,

  /// 二级藏品
  second,
}

/// 筛选类型
enum FilterItemKeysEnum {
  /// 最新
  SORT_NEW,

  /// 价格升序
  SORT_LOW_PRICE,

  /// 价格降序
  SORT_HIGH_PRICE,
}

/// 通知类型
enum SnackBarType {
  /// 常规
  normal,

  /// 成功
  success,

  /// 失败
  fail,

  /// 请求成功
  request_success,

  /// 请求失败
  request_fail
}
