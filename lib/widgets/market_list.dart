import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/album_model.dart';
import 'package:h2verse_app/models/market_item_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
import 'package:h2verse_app/widgets/filter_sheet.dart';
import 'package:h2verse_app/widgets/market_skeleton.dart';

class MarketList extends StatefulWidget {
  const MarketList({Key? key, required this.type, this.query = ''})
      : super(key: key);
  final int type;
  final String query;

  @override
  State<MarketList> createState() => MarketListState();
}

class MarketListState extends State<MarketList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String choice = '0';
  int pageNo = 1;
  bool noMore = false;
  int sortKey = FilterItemKeysEnum.SORT_NEW.index;
  final int pageSize = 12;
  final double padding = 12.0;
  final Map<String, dynamic> options = {};

  List<dynamic> artList = [];
  void getList() {
    if (noMore) {
      return;
    }
    ArtService.getMarketArts(
            pageNo: pageNo,
            type: widget.type,
            query: widget.query,
            sortKey: sortKey,
            albumId: choice)
        .then((value) => {
              setState(() {
                List<MarketItem> data = value;
                artList.addAll(data);
                if (data.length < pageSize) {
                  noMore = true;
                } else {
                  pageNo += 1;
                }
              }),
            });
  }

  List<dynamic> albumList = [];
  void getAlbums() {
    ArtService.getAlbums(pageNo: pageNo).then((value) => {
          setState(() {
            List<Album> data = value;
            data.insert(0, Album(id: '0', cover: '', name: '全部'));
            albumList = data;
          }),
        });
  }

  void goDetail(MarketItem ele) {
    Get.toNamed(ArtDetail.routeName, arguments: {
      'goodId': ele.id,
      'artType': widget.type == 0 ? ArtType.main : ArtType.second,
      'cover': ele.cover,
    });
  }

  void onRefresh({int? key}) {
    if (key != null) {
      sortKey = key;
    }
    setState(() {
      pageNo = 1;
      noMore = false;
    });
    artList.clear();
    getList();
    getAlbums();
  }

  bool get initLoading => pageNo == 1 && !noMore && artList.isEmpty;

  @override
  void initState() {
    super.initState();
    getList();
    getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (initLoading) {
      return MarketSkeleton(padding: padding);
    }
    double itemWidth = (getDimensions().width - padding * 3) / 2;
    double childAspectRatio = itemWidth / (itemWidth + 70);
    return EasyRefresh.builder(
      header: const MaterialHeader(),
      onRefresh: () async {
        onRefresh();
      },
      onLoad: () async {
        getList();
      },
      childBuilder: (context, physics) => artList.isNotEmpty
          ? Column(
              children: [
                Container(
                  height: 34,
                  margin: EdgeInsets.only(top: padding),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              shrinkWrap: true,
                              itemCount: albumList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 4,
                                  ),
                              itemBuilder: (context, index) {
                                Album album = albumList[index];
                                return ChoiceChip(
                                  label: Text(album.name),
                                  pressElevation: 0,
                                  backgroundColor: Colors.grey.shade200,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  selectedColor: Colors.blue.shade100,
                                  selected: choice == album.id,
                                  onSelected: (bool selected) {
                                    if (choice != album.id) {
                                      setState(() {
                                        choice = album.id;
                                      });
                                      onRefresh();
                                    }
                                  },
                                );
                              })),
                      IconButton(
                          padding: EdgeInsets.zero,
                          // constraints:
                          //     const BoxConstraints(maxHeight: 40, maxWidth: 40),
                          onPressed: () {
                            Get.bottomSheet(FilterSheet(
                              sortKey: sortKey,
                              onApply: (Map<String, int> values) {
                                sortKey = values['sortKey']!;
                                onRefresh();
                              },
                              onReset: () {
                                sortKey = FilterItemKeysEnum.SORT_NEW.index;
                                onRefresh();
                              },
                            ));
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: const Icon(Icons.tune))
                    ],
                  ),
                ),
                Expanded(
                    child: GridView.builder(
                  physics: physics,
                  padding: EdgeInsets.all(padding),
                  itemCount: artList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: padding,
                      childAspectRatio: childAspectRatio),
                  itemBuilder: (context, index) {
                    var item = artList[index];
                    return MarketSmallCard(
                      artData: item,
                      onTap: () => goDetail(item),
                    );
                  },
                ))
              ],
            )
          : ListView(
              physics: physics,
              children: [
                EmptyPlaceholder(
                    title: widget.type == 1 ? '对接元枢市场中...' : '没有数据')
              ],
            ),
    );
  }
}

class MarketSmallCard extends StatelessWidget {
  const MarketSmallCard({Key? key, required this.artData, this.onTap})
      : super(key: key);

  final MarketItem artData;
  final void Function()? onTap;
  final double raduis = 6;

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: kCardBoxShadow,
            borderRadius: BorderRadius.circular(raduis)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(raduis),
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
                artData.serial != null
                    ? Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const ShapeDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              shape: StadiumBorder()),
                          child: Text(
                            '#${artData.serial} / ${artData.copies}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Container(
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artData.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '￥${artData.price != 0 ? artData.price : artData.originPrice}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.blue),
                    )
                  ]),
            ),
          ]),
        ));
  }
}
