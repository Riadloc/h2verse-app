import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h2verse_app/models/bulletin_model.dart';
import 'package:h2verse_app/models/version_upgrade_info_model.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/http.dart';

typedef NormalResp = Map<String, dynamic>;

class CommonService {
  static Future<List<Bulletin>> getBulletins(
      {required int pageNo, required int pageSize}) async {
    EasyLoading.show(status: 'loading');
    Response response;
    response = await HttpUtils().dio.get('/common/docs',
        queryParameters: {'pageNo': pageNo, 'pageSize': pageSize});
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return (data as List<dynamic>)
          .map((e) => Bulletin.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<List<Bulletin>> getLatestBulletins() async {
    Response response;
    response = await HttpUtils().dio.get('/common/latestdocs');
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return (data as List<dynamic>)
          .map((e) => Bulletin.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<AppUpgradeInfo?> getNewestVersion() async {
    Response response = await HttpUtils().dio.get('/common/appversion');
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      if (data != null) {
        return AppUpgradeInfo.fromMap(data);
      }
    }
    return null;
  }

  static Future getAppHomeInitialInfo() async {
    Response response = await HttpUtils().dio.get('/app/homeInitial');
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return data;
    }
    return null;
  }
}
