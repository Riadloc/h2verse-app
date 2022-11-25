import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/views/login.dart';
import 'package:hive/hive.dart';

class HttpUtils {
  late final Dio dio;

  HttpUtils._internal() {
    const appEnv = String.fromEnvironment('APP_ENV');
    var baseUrl = 'https://h5.h2verse.art';
    if (appEnv == 'dev') {
      baseUrl = 'https://dev.h2verse.art';
    }
    BaseOptions options = BaseOptions(
      // baseUrl: 'http://192.168.31.210:3000/api',
      // baseUrl: 'http://192.168.2.230:3000/api',
      baseUrl: kReleaseMode ? '$baseUrl/api' : 'http://192.168.31.210:3000/api',
      validateStatus: (status) => status! >= 200 && status < 500,
    );
    dio = Dio(options);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.method == 'POST') {
          //
        }
        var box = Hive.box(LocalDB.BOX);
        String token = box.get(LocalDB.TOKEN, defaultValue: '');
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
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
            Alert.reqFail('请求太过频繁，请稍后再试');
            break;
        }
        dynamic data = options.data['data'];
        try {
          data = data is String
              ? json.decode(
                  Uri.decodeComponent(String.fromCharCodes(base64Decode(data))))
              : data;
        } catch (err) {
          //
        }
        options.data['data'] = data;
        var token = options.headers['x-set-token'];
        if (token != null && token.isNotEmpty) {
          var box = Hive.box(LocalDB.BOX);
          box.put(LocalDB.TOKEN, token[0]);
        }
        return handler.next(options);
      },
      onError: (options, handler) {
        Alert.reqFail('服务遇到问题');
        EasyLoading.dismiss();
        // return handler.next(options);
      },
    ));
    // dio.interceptors.add(DioCacheInterceptor(
    //     options: CacheOptions(
    //   store: MemCacheStore(),
    //   policy: CachePolicy.request,
    //   hitCacheOnErrorExcept: [401, 403],
    //   priority: CachePriority.normal,
    //   keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    //   allowPostMethod: false,
    // )));
  }

  factory HttpUtils() => _instance;

  static late final HttpUtils _instance = HttpUtils._internal();
}
