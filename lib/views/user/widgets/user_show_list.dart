import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
import 'package:h2verse_app/widgets/market_skeleton.dart';

class UserShowList extends StatefulWidget {
  const UserShowList({Key? key, required this.type, required this.uid})
      : super(key: key);
  final int type;
  final String uid;

  @override
  State<UserShowList> createState() => UserShowListState();
}

class UserShowListState extends State<UserShowList>
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
      ArtService.getUserShow(pageNo: pageNo, type: widget.type, uid: widget.uid)
          .then((value) => {
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

  void goDetail(Art ele) {
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
    double itemWidth = (getDimensions().width - padding * 3) / 2;
    double childAspectRatio = itemWidth / (itemWidth + 70);
    return EasyRefresh.builder(
        onRefresh: () async {
          onRefresh();
        },
        onLoad: () async {
          getList();
        },
        header: const MaterialHeader(),
        childBuilder: (context, physics) {
          return CustomScrollView(
            key: PageStorageKey<String>('${widget.type}'),
            physics: physics,
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              artList.isNotEmpty
                  ? SliverPadding(
                      padding: EdgeInsets.all(padding),
                      sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var item = artList[index];
                              return UserShowCard(
                                artData: item,
                                onTap: () => goDetail(item),
                              );
                            },
                            childCount: artList.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: padding,
                                  crossAxisSpacing: padding,
                                  childAspectRatio: childAspectRatio)),
                    )
                  : const SliverToBoxAdapter(
                      child: EmptyPlaceholder(),
                    )
            ],
          );
        });
  }
}

class UserShowCard extends StatelessWidget {
  const UserShowCard({Key? key, required this.artData, this.onTap})
      : super(key: key);

  final Art artData;
  final void Function()? onTap;
  final double raduis = 6;

  @override
  Widget build(BuildContext context) {
    return Ink(
        color: Colors.white,
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
                      '￥${artData.price}',
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
