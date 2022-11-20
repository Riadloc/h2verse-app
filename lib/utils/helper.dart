// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:h2verse_app/models/version_upgrade_info_model.dart';
import 'package:h2verse_app/services/common_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/upgrade_modal.dart';
import 'package:h2verse_app/widgets/register_web_plugins/register_web_env_stub.dart'
    if (dart.library.html) 'package:h2verse_app/widgets/register_web_plugins/register_web_env.dart';

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

String formatPhone(String phone) {
  return '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}';
}

String formatHex(String? hex) {
  if (hex == '' || hex == null) {
    return '';
  }
  return '${hex.substring(0, 6)}....${hex.substring(hex.length - 6)}';
}

String formatBankNo(String bankNo) {
  return '${bankNo.substring(0, 4)}********${bankNo.substring(bankNo.length - 4)}';
}

String formartDate(String dateString,
    {bool timeZone = true, showFull = false}) {
  var date = DateTime.parse(dateString);
  var now = DateTime.now();
  if (timeZone) {
    date = date.add(const Duration(hours: 8));
  }
  final diff = now.difference(date);
  if (diff.inHours.abs() < 24) {
    String dire = diff.inHours >= 0 ? '前' : '后';
    if (diff.inMinutes.abs() < 1) {
      return '${diff.inSeconds.abs()}秒$dire';
    }
    if (diff.inHours.abs() < 1) {
      return '${diff.inMinutes.abs()}分钟$dire';
    }
    return '${diff.inHours.abs()}小时$dire';
  }
  if (diff.inDays < 366 && !showFull) {
    return DateFormat('MM-dd HH:mm').format(date);
  }
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

String formartTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inDays < 366) {
    return DateFormat('MM-dd HH:mm').format(date);
  }
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

int checkDateInRange({required List<String> range}) {
  var now = DateTime.now();
  if (now.compareTo(DateTime.parse(range[0])) == -1) {
    return -1;
  }
  if (now.compareTo(DateTime.parse(range[1])) == 1) {
    return 1;
  }
  return 0;
}

Future<Map<String, String>> getReportParams() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? model = '';
  if (GetPlatform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    model = androidInfo.model;
  } else if (GetPlatform.isAndroid) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    model = iosInfo.utsname.machine;
  } else if (GetPlatform.isWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    model = webBrowserInfo.userAgent?.split(' ').last;
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return {'deviceInfo': (model ?? '') + packageInfo.version};
}

Future getUserAgent() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (GetPlatform.isWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    return webBrowserInfo.userAgent ?? '';
  }
  return '';
}

Future<bool> isWeixin() async {
  String userAgent = await getUserAgent();
  return RegExp('MicroMessenger', caseSensitive: false).hasMatch(userAgent);
}

Future<bool> isiOSBrower() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (GetPlatform.isWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    String userAgent = webBrowserInfo.userAgent ?? '';
    var result = RegExp(r'\(i[^;]+;( U;)? CPU.+Mac OS X').allMatches(userAgent);
    return result.isNotEmpty;
  }
  return false;
}

void checkUpgrade({bool showNoUpdate = false}) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  AppUpgradeInfo? versionInfo = await CommonService.getNewestVersion();
  if (versionInfo != null) {
    if (versionInfo.version != packageInfo.version) {
      if (kIsWeb) {
        Get.dialog(Modal(
            title: '版本更新',
            description: '氢宇宙最新版来啦，请刷新网页进行更新',
            confirmText: '刷新',
            onConfirm: () {
              reload();
            }));
      } else {
        String confirmText = GetPlatform.isIOS ? '立即更新' : '浏览器下载';
        Get.dialog(
            UpgradeModal(
              title: '版本更新',
              description: '氢宇宙最新版来啦，快更新尝鲜~',
              confirmText: confirmText,
              onConfirm: () async {
                Get.back(closeOverlays: false);
                final Uri url = Uri.parse(versionInfo.url);
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  Toast.show('无法启动外部浏览器');
                }
              },
              onCancel: versionInfo.force == 0
                  ? () {
                      Get.back(closeOverlays: false);
                    }
                  : null,
            ),
            barrierDismissible: false);
      }
      return;
    }
  }
  if (showNoUpdate) {
    Toast.show('已经是最新版本');
  }
}

class Dimension {
  Dimension(
    this.width,
    this.height,
  );

  final double width;
  final double height;
}

Dimension getDimensions() {
  final size = Get.size;
  if (kIsWeb) {
    const mobileWidthThreshold = 500;
    const mobileWidth = 420.0;
    const mobileHeight = 900.0;
    final hasFrame = size.width > mobileWidthThreshold;
    if (hasFrame) {
      return Dimension(mobileWidth, mobileHeight);
    }
  }
  return Dimension(size.width, size.height);
}
