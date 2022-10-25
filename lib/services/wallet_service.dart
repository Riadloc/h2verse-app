import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h2verse_app/models/bank_card_model.dart';
import 'package:h2verse_app/models/wallet_record.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/http.dart';

class WalletService {
  static Future<List<BankCard>> getBankList() async {
    EasyLoading.show(status: '机器人处理中...');
    Response response;
    response = await HttpUtils().dio.get('/wallet/bankList');
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => BankCard.fromMap(e)).toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<List<WalletRecord>> getRecords(
      {required int type, required int pageNo, required int pageSize}) async {
    var queryParameters = {
      'type': type,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    Response response;
    response = await HttpUtils()
        .dio
        .get('/wallet/records', queryParameters: queryParameters);
    if (response.data['code'] == 0) {
      List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => WalletRecord.fromJson(e)).toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<WalletRecord?> getRecordDetail(String id) async {
    var queryParameters = {'recordId': id};
    Response response = await HttpUtils()
        .dio
        .get('/wallet/record/info', queryParameters: queryParameters);
    if (response.data['code'] == 0) {
      return WalletRecord.fromJson(response.data['data']);
    }
    Alert.reqFail(response.data['msg']);
    return null;
  }

  static Future postAddBank(
      {required String realName,
      required String idNo,
      required String bankNo,
      required String phone,
      required String bankCode}) async {
    var data = {
      'realName': realName,
      'idNo': idNo,
      'bankNo': bankNo,
      'phone': phone,
      'bankCode': bankCode,
    };
    Response response =
        await HttpUtils().dio.post('/wallet/bank/bind', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future getBankInfo(String bankNo) async {
    var queryParameters = {
      'cardNo': bankNo,
      'cardBinCheck': 'true',
      '_input_charset': 'utf-8'
    };
    Response response;
    response = await HttpUtils().dio.get(
        'https://ccdcapi.alipay.com/validateAndCacheCardInfo.json',
        queryParameters: queryParameters,
        options: Options(headers: {
          'origin': 'https://ccdcapi.alipay.com',
          'referer': 'https://ccdcapi.alipay.com'
        }));
    return response.data;
  }
}
