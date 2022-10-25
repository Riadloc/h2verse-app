import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/views/login.dart';

class HttpUtils {
  late final Dio dio;

  HttpUtils._internal() {
    dio = Dio(BaseOptions(
      // baseUrl: 'http://192.168.31.210:3000/api',
      // baseUrl: 'http://192.168.2.230:3000/api',
      baseUrl: kReleaseMode
          ? 'https://h5.h2verse.art/api'
          : 'http://192.168.2.230:3000/api',
      connectTimeout: 5000,
      validateStatus: (status) => status! >= 200 && status < 500,
    ));
    if (!kIsWeb) {
      addCookieJar(dio);
    }
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
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
        return handler.next(options);
      },
      onError: (options, handler) {
        Alert.reqFail('请联系管理员');
        return handler.next(options);
      },
    ));
    dio.interceptors.add(DioCacheInterceptor(
        options: CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    )));
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
