import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h2verse_app/models/openbox_record.dart';
import 'package:h2verse_app/models/power_code_info.dart';
import 'package:h2verse_app/models/power_model.dart';
import 'package:h2verse_app/models/power_record.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/http.dart';

typedef NormalResp = Map<String, dynamic>;

class RecordService {
  static Future<List<BoxOpenRecord>> getBoxOpenRecords(
      {required int pageNo}) async {
    Response response;
    response = await HttpUtils().dio.get('/goods/openBoxRecords',
        queryParameters: {'pageNo': pageNo, 'pageSize': 12});
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return (data as List<dynamic>)
          .map((e) => BoxOpenRecord.fromMap(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }
}
