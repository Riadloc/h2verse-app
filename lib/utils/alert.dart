import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alert {
  static void showAlert(String title,
      {String? message, Color? backgroundColor}) {
    Get.snackbar(title, message ?? '',
        colorText: Colors.white,
        backgroundColor: backgroundColor ?? const Color.fromRGBO(0, 0, 0, 0.8),
        duration: const Duration(milliseconds: 2000),
        animationDuration: const Duration(milliseconds: 300),
        barBlur: 1,
        icon: const Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.TOP);
  }

  static void show(
    String title,
  ) {
    showAlert(title, message: '通知');
  }

  static void success(
    String title,
  ) {
    showAlert(title,
        message: '成功', backgroundColor: const Color.fromRGBO(0, 168, 112, 1));
  }

  static void fail(
    String title,
  ) {
    showAlert(title,
        message: '失败', backgroundColor: const Color.fromRGBO(227, 77, 89, 1));
  }

  static void reqSuccess(
    String title,
  ) {
    showAlert(title,
        message: '请求成功', backgroundColor: const Color.fromRGBO(0, 168, 112, 1));
  }

  static void reqFail(
    String title,
  ) {
    showAlert(title,
        message: '请求错误', backgroundColor: const Color.fromRGBO(227, 77, 89, 1));
  }
}
