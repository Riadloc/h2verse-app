import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/views/webview/my_webview.dart';
import 'package:h2verse_app/views/signup.dart';

import 'package:h2verse_app/widgets/counter_down_text_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:h2verse_app/utils/yidun_captcha/yidun_captcha.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  bool showCode = false;
  bool obscure = true;
  int duration = 0;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  void onLogin() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String code = _captchaController.text;
    if (showCode) {
      if (code.isEmpty) {
        Toast.show('请输入验证码');
        return;
      }
    } else {
      if (password.isEmpty) {
        Toast.show('请输入登录密码');
        return;
      }
    }
    if (!isChecked) {
      Toast.show('请勾选同意《用户协议》与《隐私政策》');
      return;
    }
    UserService.login(phone: phone, password: password, code: code)
        .then((value) {
      if (value != null) {
        Provider.of<UserProvider>(context, listen: false).user = value;
        Get.offAllNamed(HomeWrapper.routeName);
      }
    });
  }

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

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   leadingWidth: 0,
        //   toolbarHeight: 180,
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        // ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight,
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
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                          children: [
                            const Text(
                              '登 录',
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
                                controller: _phoneController,
                                fillColor: Colors.grey.shade50),
                            const SizedBox(
                              height: 20,
                            ),
                            showCode
                                ? LoginInput(
                                    hintText: '验证码',
                                    icon: Icons.tag,
                                    type: InputType.captcha,
                                    controller: _captchaController,
                                    fillColor: Colors.grey.shade50,
                                    suffix: CounterDownTextButton(
                                      duration: duration,
                                      onPressed: onSendSms,
                                      onFinished: () {
                                        setState(() {
                                          duration = 0;
                                        });
                                      },
                                    ),
                                  )
                                : LoginInput(
                                    hintText: '密码',
                                    icon: Icons.lock_outline,
                                    type: InputType.password,
                                    obscure: obscure,
                                    controller: _passwordController,
                                    fillColor: Colors.grey.shade50,
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
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // TextButton(
                                //     onPressed: () => {
                                //           Toast.show(
                                //               '请使用验证码登录方式成功登录后，从设置页里进行修改密码操作')
                                //         },
                                //     child: const Text('忘记密码')),
                                TextButton(
                                    onPressed: () => {
                                          setState(() {
                                            showCode = !showCode;
                                          })
                                        },
                                    child: Text(showCode ? '密码登录' : '免密码登录')),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      textStyle: const TextStyle(fontSize: 16),
                                      foregroundColor: Colors.white),
                                  onPressed: onLogin,
                                  child: const Text('登 录')),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(30, 20),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  Get.offAllNamed(HomeWrapper.routeName);
                                },
                                child: const Text('随便逛逛')),
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
                                      Get.toNamed(MyWebview.routeName,
                                          arguments: {
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
                                      Get.toNamed(MyWebview.routeName,
                                          arguments: {
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
                                const Text('还没有账号？'),
                                TextButton(
                                    style: TextButton.styleFrom(
                                        minimumSize: const Size(30, 20),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        padding: const EdgeInsets.all(0)),
                                    onPressed: () {
                                      Get.offNamed(Signup.routeName);
                                    },
                                    child: const Text('注册')),
                              ],
                            ),
                          ],
                        ),
                      )),
                      // Padding(padding: MediaQuery.of(context).viewInsets),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
