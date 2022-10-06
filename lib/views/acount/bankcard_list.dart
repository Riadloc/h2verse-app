import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/bank_card_model.dart';
import 'package:h2verse_app/services/wallet_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/acount/bankcard_bind_form.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
import 'package:h2verse_app/widgets/modal.dart';

class BankCardManage extends StatefulWidget {
  const BankCardManage({Key? key}) : super(key: key);

  static const routeName = '/bankCardList';

  @override
  State<BankCardManage> createState() => _BankCardManageState();
}

class _BankCardManageState extends State<BankCardManage> {
  List<BankCard> bankCardList = [];

  Future<void> getBankList() async {
    var res = await WalletService.getBankList();
    setState(() {
      bankCardList = res;
    });
  }

  Future<void> getBankInfo(String bankNo) async {
    var res = await WalletService.getBankInfo(bankNo);
    return res;
  }

  @override
  void initState() {
    super.initState();
    getBankList();
  }

  String getBankImageLink(String? code) {
    if (code == null) {
      return '';
    }
    return 'https://yangfubing.gitee.io/bank.logo/resource/logo/$code.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('银行卡管理'),
        actions: [
          TextButton(
              onPressed: () {
                Get.toNamed(BankCardBindForm.routeName);
              },
              child: const Text(
                '绑定银行卡',
                style: TextStyle(fontSize: 15),
              )),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Builder(
        builder: (_context) {
          if (bankCardList.isEmpty) {
            return ListView(children: const [
              EmptyPlaceholder(
                title: '还未绑定银行卡',
              )
            ]);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: bankCardList.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 12,
            ),
            itemBuilder: ((context, index) {
              BankCard bankCard = bankCardList[index];
              String image = getBankImageLink(bankCard.bankCode);
              return Ink(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: kCardBoxShadow,
                  ),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Get.bottomSheet(Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    Get.back(canPop: false);
                                    Get.dialog(
                                      Modal(
                                        title: '确认解绑该银行卡？',
                                        onConfirm: () {
                                          Get.back(canPop: false);
                                        },
                                        onCancel: () {
                                          Get.back(canPop: false);
                                        },
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap),
                                  child: const Text('解 绑'),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap),
                                  child: const Text('查 看'),
                                ),
                              ),
                            ],
                          ),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CachedImage(
                              image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bankCard.bankName ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  formatBankNo(bankCard.bankNo),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      )));
            }),
          );
        },
      ),
    );
  }
}
