import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_captcha/flutter_net_captcha.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/utils/alert.dart';
import 'package:pearmeta_fapp/utils/toast.dart';
import 'package:pearmeta_fapp/views/signup.dart';

import 'package:pearmeta_fapp/widgets/counter_down_text_button.dart';
import 'package:pearmeta_fapp/widgets/login_input.dart';
import 'package:pearmeta_fapp/utils/yindun_captcha.dart';

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
        Alert.fail('请输入验证码');
        return;
      }
    } else {
      if (password.isEmpty) {
        Alert.fail('请输入登录密码');
        return;
      }
    }
    if (!isChecked) {
      Alert.fail('请勾选同意《用户协议》与《隐私政策》');
      return;
    }
    artService.login(phone: phone, password: password, code: code);
  }

  void onSendSms() {
    String phone = _phoneController.text;
    if (phone.isEmpty) {
      Alert.fail('请先输入手机号');
    } else {
      YidunCaptcha.show((object) {
        VerifyCodeResponse resp = object;
        if (resp.result == true) {
          String code = resp.validate as String;
          artService.sendSms(phone, code).then((value) {
            Toast.show('发送验证码成功');
            setState(() {
              duration = 3;
            });
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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset('lib/assets/img_placeholder.jpg'),
              // const Positioned(
              //   top: 100,
              //   left: 30,
              //   child: Text(
              //     '梨数字',
              //     style: TextStyle(color: Colors.white, fontSize: 28),
              //   ),
              // ),
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
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                : CupertinoIcons.eye_slash)),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => debugPrint('111'),
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
                          onPrimary: Colors.white),
                      onPressed: onLogin,
                      child: const Text('登 录')),
                ),
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
                        onPressed: () => debugPrint('111'),
                        child: const Text('《用户协议》')),
                    const Text('与'),
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        onPressed: () => debugPrint('111'),
                        child: const Text('《隐私政策》')),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
