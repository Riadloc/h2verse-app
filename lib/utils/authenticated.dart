// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/toast.dart';

class Authenticated {
  static Future<bool> auth() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: '请校验您的指纹/FaceID',
              authMessages: const <AuthMessages>[
                AndroidAuthMessages(
                  signInTitle: '指纹密码',
                  biometricHint: '',
                  cancelButton: '取消',
                ),
                IOSAuthMessages(
                  cancelButton: '取消',
                ),
              ],
              options: const AuthenticationOptions(
                  biometricOnly: true, useErrorDialogs: false));
          if (!didAuthenticate) {
            Toast.show('校验失败');
          }
          return didAuthenticate;
        } on PlatformException catch (e) {
          if (e.code == auth_error.notEnrolled) {
            Alert.fail('设备不支持');
          } else if (e.code == auth_error.lockedOut ||
              e.code == auth_error.permanentlyLockedOut) {
            Alert.fail('失败次数过多');
          } else if (e.code == 'auth_in_progress') {
            Alert.fail('正在进行验证...');
            auth.stopAuthentication();
          } else {
            Alert.fail(e.message ?? '发生错误，请重试');
          }
          return false;
        }
      }
    }
    return false;
  }
}
