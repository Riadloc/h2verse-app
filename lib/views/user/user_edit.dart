import 'package:flutter/material.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:provider/provider.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({Key? key}) : super(key: key);

  static const routeName = '/userEdit';

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserProvider>(context, listen: false).user;
    _nameController.text = user.nickname;
    _emailController.text = user.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void updateInfo() async {
    var name = _nameController.text;
    var email = _emailController.text;
    setState(() {
      loading = true;
    });
    bool isSuccessed =
        await UserService.updateUserInfo(name: name, email: email);
    if (isSuccessed) {
      Toast.show('资料更新成功！');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('个人信息'),
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
                    hintText: '昵称',
                    icon: Icons.yard_outlined,
                    controller: _nameController,
                    type: InputType.nickname,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入昵称';
                      }
                      int len = 0;
                      for (var element in value.codeUnits) {
                        len += element > 122 ? 2 : 1;
                      }
                      if (len < 6) {
                        return '字数小于最少字数限制';
                      }
                      if (len > 16) {
                        return '超过字数限制';
                      }
                      return null;
                    },
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // LoginInput(
                  //   hintText: '邮箱',
                  //   icon: Icons.email_outlined,
                  //   type: InputType.email,
                  //   controller: _emailController,
                  //   validator: (value) {
                  //     if (value != null && value.isNotEmpty) {
                  //       var reg = RegExp(
                  //           r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.([a-zA-Z0-9]+)$');
                  //       if (!reg.hasMatch(value)) {
                  //         return '邮箱格式不正确';
                  //       }
                  //     }
                  //     return null;
                  //   },
                  // ),
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
                      updateInfo();
                    }
                  },
                  child: const Text('更新信息')))
        ]),
      )),
    );
  }
}
