import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:easy_refresh_skating/easy_refresh_skating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pearmeta_fapp/constants/routes.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/views/art_detail.dart';
import 'package:pearmeta_fapp/views/home_wrapper.dart';
import 'package:pearmeta_fapp/utils/yindun_captcha.dart';
// ignore: unused_import
import 'package:pearmeta_fapp/utils/http.dart';

void main() {
  runApp(const MyApp());

  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
  GoogleFonts.config.allowRuntimeFetching = false;
  YidunCaptcha.init();
  HttpUtils();
  // 全局设置
  EasyRefresh.defaultHeaderBuilder = () => const SkatingHeader();
  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
      infiniteOffset: 0, dragText: '获取中...', processedText: '完成');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: HomeWrapper.routeName,
      routes: routes,
      builder: EasyLoading.init(),
    );
  }
}
