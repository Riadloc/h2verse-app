import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/about.dart';
import 'package:h2verse_app/views/identity.dart';
import 'package:h2verse_app/views/my_webview.dart';
import 'package:h2verse_app/views/acount/account_manage.dart';
import 'package:h2verse_app/views/acount/identity_detail.dart';
import 'package:h2verse_app/views/user/user_change_password.dart';
import 'package:h2verse_app/views/user/user_destory.dart';
import 'package:h2verse_app/views/user/user_edit.dart';
import 'package:h2verse_app/widgets/copy_field.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/tap_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  static const String routeName = '/setting';

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String version = '';
  String buildNumber = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPackageInfo();
    });
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
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
                    var user =
                        Provider.of<UserProvider>(context, listen: false).user;
                    if (user.certified == 1) {
                      Get.toNamed(IdentityDetail.routeName);
                    } else {
                      Get.toNamed(Identity.routeName);
                    }
                  },
                ),
                TapTile(
                  icon: Icons.public_outlined,
                  title: '数字钱包',
                  onTap: () {
                    var user =
                        Provider.of<UserProvider>(context, listen: false).user;
                    Get.bottomSheet(Container(
                      color: Colors.white,
                      height: 160,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '数字钱包地址',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          user.chainAccount.isNotEmpty
                              ? Column(
                                  children: [
                                    CopyField(text: user.chainAccount),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.black,
                                          child: Image.asset(
                                            'lib/assets/bsn.png',
                                            height: 30,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : LoadingButton(
                                  loading: loading,
                                  style: ElevatedButton.styleFrom(
                                      elevation: 1,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 16),
                                      foregroundColor: Colors.white,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap),
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    bool isSuccess =
                                        await UserService.applyMetaAccount();
                                    if (isSuccess) {
                                      Toast.show('创建数字钱包成功！');
                                      UserService.getUserInfo().then((value) {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user = value;
                                      });
                                      Get.back(closeOverlays: false);
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                  child: const Text('开通数字钱包'))
                        ],
                      ),
                    ));
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
                  icon: Icons.lightbulb_outline,
                  title: '关于我们',
                  onTap: () {
                    Get.toNamed(About.routeName);
                  },
                ),
                TapTile(
                  icon: Icons.update_outlined,
                  title: '检查更新',
                  onTap: () {
                    checkUpgrade(showNoUpdate: true);
                  },
                ),
                TapTile(
                  icon: Icons.no_accounts_outlined,
                  title: '账号注销',
                  onTap: () {
                    Get.toNamed(UserDestory.routeName);
                  },
                ),
              ])),
          TapTile(
            icon: Icons.power_settings_new,
            title: '退出登录',
            color: Colors.red,
            onTap: () {
              Get.dialog(Modal(
                title: '提示',
                description: '确认退出登录？',
                onConfirm: () {
                  UserService.logout();
                },
                onCancel: () {
                  Get.back(canPop: false);
                },
              ));
            },
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            // decoration:
            //     const BoxDecoration(color: Color.fromRGBO(248, 248, 249, 1)),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
              child: Column(
                children: [
                  Text.rich(TextSpan(
                      text: '氢宇宙 ',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                            text: 'H2VERSE.ART', style: GoogleFonts.kalam())
                      ])),
                  Text(
                    'v$version（$buildNumber）',
                    style: const TextStyle(fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
