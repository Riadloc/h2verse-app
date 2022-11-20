import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h2verse_app/models/power_code_info.dart';
import 'package:h2verse_app/models/power_model.dart';
import 'package:h2verse_app/models/power_record.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/http.dart';

typedef NormalResp = Map<String, dynamic>;

class PowerService {
  static Future getObjectPowerDetail(String goodId) async {
    Map<String, dynamic> queryParameters = {'goodId': goodId};
    Response response;
    response = await HttpUtils()
        .dio
        .get('/power/detail', queryParameters: queryParameters);
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return PowerInfo.fromMap(data);
    }
    Alert.reqFail(response.data['msg']);
  }

  static Future checkAndGetObjectPowerDetail(
      Map<String, String> query, String merchantCode) async {
    EasyLoading.show();
    var data = {...query, "merchantCode": merchantCode};
    Response response;
    response = await HttpUtils().dio.post('/power/check', data: data);
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return PowerInfo.fromMap(data);
    }
    Alert.reqFail(response.data['msg']);
  }

  static Future getPowerShortDetail(Map<String, String> query) async {
    EasyLoading.show();
    Response response;
    response =
        await HttpUtils().dio.get('/power/shortDetail', queryParameters: query);
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return PowerInfo.fromMap(data);
    }
    Alert.reqFail(response.data['msg']);
  }

  static Future getPowerQrcode(String goodId) async {
    Map<String, dynamic> queryParameters = {'goodId': goodId};
    Response response;
    response = await HttpUtils()
        .dio
        .get('/power/code', queryParameters: queryParameters);
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return PowerCodeInfo.fromMap(data);
    }
    Alert.reqFail(response.data['msg']);
  }

  static Future consumePower(
      Map<String, String> query, String merchantCode) async {
    var data = {...query, "merchantCode": merchantCode};
    EasyLoading.show();
    Response response;
    response = await HttpUtils().dio.post('/power/consume', data: data);
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future getPowerRecords(int pageNo) async {
    Response response;
    response = await HttpUtils().dio.get('/power/records',
        queryParameters: {'pageNo': pageNo, 'pageSize': 12});
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return (data as List<dynamic>)
          .map((e) => PowerRecord.fromMap(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future getAllPowerRecords(
      {required int pageNo,
      required String merchantCode,
      required String goodId}) async {
    Response response;
    response = await HttpUtils().dio.get('/power/allRecords', queryParameters: {
      'pageNo': pageNo,
      'pageSize': 12,
      'merchantCode': merchantCode,
      'goodId': goodId,
    });
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return (data as List<dynamic>)
          .map((e) => PowerRecord.fromMap(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }
}
