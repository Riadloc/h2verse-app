import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:tobias/tobias.dart';
import 'package:h2verse_app/widgets/login_input.dart';

class Identity extends StatefulWidget {
  const Identity({Key? key}) : super(key: key);

  static const routeName = '/identity';

  @override
  State<Identity> createState() => _IdentityState();
}

class _IdentityState extends State<Identity> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _idNoController = TextEditingController();
  final _realNameController = TextEditingController();

  Future<void> onSubmit() async {
    String phone = _phoneController.text;
    String idNo = _idNoController.text;
    String realName = _realNameController.text;
    var preInfo = await UserService.preCertify(
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
    bool valid = await UserService.certify(
        verifyId: preInfo['certVerifyId'],
        code: authCode,
        realName: realName,
        idNo: idNo);
    if (valid) {
      getUserInfo();
      Get.back();
    }
  }

  void getUserInfo() {
    UserService.getUserInfo().then((value) {
      Provider.of<UserProvider>(context, listen: false).user = value;
    });
  }

  @override
  void initState() {
    super.initState();
    String phone = Provider.of<UserProvider>(context, listen: false).user.phone;
    _phoneController.text = phone;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _idNoController.dispose();
    _realNameController.dispose();
    super.dispose();
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
                      icon: Icons.numbers_outlined,
                      type: InputType.phone,
                      controller: _phoneController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginInput(
                      hintText: '姓名',
                      icon: Icons.person_outline,
                      controller: _realNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入姓名';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginInput(
                      hintText: '身份证号',
                      icon: Icons.person_pin_outlined,
                      controller: _idNoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入身份证号';
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
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(children: [
          Expanded(
              child: ElevatedButton(
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
                  child: const Text('立即实名')))
        ]),
      )),
    );
  }
}
