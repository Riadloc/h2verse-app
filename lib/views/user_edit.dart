import 'package:flutter/material.dart';
import 'package:pearmeta_fapp/widgets/login_input.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({Key? key}) : super(key: key);

  static const routeName = '/userEdit';

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final _formKey = GlobalKey<FormState>();

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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入邮箱';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LoginInput(
                    hintText: '邮箱',
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入邮箱';
                      }
                      return null;
                    },
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
                      child: const Text('更新信息')))
            ]),
          )),
    );
  }
}
