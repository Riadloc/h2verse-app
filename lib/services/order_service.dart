import 'package:dio/dio.dart';
import 'package:get/get.dart' as Getx;
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/models/order_model.dart';
import 'package:h2verse_app/models/order_result_model.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/http.dart';
import 'package:h2verse_app/views/acount/trade_password_form.dart';
import 'package:h2verse_app/views/identity.dart';
import 'package:h2verse_app/views/wallet/topup_store.dart';
import 'package:h2verse_app/widgets/modal.dart';

typedef NormalResp = Map<String, dynamic>;

class OrderService {
  static Future<List<Order>> getOrders(
      {required int pageNo, required int type}) async {
    var query = {'pageNo': pageNo, 'pageSize': 12, 'status': type};
    Response response;
    response = await HttpUtils().dio.get('/order/list', queryParameters: query);
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return (data['list'] as List<dynamic>)
          .map((e) => Order.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<OrderResult?> createOrder(
      {required String goodId, String bankId = '', int count = 1}) async {
    var data = {'goodId': goodId, 'bankId': bankId, 'count': count};
    Response response;
    response = await HttpUtils().dio.post('/payment/create', data: data);
    var code = response.data['code'];
    var msg = response.data['msg'];
    if (code == CustomHttpCode.SUCCESSED) {
      var data = response.data['data'];
      return OrderResult.fromMap(data);
    }
    if (code == CustomHttpCode.UNCERTIFIED) {
      Getx.Get.dialog(
        Modal(
          title: '还没完成实名认证！',
          description: '需要完成实名认证后才可以进行购买',
          confirmText: '前去认证',
          onConfirm: () {
            Getx.Get.back(canPop: false);
            Getx.Get.toNamed(Identity.routeName);
          },
          onCancel: () {
            Getx.Get.back(canPop: true);
          },
        ),
      );
    }
    if (code == CustomHttpCode.UNSUITABLEBALANCE) {
      Getx.Get.dialog(
        Modal(
          title: '余额不足',
          description: '账户余额不足，前去充值？',
          confirmText: '充值',
          onConfirm: () {
            Getx.Get.back(canPop: false);
            Getx.Get.toNamed(TopupStore.routeName);
          },
          onCancel: () {
            Getx.Get.back(canPop: true);
          },
        ),
      );
    } else if (code == CustomHttpCode.UNSETPAYKEY) {
      Getx.Get.dialog(
        Modal(
          title: '交易密码',
          description: '未设置交易密码',
          confirmText: '前去设置',
          onConfirm: () {
            Getx.Get.back(canPop: false);
            Getx.Get.toNamed(TradePasswordForm.routeName);
          },
          onCancel: () {
            Getx.Get.back(canPop: true);
          },
        ),
      );
    } else {
      Alert.reqFail(msg);
    }
    return null;
  }

  static Future<Order> getDetail({required String orderId}) async {
    var query = {'orderId': orderId};
    Response response =
        await HttpUtils().dio.get('/order/detail', queryParameters: query);
    if (response.data['code'] == 0) {
      return Order.fromJson(response.data['data']);
    }
    Alert.reqFail(response.data['msg']);
    return Order.empty();
  }

  static Future cancelOrder({required String orderNo}) async {
    var data = {'tradeNo': orderNo};
    Response response =
        await HttpUtils().dio.post('/payment/cancel', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future doTrade({
    required String orderId,
    required String payKey,
    required String token,
    String? orderNo,
  }) async {
    var data = {'orderId': orderId, 'payKey': payKey, 'token': token};
    if (orderNo != null) {
      data['orderNo'] = orderNo;
    }
    Response response;
    response = await HttpUtils().dio.post('/wallet/trade', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future doSpecialTrade({
    required String orderId,
  }) async {
    var data = {'orderId': orderId};
    Response response;
    response = await HttpUtils().dio.post('/wallet/trade/special', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }
}
