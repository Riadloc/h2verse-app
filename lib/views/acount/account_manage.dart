import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/acount/bankcard_list.dart';
import 'package:h2verse_app/views/acount/trade_password_form.dart';
import 'package:h2verse_app/views/user/user_address.dart';

class AccountManage extends StatelessWidget {
  const AccountManage({Key? key}) : super(key: key);

  static const routeName = '/accountManage';

  @override
  Widget build(BuildContext context) {
    double itemWidth = (getDimensions().width - 47) / 2;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('账户管理'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 15,
          runSpacing: 12,
          children: [
            // AccountCard(
            //   icon: 'assets/images/locker-front-gradient.webp',
            //   width: itemWidth,
            //   title: '账户钱包',
            // ),
            AccountCard(
              icon: 'assets/images/wallet-front-gradient.webp',
              width: itemWidth,
              title: '银行卡管理',
              onTap: () {
                Get.toNamed(BankCardManage.routeName);
              },
            ),
            AccountCard(
              icon: 'assets/images/lock-front-gradient.webp',
              width: itemWidth,
              title: '交易密码',
              onTap: () async {
                Get.toNamed(TradePasswordForm.routeName);
              },
            ),
            // AccountCard(
            //   icon: 'assets/images/lock-front-gradient.webp',
            //   width: itemWidth,
            //   title: '提现密码',
            // ),
            AccountCard(
              icon: 'assets/images/map-pin-front-gradient.webp',
              width: itemWidth,
              title: '地址管理',
              onTap: () {
                Get.toNamed(UserAddress.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard(
      {Key? key,
      required this.width,
      required this.icon,
      required this.title,
      this.onTap})
      : super(key: key);

  final double width;
  final String icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: kCardBoxShadow,
      ),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Image.asset(
                icon,
                height: 120,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
