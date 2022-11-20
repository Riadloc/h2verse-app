import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/utils/yidun_captcha/yidun_captcha.dart';
import 'package:h2verse_app/views/login.dart';
import 'package:h2verse_app/widgets/counter_down_text_button.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:provider/provider.dart';

class UserChangePassword extends StatefulWidget {
  const UserChangePassword({Key? key}) : super(key: key);

  static const routeName = '/userChangePassword';

  @override
  State<UserChangePassword> createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;
  int duration = 0;
  bool loading = false;
  String phone = '';
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  void onSendSms() {
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

  void onSubmit() async {
    String password = _passwordController.text;
    String code = _captchaController.text;
    if (password.isEmpty) {
      Toast.show('请输入密码');
      return;
    }
    if (code.isEmpty) {
      Toast.show('请输入密码');
      return;
    }
    setState(() {
      loading = true;
    });
    bool isSuccess = await UserService.changePassword(
      phone: phone,
      password: password,
      code: code,
    );
    if (isSuccess) {
      Get.dialog(
        Modal(
          title: '新密码已生效',
          confirmText: '重新登录',
          onConfirm: () {
            Get.offAllNamed(Login.routeName);
          },
        ),
      );
    }
    setState(() {
      loading = false;
    });
    // Get.offAllNamed(Login.routeName);
  }

  @override
  void initState() {
    super.initState();
    var args = Get.arguments;
    if (args != null) {
      phone = args as String;
    } else {
      var user = Provider.of<UserProvider>(context, listen: false).user;
      phone = user.phone;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (phone.isEmpty) {
        Get.dialog(
          Modal(
            title: '手机号缺失！',
            description: '修改手机号需要您的手机号信息',
            confirmText: '返回',
            onConfirm: () {
              Get.back(closeOverlays: true);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('修改登录密码'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Image.asset(
                'assets/images/Icons_BlueGreenGold_Planet_01.webp',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Text.rich(TextSpan(
                text: '手机号',
                style: const TextStyle(fontWeight: FontWeight.w500),
                children: [
                  const TextSpan(text: '：'),
                  TextSpan(
                      text: formatPhone(phone),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700))
                ])),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  LoginInput(
                    hintText: '新密码',
                    icon: Icons.lock_outline,
                    type: InputType.password,
                    obscure: obscure,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入新密码';
                      }
                      return null;
                    },
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LoginInput(
                    hintText: '验证码',
                    icon: Icons.tag,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入验证码';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ])),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(children: [
          Expanded(
              child: LoadingButton(
                  loading: loading,
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onSubmit();
                    }
                  },
                  child: const Text('提交修改')))
        ]),
      )),
    );
  }
}
