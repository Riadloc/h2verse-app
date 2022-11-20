@JS()
library yidun_captcha;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('initNECaptchaWithFallback')
external void initNECaptchaWithFallback(Options obj,
    Function(dynamic object) onLoad, Function(dynamic object) onError);

@JS()
@anonymous
class Options {
  external String get element;
  external String get captchaId;
  external String get mode;
  external String get lang;
  external Function(dynamic err, dynamic data) get onVerify;
  external Function() get onClose;
  // Must have an unnamed factory constructor with named arguments.
  external factory Options(
      {String element,
      String captchaId,
      String mode,
      String lang,
      Function(dynamic err, [dynamic data]) onVerify,
      Function(dynamic data) onClose});
}

class CaptchaResult {
  CaptchaResult(this.result, this.validate);
  final bool result;
  final String validate;
}

class YidunCaptcha {
  static YidunCaptcha? _instance;

  YidunCaptcha._internal();

  factory YidunCaptcha() {
    _instance ??= YidunCaptcha._internal();
    return _instance!;
  }

  void show(dynamic Function(dynamic object) onSuccess,
      {dynamic Function()? onClose}) {
    initNECaptchaWithFallback(
        Options(
            element: '#captcha',
            captchaId: '7fbc4af8104c4da5b1881913248af751',
            mode: 'popup',
            lang: 'zh-CN',
            onVerify: allowInterop((err, [data]) {
              if (err != null) {
                onSuccess(CaptchaResult(false, ''));
                return;
              }
              onSuccess(CaptchaResult(true, getProperty(data, 'validate')));
            }),
            onClose: allowInterop((data) {
              onClose?.call();
            })), allowInterop((obj) {
      callMethod(obj, 'popUp', []);
    }), allowInterop((error) {
      print(error);
    }));
  }
}
