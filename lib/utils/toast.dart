import 'package:flutter_easyloading/flutter_easyloading.dart';

class Toast {
  static void _showToast(String message) {
    EasyLoading.showToast(message);
  }

  static void show(String message) {
    _showToast(message);
  }
}
