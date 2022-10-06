import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/views/order/my_order_list.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final List<Widget> _tabs = const [
    Tab(text: '待支付'),
    Tab(text: '已购买'),
    Tab(text: '已取消'),
    Tab(text: '已转出'),
  ];

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
                  title: Text('我的订单'),
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
                    for (int i = 0; i < _tabs.length; i++) MyOrderList(type: i)
                  ],
                ))
              ],
            ),
          ),
        )));
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  StickyTabBarDelegate({required this.child});
  final TabBar child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
