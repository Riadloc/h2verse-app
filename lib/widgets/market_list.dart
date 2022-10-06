import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/market_item_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
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

  int pageNo = 1;
  bool noMore = false;
  int sortKey = FilterItemKeysEnum.SORT_NEW.index;
  final int pageSize = 12;
  final double padding = 12.0;

  List<dynamic> artList = [];
  void getList() {
    if (!noMore) {
      ArtService.getMarketArts(
              pageNo: pageNo,
              type: widget.type,
              query: widget.query,
              sortKey: sortKey)
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
  }

  bool get initLoading => pageNo == 1 && !noMore && artList.isEmpty;

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (initLoading) {
      return MarketSkeleton(padding: padding);
    }
    double itemWidth = (MediaQuery.of(context).size.width - padding * 3) / 2;
    double childAspectRatio = itemWidth / (itemWidth + 70);
    return EasyRefresh(
      onRefresh: () async {
        onRefresh();
      },
      onLoad: () async {
        getList();
      },
      child: artList.isNotEmpty
          ? GridView.builder(
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
            )
          : ListView(
              children: const [EmptyPlaceholder()],
            ),
    );
  }
}

class MarketSmallCard extends StatelessWidget {
  const MarketSmallCard({Key? key, required this.artData, this.onTap})
      : super(key: key);

  final MarketItem artData;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: kCardBoxShadow,
        ),
        child: InkWell(
          onTap: onTap,
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
              child: Stack(
                children: [
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artData.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.5),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '￥${artData.price != 0 ? artData.price : artData.originPrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        )
                      ]),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ClipOval(
                      child: Container(
                        color: Colors.grey.shade900,
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
