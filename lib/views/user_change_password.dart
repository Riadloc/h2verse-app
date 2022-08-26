import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pearmeta_fapp/widgets/counter_down_text_button.dart';
import 'package:pearmeta_fapp/widgets/login_input.dart';

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

  void onSendSms() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('修改登录密码'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Center(
              child: Image.asset(
                'lib/assets/Icons_BlueGreenGold_Planet_01.webp',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  LoginInput(
                    hintText: '新密码',
                    icon: CupertinoIcons.lock_circle,
                    obscure: obscure,
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
                        icon: Icon(obscure
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LoginInput(
                    hintText: '验证码',
                    icon: CupertinoIcons.number_circle,
                    type: InputType.captcha,
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
                ],
              ),
            ),
          ])),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                          onPrimary: Colors.white),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //
                        }
                      },
                      child: const Text('提交')))
            ]),
          )),
    );
  }
}
