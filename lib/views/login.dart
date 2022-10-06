import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_captcha/flutter_net_captcha.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/views/my_webview.dart';
import 'package:h2verse_app/views/signup.dart';
import 'package:h2verse_app/widgets/cached_image.dart';

import 'package:h2verse_app/widgets/counter_down_text_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:h2verse_app/utils/yindun_captcha.dart';
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
      YidunCaptcha.show((object) {
        VerifyCodeResponse resp = object;
        if (resp.result == true) {
          String code = resp.validate as String;
          UserService.sendSms(phone, code).then((value) {
            if (value != null) {
              Toast.show(value == 0 ? '发送验证码成功' : '请稍后发送');
              setState(() {
                duration = value > 0 ? value : 60;
              });
            }
          });
        }
      }, (object) => null);
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
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset('lib/assets/materials.webp'),
              Positioned.fill(
                child: Center(
                  child: Text(
                    'H2VERSE',
                    style: GoogleFonts.kalam(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: const <Shadow>[
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 8.0,
                          color: Colors.lightBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  '登录',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                LoginInput(
                  hintText: '手机号',
                  icon: CupertinoIcons.phone_circle,
                  type: InputType.phone,
                  controller: _phoneController,
                ),
                const SizedBox(
                  height: 20,
                ),
                showCode
                    ? LoginInput(
                        hintText: '验证码',
                        icon: CupertinoIcons.number_circle,
                        type: InputType.captcha,
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
                      )
                    : LoginInput(
                        hintText: '密码',
                        icon: CupertinoIcons.lock_circle,
                        type: InputType.password,
                        obscure: obscure,
                        controller: _passwordController,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          padding: const EdgeInsets.all(0),
                          icon: Icon(obscure
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash),
                          iconSize: 18,
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () =>
                            {Toast.show('请使用验证码登录方式成功登录后，从设置页里进行修改密码操作')},
                        child: const Text('忘记密码')),
                    TextButton(
                        onPressed: () => {
                              setState(() {
                                showCode = !showCode;
                              })
                            },
                        child: Text(showCode ? '密码登录' : '免密码登录')),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                          foregroundColor: Colors.white),
                      onPressed: onLogin,
                      child: const Text('登 录')),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      shape: const CircleBorder(),
                      value: isChecked,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                            'url': 'https://h2verse.art/agreement/user'
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
                            'url': 'https://h2verse.art/agreement/privacy'
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
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.all(0)),
                        onPressed: () {
                          Get.offNamed(Signup.routeName);
                        },
                        child: const Text('注册')),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
