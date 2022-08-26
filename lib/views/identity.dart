import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:tobias/tobias.dart';
import 'package:pearmeta_fapp/widgets/login_input.dart';

class Identity extends StatefulWidget {
  const Identity({Key? key}) : super(key: key);

  static const routeName = '/identity';

  @override
  State<Identity> createState() => _IdentityState();
}

class _IdentityState extends State<Identity> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '17764591736');
  final _idNoController = TextEditingController(text: '511325199605303510');
  final _realNameController = TextEditingController(text: '王洋');

  Future<void> onSubmit() async {
    String phone = _phoneController.text;
    String idNo = _idNoController.text;
    String realName = _realNameController.text;
    var preInfo = await artService.preCertify(
        realName: realName, idNo: idNo, phone: phone);
    var authInfo = await aliPayAuth(preInfo['authInfo']);
    String resultStr = authInfo['result'];
    var result = RegExp(r'[\w_]+?=[^&]+').allMatches(resultStr);
    String authCode = '';
    for (var element in result) {
      String? match = element.group(0);
      if (match != null && match.contains('auth_code')) {
        authCode = match.split('=')[1];
      }
    }
    bool valid = await artService.certify(
        verifyId: preInfo['certVerifyId'], code: authCode);
    if (valid) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('实名认证'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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
                      hintText: '手机号',
                      icon: Icons.phone_outlined,
                      type: InputType.phone,
                      controller: _phoneController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginInput(
                      hintText: '身份证号',
                      icon: Icons.recent_actors_outlined,
                      controller: _idNoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入身份证号';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginInput(
                      hintText: '姓名',
                      icon: Icons.account_circle_outlined,
                      controller: _realNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入姓名';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
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
                          onSubmit();
                        }
                      },
                      child: const Text('立即实名')))
            ]),
          )),
    );
  }
}
