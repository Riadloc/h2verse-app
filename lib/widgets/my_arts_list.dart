import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/models/art.model.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/widgets/empty_placeholder.dart';
import 'package:pearmeta_fapp/widgets/my_arts_sheet.dart';

class MyArtsList extends StatefulWidget {
  const MyArtsList({Key? key, required this.type}) : super(key: key);
  final int type;

  @override
  State<MyArtsList> createState() => _MyArtsListState();
}

class _MyArtsListState extends State<MyArtsList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int pageNo = 1;
  final int pageSize = 12;
  bool noMore = false;
  List<dynamic> artList = [];

  void getList() {
    if (!noMore) {
      artService.getMyArts(pageNo: pageNo, type: widget.type).then((value) => {
            setState(() {
              List<Art> data = value.list;
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
    double itemWidth = (MediaQuery.of(context).size.width - 60) / 2;
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
          artList.isNotEmpty
              ? Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: artList
                      .map(
                        (e) => MyArtSmallCard(
                          artData: e,
                          vw: itemWidth,
                        ),
                      )
                      .toList(),
                )
              : const EmptyPlaceholder(),
        ],
      ),
    );
  }
}

class MyArtSmallCard extends StatelessWidget {
  const MyArtSmallCard({Key? key, required this.artData, required this.vw})
      : super(key: key);

  final Art artData;
  final double vw;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: vw,
      child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          child: InkWell(
            onTap: () => {
              Get.bottomSheet(
                  MyArtsSheet(
                    goodId: artData.id,
                  ),
                  isScrollControlled: true)
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        artData.cover,
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: BlurChip(
                        text: '${artData.count} 个',
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  artData.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              )
            ]),
          )),
    );
  }
}

class BlurChip extends StatelessWidget {
  const BlurChip({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          alignment: Alignment.center,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
