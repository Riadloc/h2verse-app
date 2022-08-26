import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/views/topup_store.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  static const routeName = '/wallet';

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('我的梨账户'),
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
                          primary: Colors.lightGreen.shade50,
                          onPrimary: Colors.lightGreen),
                      icon: const Icon(Icons.diamond_outlined),
                      label: const Text('充值'))),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        //
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          primary: Colors.lightGreen.shade50,
                          onPrimary: Colors.lightGreen),
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
                const Text(
                  '最近5条记录',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextButton(
                    onPressed: () {
                      //
                    },
                    child: Text(
                      '查看全部',
                      style: TextStyle(color: Colors.grey.shade700),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
