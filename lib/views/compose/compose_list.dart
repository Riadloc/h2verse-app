import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/compose_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/compose/compose_lab.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';

class ComposeList extends StatefulWidget {
  const ComposeList({super.key});

  static String routeName = '/composeList';

  @override
  State<ComposeList> createState() => _ComposeListState();
}

class _ComposeListState extends State<ComposeList> {
  int pageNo = 1;
  bool noMore = false;
  List<ComposeItem> composeList = [];
  final int pageSize = 12;
  final double padding = 12.0;

  bool get initLoading => pageNo == 1 && !noMore && composeList.isEmpty;

  void getList() {
    if (!noMore) {
      ArtService.getComposeList(pageNo: pageNo, pageSize: pageSize)
          .then((value) => {
                setState(() {
                  List<ComposeItem> data = value;
                  composeList.addAll(data);
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

  Widget buildTag(ComposeItem item) {
    int type = checkDateInRange(range: [item.start, item.end]);
    if (type == 0) {
      return Positioned(
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: const ShapeDecoration(
                color: Colors.blue, shape: StadiumBorder()),
            child: const Text(
              '进行中',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ));
    }
    return Positioned(
        top: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: const ShapeDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              shape: StadiumBorder()),
          child: Text(
            type == -1 ? '还未开始' : '已结束',
            style: const TextStyle(fontSize: 13),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('合成中心'),
        ),
        body: EasyRefresh(
            onRefresh: () async {
              setState(() {
                pageNo = 1;
                noMore = false;
                composeList.clear();
                getList();
              });
            },
            onLoad: () async {
              getList();
            },
            child: composeList.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: composeList.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemBuilder: (context, index) {
                      var item = composeList[index];
                      return Ink(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: kCardBoxShadow),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Get.toNamed(ComposeLab.routeName, arguments: {
                                'id': item.id,
                                'cover': item.cover
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: AspectRatio(
                                          aspectRatio: 1.5,
                                          child: CachedImage(
                                            item.cover,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      buildTag(item)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '${item.name} 合成活动',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text.rich(TextSpan(text: '发行量: ', children: [
                                    TextSpan(
                                        text: '${item.copies}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    const TextSpan(text: ' | '),
                                    const TextSpan(text: '剩余: '),
                                    TextSpan(
                                        text: '${item.copies}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ])),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text.rich(TextSpan(text: '开放时间: ', children: [
                                    TextSpan(
                                      text: formartDate(item.start),
                                    ),
                                    const TextSpan(text: ' 到 '),
                                    TextSpan(
                                      text: formartDate(item.end),
                                    ),
                                  ]))
                                ],
                              ),
                            )),
                      );
                    },
                  )
                : ListView(
                    children: const [
                      EmptyPlaceholder(
                        title: '暂无合成活动',
                      )
                    ],
                  )));
  }
}
