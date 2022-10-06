import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/compose_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';

class AirdropList extends StatefulWidget {
  const AirdropList({super.key});

  static String routeName = '/airdropList';

  @override
  State<AirdropList> createState() => _AirdropListState();
}

class _AirdropListState extends State<AirdropList> {
  int pageNo = 1;
  bool noMore = false;
  List<ComposeItem> list = [];
  final int pageSize = 12;
  final double padding = 12.0;

  void getList() {
    if (!noMore) {
      //
    }
  }

  @override
  void initState() {
    super.initState();
    // getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('空投奖励'),
          actions: [
            TextButton(
                onPressed: () {
                  //
                },
                child: const Text(
                  '兑换记录',
                  style: TextStyle(fontSize: 15),
                )),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        body: EasyRefresh(
            onRefresh: () async {
              setState(() {
                pageNo = 1;
                noMore = false;
                list.clear();
                getList();
              });
            },
            onLoad: () async {
              getList();
            },
            child: list.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemBuilder: (context, index) {
                      var item = list[index];
                      return Ink(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: kCardBoxShadow),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              // Get.toNamed(ArtDetail.routeName, arguments: {
                              //   'goodNo': artData.goodNo,
                              //   'artType': ArtType.main,
                              //   'cover': artData.cover,
                              // });
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
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '${item.name} 空投',
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
                                    const TextSpan(text: '已兑换: '),
                                    TextSpan(
                                        text: '${item.copies}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    const TextSpan(text: ' | '),
                                    const TextSpan(text: '可兑换: '),
                                    TextSpan(
                                        text: '${item.copies}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ])),
                                ],
                              ),
                            )),
                      );
                    },
                  )
                : ListView(
                    children: const [
                      EmptyPlaceholder(
                        title: '暂无活动',
                      )
                    ],
                  )));
  }
}
