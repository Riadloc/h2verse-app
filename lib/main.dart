import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:h2verse_app/models/order_model.dart';
import 'package:h2verse_app/views/detail/art_power_consume.dart';
import 'package:h2verse_app/views/openauth.dart';
import 'package:h2verse_app/views/order/orders.dart';
import 'package:h2verse_app/views/other/activity.dart';
import 'package:h2verse_app/widgets/register_web_plugins/register_web_plugins_stub.dart'
    if (dart.library.html) 'package:h2verse_app/widgets/register_web_plugins/register_web_plugins.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/routes.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/user_model.dart';
import 'package:h2verse_app/providers/common_provider.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/common_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/http.dart';
import 'package:h2verse_app/views/home_wrapper.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  await Hive.initFlutter();
  await Hive.openBox(LocalDB.BOX);
  if (GetPlatform.isAndroid) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
  GoogleFonts.config.allowRuntimeFetching = false;
  HttpUtils();
  // 全局设置
  if (kIsWeb) {
    usePathUrlStrategy();
    EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
  } else {
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
  }
  EasyRefresh.defaultFooterBuilder = () => const MaterialFooter();
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.fadingCube;

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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const _mobileWidthThreshold = 500;
  static const _mobileWidth = 420.0;
  static const _mobileHeight = 900.0;

  bool _hasFrame = false;
  bool get _checkSize => !GetPlatform.isMobile || GetPlatform.isWeb;

  Widget _buildFrame(Widget app) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        body: Center(
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.symmetric(vertical: 16),
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              height: _mobileHeight,
              width: _mobileWidth,
              child: app,
            ),
          ),
        ),
      );
    });
  }

  @override
  void didChangeMetrics() {
    if (_checkSize) {
      final size = Get.size;
      final hasFrame = size.width > _mobileWidthThreshold;
      if (_hasFrame != hasFrame) {
        setState(() {
          _hasFrame = hasFrame;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      //上传隐私协议许可
      MobpushPlugin.updatePrivacyPermissionStatus(true).then((value) {
        if (kDebugMode) {
          print(">>>>>>>>>>updatePrivacyPermissionStatus:$value");
        }
      });

      FlutterNativeSplash.remove();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kIsWeb) {
        checkUpgrade();
      }
      var homeInfo = await CommonService.getAppHomeInitialInfo();
      if (homeInfo != null && homeInfo?['userInfo'] != null) {
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false).user =
            User.fromJson(homeInfo['userInfo']);
        // ignore: use_build_context_synchronously
        Provider.of<CommonProvider>(context, listen: false)
            .setApollo(homeInfo['apollo']);
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '氢宇宙',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: HomeWrapper.routeName,
      routes: routes,
      onGenerateRoute: (settings) {
        String routeName = settings.name!;
        if (routeName.contains(OpenAuth.routeName)) {
          return MaterialPageRoute(
            builder: (context) {
              return const OpenAuth();
            },
          );
        }
        if (routeName.contains(ArtPowerConsume.routeName)) {
          return MaterialPageRoute(
            builder: (context) {
              return const ArtPowerConsume();
            },
          );
        }
        if (routeName.contains(Orders.routeName)) {
          return MaterialPageRoute(
            builder: (context) {
              return const Orders();
            },
          );
        }
        if (routeName.contains('/index')) {
          return MaterialPageRoute(
            builder: (context) {
              return const HomeWrapper();
            },
          );
        }
        if (routeName.contains('act_')) {
          return MaterialPageRoute(
            builder: (context) {
              return const Activity();
            },
          );
        }
        return null;
      },
      builder: (context, widget) {
        Widget child = EasyLoading.init()(context, widget);
        if (_checkSize) {
          final size = Get.size;
          final _hasFrame = size.width > _mobileWidthThreshold;
          if (_hasFrame) {
            return _buildFrame(child);
          }
        }
        return child;
      },
    );
  }
}
