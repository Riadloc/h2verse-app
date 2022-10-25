import 'package:captcha_plugin_flutter/captcha_plugin_flutter.dart';

class YidunCaptcha {
  static YidunCaptcha? _instance;
  late CaptchaPluginFlutter _captchaPlugin;

  YidunCaptcha._internal() {
    _captchaPlugin = CaptchaPluginFlutter();
    _captchaPlugin.init({
      "captcha_id": "7fbc4af8104c4da5b1881913248af751",
      "is_debug": true,
      "is_no_sense_mode": false,
      "dimAmount": 0.8,
      "is_touch_outside_disappear": true,
      "timeout": 8000,
      "is_hide_close_button": false,
      "use_default_fallback": true,
      "failed_max_retry_count": 4,
      "language_type": "zh-CN",
      "is_close_button_bottom": true,
    });
  }

  factory YidunCaptcha() {
    _instance ??= YidunCaptcha._internal();
    return _instance!;
  }

  void show(
    dynamic Function(dynamic object) onSuccess,
    dynamic Function(dynamic object)? onClose,
  ) {
    _captchaPlugin.showCaptcha(onLoaded: () {
      print("================onLoaded==============");
    }, onSuccess: (dynamic data) {
      print(data);
      onSuccess(data);
    }, onClose: (dynamic data) {
      if (onClose != null) {
        onClose(data);
      }
    }, onError: (dynamic data) {
      print(data);
    });
  }
}
