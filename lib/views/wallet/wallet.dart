import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/views/wallet/wallet_record_item.dart';
import 'package:intl/intl.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/models/wallet_record.dart';
import 'package:h2verse_app/services/wallet_service.dart';
import 'package:h2verse_app/views/wallet/drawcash_form.dart';
import 'package:h2verse_app/views/wallet/topup_store.dart';
import 'package:h2verse_app/views/wallet/wallet_list_wrapper.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  static const routeName = '/wallet';

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  List<WalletRecord> records = [];
  final type = WalletRecordType.ALL;
  final int pageNo = 1;
  final int pageSize = 5;
  final recordNameMap = {
    WalletRecordType.APPLY_USER: '开户',
    WalletRecordType.TRADE: '交易',
    WalletRecordType.TOP_UP: '充值',
    WalletRecordType.DRAW_CASH: '提现',
  };
  final statusNameMap = {
    PayOrderStatus.PENDING: '进行中',
    PayOrderStatus.SUCCESSED: '完成',
    PayOrderStatus.FAILED: '关闭',
    PayOrderStatus.DC_APPLYED: '预付成功',
    PayOrderStatus.DC_APPLYED_WAIT: '信息缺失',
    PayOrderStatus.DC_APPLYED_CHECKED: '信息缺失',
    PayOrderStatus.DC_APPLY_FAILED: '预付成功',
    PayOrderStatus.DC_TRANSFERED: '信息缺失',
  };

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  void getRecords() async {
    var res = await WalletService.getRecords(
        type: type, pageNo: pageNo, pageSize: pageSize);
    setState(() {
      records = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('我的氢账户'),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const Text(
                    '1000 RMB',
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    '我的余额',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(TopupStore.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.lightBlue.shade50,
                          foregroundColor: Colors.lightBlue),
                      icon: const Icon(Icons.diamond_outlined),
                      label: const Text('充值'))),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(DrawcashForm.routeName, arguments: 100);
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.lightGreen.shade50,
                          foregroundColor: Colors.lightGreen),
                      icon: const Icon(Icons.add_card_outlined),
                      label: const Text('提现'))),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '最近$pageSize条记录',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () {
                      Get.toNamed(WalletListWrapper.routeName);
                    },
                    child: Text(
                      '查看全部',
                      style: TextStyle(color: Colors.grey.shade700),
                    ))
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
            ),
            itemBuilder: (context, index) {
              var record = records[index];
              return WalletRecordItem(
                record: record,
              );
            },
          )
        ],
      ),
    );
  }
}
