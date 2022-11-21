import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/order_relation.dart';
import 'package:h2verse_app/services/order_service.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/views/order/my_order_list.dart';
import 'package:h2verse_app/widgets/modal.dart';

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
  ];

  void getMyPurchased(String orderNo) async {
    OrderRelation? value =
        await OrderService.getDetailRelatedGoods(orderNo: orderNo);
    if (value != null) {
      if (value.status == PayOrderStatus.SUCCESSED) {
        Get.dialog(Modal(
          title: '购买成功',
          description: '立即前往查看？',
          confirmText: '查看',
          cancelText: '留在当前页',
          onConfirm: () {
            // 跳转到我的藏品页
            Get.offAllNamed(HomeWrapper.routeName, arguments: {
              "tab": [2, value.type == 2 ? 1 : 0]
            });
          },
          onCancel: () {
            Get.back();
          },
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Uri uri = Uri.base;
      var query = uri.queryParameters;
      if (query['out_trade_no'] != null) {
        getMyPurchased(query['out_trade_no']!);
      }
    });
  }

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
                SliverAppBar(
                  pinned: false,
                  floating: false,
                  snap: false,
                  title: const Text('我的订单'),
                  backgroundColor: Colors.white,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Get.offNamed(HomeWrapper.routeName);
                        },
                        icon: const Icon(Icons.home_filled))
                  ],
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
