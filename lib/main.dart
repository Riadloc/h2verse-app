import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/models/user_model.dart';
import 'package:h2verse_app/providers/common_provider.dart';
import 'package:h2verse_app/services/common_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/routes.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/utils/yindun_captcha.dart';
import 'package:h2verse_app/utils/http.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await Hive.openBox(LocalDB.BOX);
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
  GoogleFonts.config.allowRuntimeFetching = false;
  if (!kIsWeb) {
    YidunCaptcha.init();
  }
  HttpUtils();
  // 全局设置
  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
        dragText: '下拉刷新',
        armedText: '释放开始',
        readyText: '刷新中',
        processingText: '刷新中',
        processedText: '成功啦',
        noMoreText: '没有更多',
        failedText: '失败了',
        messageText: '最后更新于 %T',
      );
  EasyRefresh.defaultFooterBuilder = () => const MaterialFooter();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0a21ec2254474408a48dfdb7e7c6a86d@o4503920768385024.ingest.sentry.io/4503920775528448';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CommonProvider()),
      ],
      child: const MyApp(),
    )),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //上传隐私协议许可
    MobpushPlugin.updatePrivacyPermissionStatus(true).then((value) {
      if (kDebugMode) {
        print(">>>>>>>>>>updatePrivacyPermissionStatus:$value");
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      checkUpgrade();
      var homeInfo = await CommonService.getAppHomeInitialInfo();
      if (homeInfo != null && homeInfo?['userInfo'] != null) {
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false).user =
            User.fromJson(homeInfo['userInfo']);
        Provider.of<CommonProvider>(context, listen: false)
            .setApollo(homeInfo['apollo']);
      }
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '氢宇宙',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: HomeWrapper.routeName,
      routes: routes,
      builder: EasyLoading.init(),
    );
  }
}
