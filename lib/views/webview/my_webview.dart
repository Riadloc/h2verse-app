import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:h2verse_app/widgets/register_webview/register_web_webview_stub.dart'
    if (dart.library.html) 'package:h2verse_app/widgets/register_webview/register_web_webview.dart';

class MyWebview extends StatefulWidget {
  const MyWebview({Key? key}) : super(key: key);

  static const routeName = '/myWebview';

  @override
  State<MyWebview> createState() => _MyWebviewState();
}

class _MyWebviewState extends State<MyWebview> {
  @override
  void initState() {
    super.initState();
    if (GetPlatform.isAndroid) WebView.platform = AndroidWebView();
    registerWebViewWebImplementation();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(arguments['title']),
        ),
        body: WebView(
          initialUrl: arguments['url'],
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            EasyLoading.show(status: '星球登陆中...');
            if (kIsWeb) {
              Future.delayed(
                  const Duration(seconds: 1), () => EasyLoading.dismiss());
            }
          },
          onPageFinished: (url) {
            EasyLoading.dismiss();
          },
        ));
  }
}
