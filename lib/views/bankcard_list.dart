import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/constants/utils.dart';
import 'package:pearmeta_fapp/models/bank_card.model.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/widgets/cached_image.dart';

class BankCardManage extends StatefulWidget {
  const BankCardManage({Key? key}) : super(key: key);

  static const routeName = '/bankCardList';

  @override
  State<BankCardManage> createState() => _BankCardManageState();
}

class _BankCardManageState extends State<BankCardManage> {
  List<BankCard> bankCardList = [];

  Future<void> getBankList() async {
    var res = await artService.getBankList();
    setState(() {
      bankCardList = res;
    });
  }

  @override
  void initState() {
    super.initState();
    getBankList();
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
                //
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
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: bankCardList.length,
        itemBuilder: ((context, index) {
          BankCard bankCard = bankCardList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: kCardBoxShadow,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    const CachedImage(
                      'https://yangfubing.gitee.io/bank.logo/resource/logo/ABC.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bankCard.bankName ?? '农业银行',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          formatBankNo(bankCard.bankNo),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      constraints:
                          const BoxConstraints(maxHeight: 40, maxWidth: 40),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz)),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
