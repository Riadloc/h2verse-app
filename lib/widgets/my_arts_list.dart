import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/event_bus.dart';
import 'package:h2verse_app/utils/events.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
import 'package:h2verse_app/widgets/market_skeleton.dart';
import 'package:h2verse_app/widgets/my_arts_sheet.dart';

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
  bool noMore = false;
  List<dynamic> artList = [];
  final int pageSize = 12;
  final double padding = 12.0;

  bool get initLoading => pageNo == 1 && !noMore && artList.isEmpty;

  void getList() {
    if (!noMore) {
      ArtService.getMyArts(pageNo: pageNo, type: widget.type).then((value) => {
            setState(() {
              List<Art> data = value;
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

  void refresh() {
    setState(() {
      pageNo = 1;
      noMore = false;
      artList.clear();
      getList();
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
    eventBus.on<RefreshEvent>().listen((event) {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (initLoading) {
      return MarketSkeleton(padding: padding);
    }
    double itemWidth = (getDimensions().width - padding * 3) / 2;
    double childAspectRatio = itemWidth / (itemWidth + 50);
    return EasyRefresh(
        onRefresh: refresh,
        onLoad: getList,
        child: artList.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.all(padding),
                itemCount: artList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: padding,
                    crossAxisSpacing: padding,
                    childAspectRatio: childAspectRatio),
                itemBuilder: (context, index) {
                  return MyArtSmallCard(
                    artData: artList[index],
                    vw: itemWidth,
                  );
                },
              )
            : ListView(
                children: const [EmptyPlaceholder()],
              ));
  }
}

class MyArtSmallCard extends StatelessWidget {
  const MyArtSmallCard({Key? key, required this.artData, required this.vw})
      : super(key: key);

  final Art artData;
  final double vw;
  final double raduis = 6;

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: vw,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(raduis),
          boxShadow: kCardBoxShadow),
      child: Card(
          elevation: 0,
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
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(raduis),
                      topRight: Radius.circular(raduis),
                    ),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          artData.cover,
                          fit: BoxFit.cover,
                        )),
                  ),
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, height: 1.5),
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
          color: Colors.white.withOpacity(0.5),
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
