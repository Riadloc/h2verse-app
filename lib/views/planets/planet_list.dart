import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/planet_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/event_bus.dart';
import 'package:h2verse_app/utils/events.dart';
import 'package:h2verse_app/views/user/user_show.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
import 'package:h2verse_app/widgets/market_skeleton.dart';

class PlanetList extends StatefulWidget {
  const PlanetList({Key? key}) : super(key: key);

  @override
  State<PlanetList> createState() => _PlanetListState();
}

class _PlanetListState extends State<PlanetList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int pageNo = 1;
  bool noMore = false;
  List<Planet> planetList = [];
  final int pageSize = 12;
  final double padding = 12.0;

  bool get initLoading => pageNo == 1 && !noMore && planetList.isEmpty;

  void getList() {
    if (!noMore) {
      ArtService.getPlanets(pageNo: pageNo).then((value) => {
            setState(() {
              List<Planet> data = value;
              planetList.addAll(data);
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
      planetList.clear();
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
    return EasyRefresh(
        onRefresh: refresh,
        onLoad: getList,
        noMoreLoad: noMore,
        child: planetList.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: planetList.length,
                separatorBuilder: (BuildContext itemContext, int index) =>
                    const SizedBox(
                  height: 20,
                ),
                itemBuilder: (context, index) {
                  var data = planetList[index];
                  return PlanetCard(data: data);
                },
              )
            : ListView(
                children: const [EmptyPlaceholder()],
              ));
  }
}

class PlanetCard extends StatelessWidget {
  const PlanetCard({Key? key, required this.data}) : super(key: key);

  final Planet data;
  final double raduis = 6;

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(raduis),
            boxShadow: kCardBoxShadow),
        child: InkWell(
          borderRadius: BorderRadius.circular(raduis),
          onTap: () {
            Get.toNamed(UserShow.routeName, arguments: {"uid": data.id});
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(raduis),
                      child: AspectRatio(
                          aspectRatio: 2,
                          child: Image.network(
                            data.background,
                            fit: BoxFit.cover,
                          )),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(raduis),
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color.fromRGBO(0, 0, 0, 0.6)
                              ],
                              stops: [
                                0,
                                1
                              ]),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            decoration: const ShapeDecoration(
                                // color: Colors.lightBlue,
                                shape: CircleBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 4))),
                            child: Container(
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: CircleBorder(),
                                ),
                                child: ClipOval(
                                  child: CachedImage(
                                    data.avatar,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                        ))
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 26, bottom: 10),
              alignment: Alignment.center,
              child: Text(
                data.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          ]),
        ));
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
