import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/views/webview/my_webview.dart';

import 'package:h2verse_app/widgets/counter_down_text_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:h2verse_app/utils/yidun_captcha/yidun_captcha.dart';
import 'package:h2verse_app/widgets/register_web_plugins/register_web_env_stub.dart'
    if (dart.library.html) 'package:h2verse_app/widgets/register_web_plugins/register_web_env.dart';

class OpenAuth extends StatefulWidget {
  const OpenAuth({Key? key}) : super(key: key);

  static const String routeName = '/authorize';

  @override
  State<OpenAuth> createState() => _OpenAuthState();
}

class _OpenAuthState extends State<OpenAuth> {
  bool isChecked = false;
  bool obscure = true;
  int duration = 0;
  final _phoneController = TextEditingController();
  final _captchaController = TextEditingController();

  void onAuth() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    String phone = _phoneController.text;
    String code = _captchaController.text;
    if (code.isEmpty) {
      Toast.show('请输入验证码');
      return;
    }
    if (!isChecked) {
      Toast.show('请勾选同意《用户协议》与《隐私政策》');
      return;
    }
    Uri uri = Uri.base;
    var query = uri.queryParameters;
    Map<String, String> newQuery = {...query};
    if (newQuery['resultUrl'] != null) {
      newQuery['resultUrl'] =
          '${newQuery['resultUrl']}#/pages/authorizationResult/index';
    }
    UserService.authorize(phone: phone, code: code, extra: newQuery)
        .then((value) {
      if (value != null) {
        var callbackUrl = value['callbackUrl'];
        openLink(callbackUrl);
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

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    _phoneController.dispose();
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
                          '授 权',
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
                        LoginInput(
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
                              onPressed: onAuth,
                              child: const Text('授 权')),
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
