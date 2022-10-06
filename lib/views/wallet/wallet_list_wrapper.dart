import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/views/wallet/wallet_list.dart';

class WalletListWrapper extends StatefulWidget {
  const WalletListWrapper({Key? key}) : super(key: key);

  static const routeName = '/walletList';

  @override
  State<WalletListWrapper> createState() => _WalletListWrapperState();
}

class _WalletListWrapperState extends State<WalletListWrapper> {
  final List<Widget> _tabs = const [
    Tab(text: '全部'),
    Tab(text: '交易'),
    Tab(text: '充值'),
    Tab(text: '提现'),
    Tab(text: '其他'),
  ];

  final tabRefTypes = [4, 0, 1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: _tabs.length,
        child: Scaffold(
            body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                const SliverAppBar(
                  pinned: false,
                  floating: false,
                  snap: false,
                  title: Text('我的账户记录'),
                  backgroundColor: Colors.white,
                ),
              ];
            },
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    // labelColor: Colors.white,
                    indicatorColor: xPrimaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: _tabs,
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  children: [
                    for (int i = 0; i < _tabs.length; i++)
                      WalletList(type: tabRefTypes[i])
                  ],
                ))
              ],
            ),
          ),
        )));
  }
}
