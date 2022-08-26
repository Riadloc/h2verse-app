import 'package:flutter_net_captcha/flutter_net_captcha.dart';

class YidunCaptcha {
  factory YidunCaptcha() => _instance;
  static final YidunCaptcha _instance = YidunCaptcha._internal();
  YidunCaptcha._internal() {
    //
  }

  static YidunCaptcha get instance => _instance;

  static void init() {
    FlutterNetCaptcha.configVerifyCode(VerifyCodeConfig(
      captchaId: '7fbc4af8104c4da5b1881913248af751',
      closeButtonHidden: false,
      shouldCloseByTouchBackground: true,
    ));
  }

  static void show(
    dynamic Function(dynamic object) onSuccess,
    dynamic Function(dynamic object)? onClose,
  ) {
    instance._show(onSuccess, onClose);
  }

  void _show(
    dynamic Function(dynamic object) onSuccess,
    dynamic Function(dynamic object)? onClose,
  ) {
    FlutterNetCaptcha.showCaptcha(
        mode: VerifyCodeMode.Normal,
        language: VerifyLanguage.ZH_CN,
        onLoaded: () {
          print('onLoaded...');
        },
        onVerify: (VerifyCodeResponse response) {
          onSuccess(response);
        },
        onError: (String message) {
          print(message);
        },
        onClose: (VerifyCodeClose close) {
          if (onClose != null) {
            onClose(close);
          }
        });
  }
}
