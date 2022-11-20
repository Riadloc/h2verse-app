import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h2verse_app/models/activity_config.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/http.dart';

typedef NormalResp = Map<String, dynamic>;

class ActivityService {
  static Future getActivityConfig(String actName) async {
    Map<String, dynamic> queryParameters = {'actName': actName};
    EasyLoading.show();
    Response response;
    response = await HttpUtils()
        .dio
        .get('/activity/config', queryParameters: queryParameters);
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return data;
    }
    Alert.reqFail(response.data['msg']);
    return null;
  }
}
