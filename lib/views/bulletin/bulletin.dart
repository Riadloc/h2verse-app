import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/models/bulletin_model.dart';
import 'package:h2verse_app/services/common_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/webview/my_webview.dart';

class BulletinList extends StatefulWidget {
  const BulletinList({super.key});

  static String routeName = '/bulletinList';

  @override
  State<BulletinList> createState() => _BulletinListState();
}

class _BulletinListState extends State<BulletinList> {
  int pageNo = 1;
  bool noMore = false;
  List<Bulletin> bulletins = [];
  final int pageSize = 12;
  final double padding = 12.0;

  bool get initLoading => pageNo == 1 && !noMore && bulletins.isEmpty;

  void getList() {
    if (!noMore) {
      CommonService.getBulletins(pageNo: pageNo, pageSize: pageSize)
          .then((value) => {
                setState(() {
                  List<Bulletin> data = value;
                  bulletins.addAll(data);
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
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text('平台公告'),
      ),
      body: EasyRefresh(
          onRefresh: () async {
            setState(() {
              pageNo = 1;
              noMore = false;
              bulletins.clear();
              getList();
            });
          },
          onLoad: () async {
            getList();
          },
          child: ListView.separated(
            itemCount: bulletins.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 10,
              endIndent: 10,
            ),
            itemBuilder: (context, index) {
              var item = bulletins[index];
              return Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(MyWebview.routeName,
                        arguments: {'title': item.name, 'url': item.url});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          // width: 120,
                          margin: const EdgeInsets.only(left: 12),
                          child: Text(
                            formartDate(item.createdAt),
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
