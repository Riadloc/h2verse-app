import 'package:flutter/material.dart';

const List<Color> gradientButtonPrimarycolors = [
  Color(0xFFEAFFB3),
  Color(0xFF7BFFD8),
  Color(0xFFC3C0FF),
];

class LocalDB {
  static const String BOX = 'localDB';
  static const String SEARCH = 'search';
  static const String TOKEN = 'TOKEN';
  static const String INVITE_CODE = 'inviteCode';
  static const String ACT = 'act';
  static const int SEARCH_HISTORY_MAX = 12;
}

/// 账户日志类型 */
class WalletRecordType {
  /// 交易 */
  static int TRADE = 0;

  /// 充值 */
  static int TOP_UP = 1;

  /// 提现 */
  static int DRAW_CASH = 2;

  /// 开户 */
  static int APPLY_USER = 3;

  /// 全部-查询使用 */
  static int ALL = 4;

  /// 分红 */
  static int DIVIDEND = 5;
}

/// 支付订单状态 */
class PayOrderStatus {
  /// 等待中 */
  static int PENDING = 0;

  /// 交易成功 */
  static int SUCCESSED = 1;

  /// 交易失败 */
  static int FAILED = 2;

  /// 提现-已代付 */
  static int DC_TRANSFERED = 3;

  /// 提现-已申请 */
  static int DC_APPLYED = 4;

  /// 提现-代付成功 申请失败 */
  static int DC_APPLY_FAILED = 5;

  /// 提现-已申请 未填写验证码 */
  static int DC_APPLYED_WAIT = 6;

  /// 提现-已申请 填写验证码 */
  static int DC_APPLYED_CHECKED = 7;
}

final recordNameMap = {
  WalletRecordType.APPLY_USER: '开户',
  WalletRecordType.TRADE: '交易',
  WalletRecordType.TOP_UP: '充值',
  WalletRecordType.DRAW_CASH: '提现',
};

final statusNameMap = {
  PayOrderStatus.PENDING: '进行中',
  PayOrderStatus.SUCCESSED: '完成',
  PayOrderStatus.FAILED: '关闭',
  PayOrderStatus.DC_APPLYED: '预付成功',
  PayOrderStatus.DC_APPLYED_WAIT: '信息缺失',
  PayOrderStatus.DC_APPLYED_CHECKED: '信息缺失',
  PayOrderStatus.DC_APPLY_FAILED: '预付成功',
  PayOrderStatus.DC_TRANSFERED: '信息缺失',
};

const simplePswList = [
  '111111',
  '222222',
  '333333',
  '444444',
  '555555',
  '666666',
  '777777',
  '888888',
  '999999',
  '000000',
  '123456'
];
