import 'package:flutter/material.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/widgets/my_order_list.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final Map<int, String> _tabsMap = {
    0: '待支付',
    1: '已购买',
    2: '已取消',
    3: '待支付',
  };

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs =
        _tabsMap.entries.map((e) => Tab(text: e.value)).toList();
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('我的订单'),
          backgroundColor: Colors.white,
          bottom: TabBar(
            // labelColor: Colors.white,
            indicatorColor: xPrimaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children:
              _tabsMap.entries.map((e) => MyOrderList(type: e.key)).toList(),
        ),
      ),
    );
  }
}
