import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/enum.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/models/marketList.model.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/views/art_detail.dart';
import 'package:pearmeta_fapp/widgets/empty_placeholder.dart';

class MarketList extends StatefulWidget {
  const MarketList({Key? key, required this.type}) : super(key: key);
  final int type;

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int pageNo = 1;
  final int pageSize = 12;
  bool noMore = false;

  List<dynamic> artList = [];
  void getList() {
    if (!noMore) {
      artService
          .getMarketArts(pageNo: pageNo, type: widget.type)
          .then((value) => {
                setState(() {
                  List<MarketItem> data = value.data;
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
      'goodNo': ele.goodNo,
      'artType': widget.type == 0 ? ArtType.main : ArtType.second,
      'cover': ele.cover,
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double itemWidth = (MediaQuery.of(context).size.width - 55) / 2;
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
                  spacing: 15,
                  children: artList
                      .map(
                        (e) => MarketSmallCard(
                          artData: e,
                          vw: itemWidth,
                          onTap: () => goDetail(e),
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

class MarketSmallCard extends StatelessWidget {
  const MarketSmallCard(
      {Key? key, required this.artData, required this.vw, this.onTap})
      : super(key: key);

  final MarketItem artData;
  final double vw;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: vw,
      child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: kCardBoxShadow,
          ),
          child: InkWell(
            onTap: onTap,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    artData.cover,
                    fit: BoxFit.cover,
                  )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Column(
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
                    )
                  ],
                ),
              )
            ]),
          )),
    );
  }
}
