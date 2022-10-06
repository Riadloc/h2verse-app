import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/order_model.dart';
import 'package:h2verse_app/services/order_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/order/order_detail.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';

class MyOrderList extends StatefulWidget {
  const MyOrderList({Key? key, required this.type}) : super(key: key);
  final int type;

  @override
  State<MyOrderList> createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int pageNo = 1;
  final int pageSize = 12;
  bool noMore = false;
  List<Order> artList = [];
  late Color priceColor;

  void getList() {
    if (!noMore) {
      OrderService.getOrders(pageNo: pageNo, type: widget.type)
          .then((value) => {
                setState(() {
                  List<Order> data = value;
                  artList.addAll(data);
                  if (data.length < pageSize) {
                    noMore = true;
                  } else {
                    pageNo += 1;
                  }
                }),
              });
    }
  }

  @override
  void initState() {
    super.initState();
    priceColor = widget.type == 0
        ? Colors.orange
        : widget.type == 1
            ? Colors.green
            : widget.type == 2
                ? Colors.red
                : Colors.blue;
    getList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (artList.isEmpty) {
      return const Center(
        child: EmptyPlaceholder(),
      );
    }
    return EasyRefresh(
      header: const MaterialHeader(),
      onRefresh: () async {
        setState(() {
          pageNo = 1;
          noMore = false;
          artList.clear();
          getList();
        });
      },
      onLoad: () async {
        getList();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: artList.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 8,
        ),
        itemBuilder: (context, index) {
          var e = artList[index];
          return Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: kCardBoxShadow,
              borderRadius: BorderRadius.circular(8),
            ),
            // margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                Get.toNamed(OrderDetail.routeName,
                    arguments: {'orderId': e.id});
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: CachedImage(
                        e.cover,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(left: 12),
                      height: 42,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                e.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                '￥${e.price}',
                                style: TextStyle(color: priceColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('@${e.seller}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  )),
                              const Spacer(),
                              Text(formartDate(e.createdAt),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
