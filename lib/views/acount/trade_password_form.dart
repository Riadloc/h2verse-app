import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_net_captcha/flutter_net_captcha.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/utils/yindun_captcha.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';

class TradePasswordForm extends StatefulWidget {
  const TradePasswordForm({super.key});

  static const routeName = '/tradePasswordForm';

  @override
  State<TradePasswordForm> createState() => _TradePasswordFormState();
}

class _TradePasswordFormState extends State<TradePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  var payKeyController = TextEditingController();
  var passwordController = TextEditingController();
  bool loading = false;
  bool obscure = true;

  void onSubmit(String payKey, String password) async {
    setState(() {
      loading = true;
    });
    bool isSuccess =
        await UserService.savePayKey(payKey: payKey, password: password);
    if (isSuccess) {
      Toast.show('修改交易密码成功！');
      Get.back();
      return;
    }
    setState(() {
      loading = false;
    });
  }

  void beforeSubmit() {
    String payKey = payKeyController.text;
    String password = passwordController.text;
    if (payKey.isEmpty) {
      Toast.show('请输入交易密码');
      return;
    }
    if (password.isEmpty) {
      Toast.show('请输入登录密码');
      return;
    }
    YidunCaptcha.show((object) {
      VerifyCodeResponse resp = object;
      if (resp.result == true) {
        onSubmit(payKey, password);
      }
    }, (object) => null);
  }

  @override
  void dispose() {
    payKeyController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: const Text('交易密码'),
        ),
        body: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoginInput(
                    hintText: '交易密码',
                    icon: CupertinoIcons.number_circle,
                    type: InputType.captcha,
                    controller: payKeyController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  LoginInput(
                    hintText: '密码',
                    icon: CupertinoIcons.lock_circle,
                    type: InputType.password,
                    obscure: obscure,
                    controller: passwordController,
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
                ],
              )),
        ),
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
                        beforeSubmit();
                      }
                    },
                    child: const Text('提交')))
          ]),
        )));
  }
}
