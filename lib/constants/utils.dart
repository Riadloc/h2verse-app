import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showToast(String title, {String message = '通知'}) {
  Get.snackbar(title, message,
      colorText: Colors.white,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
      // borderRadius: 0,
      duration: const Duration(milliseconds: 2000),
      animationDuration: const Duration(milliseconds: 300),
      barBlur: 1,
      icon: const Icon(
        Icons.notifications,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP);
}

String formatHex(String? hex) {
  if (hex == '' || hex == null) {
    return '';
  }
  return '${hex.substring(0, 6)}...${hex.substring(hex.length - 6)}';
}

String formatBankNo(String bankNo) {
  return '${bankNo.substring(0, 4)}********${bankNo.substring(bankNo.length - 4)}';
}
