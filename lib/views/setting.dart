import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/views/about_us.dart';
import 'package:pearmeta_fapp/views/account_manage.dart';
import 'package:pearmeta_fapp/views/identity_detail.dart';
import 'package:pearmeta_fapp/views/user_change_password.dart';
import 'package:pearmeta_fapp/views/user_edit.dart';
import 'package:pearmeta_fapp/widgets/tap_tile.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  static const String routeName = '/setting';

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('设置'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            color: const Color.fromRGBO(248, 248, 249, 1),
            child: const Text('账户信息'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                TapTile(
                  icon: Icons.face_outlined,
                  title: '个人资料',
                  onTap: () {
                    Get.toNamed(UserEdit.routeName);
                  },
                ),
                TapTile(
                  icon: Icons.key_outlined,
                  title: '修改登录密码',
                  onTap: () {
                    Get.toNamed(UserChangePassword.routeName);
                  },
                ),
                TapTile(
                  icon: Icons.wallet_outlined,
                  title: '账户管理',
                  onTap: () {
                    Get.toNamed(AccountManage.routeName);
                  },
                ),
                TapTile(
                  icon: Icons.gpp_good_outlined,
                  title: '实名认证',
                  onTap: () {
                    Get.toNamed(IdentityDetail.routeName);
                  },
                ),
                TapTile(
                  icon: Icons.public_outlined,
                  title: '数字账户',
                  onTap: () {
                    //
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            color: const Color.fromRGBO(248, 248, 249, 1),
            child: const Text('其他'),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(children: [
                TapTile(
                  icon: Icons.policy_outlined,
                  title: '隐私协议',
                  onTap: () {
                    Get.toNamed(AboutUs.routeName);
                  },
                ),
                TapTile(
                  icon: Icons.lightbulb_outline,
                  title: '关于我们',
                  onTap: () {
                    //
                  },
                ),
                TapTile(
                  icon: Icons.no_accounts_outlined,
                  title: '账号注销',
                  onTap: () {
                    //
                  },
                ),
              ])),
          TapTile(
            icon: Icons.power_settings_new,
            title: '退出登录',
            color: Colors.red,
            onTap: () {
              Get.defaultDialog(
                  onConfirm: () {
                    Get.back();
                  },
                  onCancel: () {
                    //
                  },
                  textConfirm: '确认',
                  textCancel: '取消',
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.red,
                  buttonColor: Colors.red,
                  title: '提示',
                  middleText: "确认退出登录？");
            },
          )
        ],
      ),
    );
  }
}
