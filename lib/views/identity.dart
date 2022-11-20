import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:tobias/tobias.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:h2verse_app/utils/yidun_captcha/yidun_captcha.dart';

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

    var birth = idNo.substring(6, 14);
    birth =
        '${birth.substring(0, 4)}-${birth.substring(4, 6)}-${birth.substring(6, 8)}';
    var now = DateTime.now();
    final diff = now.difference(DateTime.parse(birth));
    if (diff.inDays < 365 * 18) {
      Toast.show('您还未满18岁，不可完成实名认证。\n氢宇宙中的数字藏品仅限实名认证为年满18周岁的中国大陆用户购买。');
      return;
    }
    void onSuccess() {
      getUserInfo();
      var box = Hive.box(LocalDB.BOX);
      var actCofig = box.get(LocalDB.ACT);
      if (actCofig != null) {
        actCofig = json.decode(actCofig);
        var goodId = actCofig['goodId'];
        if (goodId != null) {
          box.delete(LocalDB.ACT);
          Get.offAllNamed(ArtDetail.routeName, arguments: {
            'goodId': goodId,
            'artType': ArtType.main,
          });
          return;
        }
      }
      Get.back();
    }

    if (kIsWeb) {
      YidunCaptcha().show((object) async {
        if (object.result) {
          String code = object.validate as String;
          bool valid = await UserService.certifyWeb(
              phone: phone, code: code, realName: realName, idNo: idNo);
          if (valid) {
            onSuccess();
          }
        }
      });
    } else {
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
        onSuccess();
      }
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                        '1. 应国家相关政策要求，购买虚拟商品需要进行实名认证。实名认证接口由第三方运营商提供，根据平台《隐私政策》，我公司不会过度采集用户信息;'),
                    SizedBox(
                      height: 2,
                    ),
                    Text('2. 安卓用户可尝试在 App 客户端内完成实名认证（较稳定）')
                  ],
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
                      fillColor: Colors.grey.shade50,
                      controller: _phoneController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginInput(
                      hintText: '姓名',
                      icon: Icons.person_outline,
                      controller: _realNameController,
                      fillColor: Colors.grey.shade50,
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
                      fillColor: Colors.grey.shade50,
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
