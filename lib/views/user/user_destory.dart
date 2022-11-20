import 'package:flutter/material.dart';

class UserDestory extends StatefulWidget {
  const UserDestory({super.key});

  static const routeName = '/userDestory';

  @override
  State<UserDestory> createState() => _UserDestoryState();
}

class _UserDestoryState extends State<UserDestory> {
  bool isChecked = false;

  void onSubmit() {
    //
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: const Text('账号注销'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '请仔细检查以下事项，账号注销后无法恢复，请谨慎操作',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 20,
            ),
            // Text(
            //   '1. 请将各类钱包中的余额提出至个人银行卡，如果账号注销，余额将无法提出。',
            //   style: textTheme.bodyLarge,
            // ),
            // const SizedBox(
            //   height: 12,
            // ),
            Text(
              '1. 如果个人账号中持有任意藏品，均无法注销，如有无法寄售的藏品，请联系客服人员处理。',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              '2. 注销后，此账号中的订单记录无法找回，昵称、头像、区块链地址等个人信息均会删除。',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              '3. 注销后，用此账号注册的手机号将无法登陆。如果用原手机号重新注册，无法参与拉新等和新用户相关的活动。',
              style: textTheme.bodyLarge,
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    const Flexible(
                        child: Text('我已阅读并知晓以上信息，并执行注销账户操作，并愿意承担注销账户所带来的一切后果')),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 1,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontSize: 16),
                                foregroundColor: Colors.white),
                            onPressed: isChecked ? onSubmit : null,
                            child: const Text('确认注销')))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
