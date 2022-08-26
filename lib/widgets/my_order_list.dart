import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/models/orderList.model.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/widgets/cached_image.dart';
import 'package:pearmeta_fapp/widgets/empty_placeholder.dart';

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

  void getList() {
    if (!noMore) {
      artService.getOrders(pageNo: pageNo, type: widget.type).then((value) => {
            setState(() {
              List<Order> data = value.list;
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
    getList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
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
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: artList.isNotEmpty
            ? artList
                .map((e) => Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: kCardBoxShadow),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: InkWell(
                          onTap: () => null,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            style: const TextStyle(
                                                color: xPrimaryColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('@${e.seller}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade800,
                                              )),
                                          const Spacer(),
                                          Text('2022-08-31 19:00',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade800,
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
                      ),
                    ))
                .toList()
            : [const EmptyPlaceholder()],
      ),
    );
  }
}
