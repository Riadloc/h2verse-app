import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/views/identity.dart';
import 'package:h2verse_app/views/login.dart';
import 'package:h2verse_app/utils/yidun_captcha/yidun_captcha.dart';
import 'package:h2verse_app/views/webview/my_webview.dart';
import 'package:h2verse_app/widgets/border_text.dart';

import 'package:h2verse_app/widgets/counter_down_text_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  static const String routeName = '/signup';

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isChecked = false;
  bool obscure = true;
  int duration = 0;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  void onSendSms() {
    String phone = _phoneController.text;
    if (phone.isEmpty) {
      Toast.show('请先输入手机号');
    } else {
      YidunCaptcha().show((object) {
        if (object.result) {
          String code = object.validate as String;
          UserService.sendSms(phone, code).then((value) {
            if (value != null) {
              Toast.show(value == 0 ? '发送验证码成功' : '请稍后发送');
              setState(() {
                duration = value > 0 ? value : 60;
              });
            }
          });
        }
      });
    }
  }

  void onSignup() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String code = _captchaController.text;
    if (code.isEmpty) {
      Toast.show('请输入验证码');
      return;
    }
    if (password.isEmpty) {
      Toast.show('请输入登录密码');
      return;
    }
    if (!isChecked) {
      Toast.show('请勾选同意《用户协议》与《隐私政策》');
      return;
    }
    var box = Hive.box(LocalDB.BOX);
    String? inviteCode = box.get(LocalDB.INVITE_CODE);
    UserService.singup(
            phone: phone,
            password: password,
            code: code,
            inviteCode: inviteCode)
        .then((value) {
      if (value != null) {
        Provider.of<UserProvider>(context, listen: false).user = value;
        var box = Hive.box(LocalDB.BOX);
        var actCofig = box.get(LocalDB.ACT);
        if (actCofig != null) {
          actCofig = json.decode(actCofig);
          var goodId = actCofig['goodId'];
          if (goodId != null) {
            Get.offAllNamed(Identity.routeName);
            return;
          }
        }
        Get.offAllNamed(HomeWrapper.routeName);
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/poster2.webp',
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.fitWidth,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Text(
                            'H2VERSE',
                            style: GoogleFonts.limelight(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 8
                                  ..color = Colors.white),
                          ),
                          Text(
                            'H2VERSE',
                            style: GoogleFonts.limelight(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 6, vertical: 2),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(6)),
                      //   child: const Text(
                      //     '解锁你的第一款专属数字作品',
                      //     style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.bold,
                      //         letterSpacing: 2),
                      //   ),
                      // )
                      const BorderText(
                          text: '解锁你的第一款专属数字作品', fontSize: 14, strokeWidth: 2)
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                        boxShadow: kCardBoxShadow),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '注 册',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        LoginInput(
                          hintText: '手机号',
                          icon: Icons.person_outline,
                          type: InputType.phone,
                          fillColor: Colors.grey.shade50,
                          controller: _phoneController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        LoginInput(
                          hintText: '验证码',
                          icon: Icons.tag,
                          type: InputType.captcha,
                          fillColor: Colors.grey.shade50,
                          controller: _captchaController,
                          suffix: CounterDownTextButton(
                            duration: duration,
                            onPressed: onSendSms,
                            onFinished: () {
                              setState(() {
                                duration = 0;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        LoginInput(
                          hintText: '密码',
                          icon: Icons.lock_outline,
                          obscure: obscure,
                          fillColor: Colors.grey.shade50,
                          controller: _passwordController,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            padding: const EdgeInsets.all(0),
                            icon: Icon(obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            iconSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  textStyle: const TextStyle(fontSize: 16),
                                  foregroundColor: Colors.white),
                              onPressed: onSignup,
                              child: const Text('注 册')),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              shape: const CircleBorder(),
                              value: isChecked,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const Text('我已阅读并同意'),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  Get.toNamed(MyWebview.routeName, arguments: {
                                    'title': '用户协议',
                                    'url':
                                        'https://static.h2verse.art/agreement/user'
                                  });
                                },
                                child: const Text('《用户协议》')),
                            const Text('与'),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  Get.toNamed(MyWebview.routeName, arguments: {
                                    'title': '隐私协议',
                                    'url':
                                        'https://static.h2verse.art/agreement/privacy'
                                  });
                                },
                                child: const Text('《隐私政策》')),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('已有账号？'),
                            TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(30, 20),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  Get.offNamed(Login.routeName);
                                },
                                child: const Text('登录')),
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              )
            ],
          ),
        ));
  }
}
