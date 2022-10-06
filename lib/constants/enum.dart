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

class GoodOperatorStatus {
  static const int UNSET = 0;
  static const int WAIT = 1;
  static const int AHEAD = 2;
  static const int OPEN = 3;
  static const int SOLD_OUT = 4;
  static const int UNSHELVE = 5;
  static const int SHELVED = 6;
  static const int UNOPEN_BOX = 7;
  static const int WAIT_SUBSCRIBE = 8;
  static const int SUBSCRIBED = 9;
  static const int WAIT_PURCAHSE = 10;
  static const int CAN_TRANSFER = 11;
  static const int UN_LUCKY = 12;
}

/// 赋能
class GoodPowerEnum {
  /// 提前一个小时优先购买 */
  static const int AHEAD_PURCHASE_ONE_HOUR = 0;

  /// 手续费打8折 */
  static const int DISCOUNT_BY_EIGHTY = 0;

  /// 手续费打9折 */
  static const int DISCOUNT_BY_NINETY = 0;

  /// 手续费打9折 */
  static const int DISCOUNT_BY_ = 0;

  /// 优先购不限制 */
  static const int AHEAD_PURCHASE_NOLIMIT = 0;

  /// 优先购1个 */
  static const int AHEAD_PURCHASE_ONE_COUNT = 0;

  /// 优先购2个 */
  static const int AHEAD_PURCHASE_TWO_COUNT = 0;

  /// 优先购3个 */
  static const int AHEAD_PURCHASE_THREE_COUNT = 0;

  /// 手续费打2折 */
  static const int DISCOUNT_BY_TWENTY = 0;

  /// 手续费打7折 */
  static const int DISCOUNT_BY_SEVENTY = 0;

  /// 特殊‘仅购买一份 */
  static const int SPECIAL_PURCHASE_ONE = 0;
}

/// 接口返回code
class CustomHttpCode {
  /// 失败 */
  static const int FAILED = -1;

  /// 成功 */
  static const int SUCCESSED = 0;

  /// 未登录 */
  static const int UNAUTHORIZED = 1;

  /// 禁止 */
  static const int FORBIDDEN = 2;

  /// 请求过多 */
  static const int TOO_MANY_REQUESTS = 3;

  /// 未实名 */
  static const int UNCERTIFIED = 4;

  /// 未开户 */
  static const int UNOPENACCOUNT = 5;

  /// 余额不足 */
  static const int UNSUITABLEBALANCE = 6;

  /// 未设置支付密码 */
  static const int UNSETPAYKEY = 7;
}
