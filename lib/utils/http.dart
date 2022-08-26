import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pearmeta_fapp/utils/alert.dart';
import 'package:pearmeta_fapp/views/login.dart';

class HttpUtils {
  late final Dio dio;

  HttpUtils._internal() {
    dio = Dio(BaseOptions(
      // baseUrl: 'http://192.168.31.210:3000/api',
      baseUrl: 'http://192.168.2.230:3000/api',
      connectTimeout: 5000,
      validateStatus: (status) => status! >= 200 && status < 500,
    ));
    addCookieJar(dio);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        var data = options.data;
        var query = options.queryParameters;
        dynamic showIndicator =
            data?['showIndicator'] ?? query['showIndicator'];
        print(showIndicator);
        if (showIndicator != false) {
          EasyLoading.show(status: 'loading');
          if (data != null) {
            options.data.remove('showIndicator');
          }
          if (query.isNotEmpty) {
            options.queryParameters.remove('showIndicator');
          }
        }
        if (options.method == 'POST') {
          //
        }
        return handler.next(options);
      },
      onResponse: (options, handler) {
        switch (options.statusCode) {
          case 401:
            Alert.fail('还未登录~');
            Get.offNamed(Login.routeName);
            break;
          case 403:
            Alert.reqFail('被禁止的请求');
            break;
          case 429:
            Alert.reqFail('请求太过频繁，请稍后重试');
            break;
        }
        dynamic data = options.data['data'];
        try {
          data = data is String
              ? jsonDecode(
                  Uri.decodeComponent(String.fromCharCodes(base64Decode(data))))
              : data;
        } catch (err) {
          //
        }
        options.data['data'] = data;
        EasyLoading.dismiss();
        return handler.next(options);
      },
      onError: (options, handler) {
        Alert.reqFail('请联系管理员');
        EasyLoading.dismiss();
        return handler.next(options);
      },
    ));
  }

  factory HttpUtils() => _instance;

  static late final HttpUtils _instance = HttpUtils._internal();

  Future addCookieJar(Dio dio) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cj = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage("$appDocPath/.cookies/"));
    dio.interceptors.add(CookieManager(cj));
  }
}
