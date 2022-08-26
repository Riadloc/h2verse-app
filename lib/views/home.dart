import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/views/art_detail.dart';
import 'package:pearmeta_fapp/constants/enum.dart';
import 'package:pearmeta_fapp/models/art.model.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/widgets/cached_image.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<dynamic> artList = [];
  int pageNo = 1;
  final int pageSize = 12;
  bool noMore = false;

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() {
    if (!noMore) {
      artService.getArts(pageNo).then((value) => {
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
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: kCardBoxShadow),
            child: Image.asset('lib/assets/banner0810.jpg'),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: kCardBoxShadow),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: const [
                    Icon(
                      Icons.assignment,
                      size: 36,
                    ),
                    Text('官方公告')
                  ],
                ),
                Column(
                  children: const [
                    Icon(
                      Icons.smart_toy,
                      size: 36,
                    ),
                    Text('合成中心')
                  ],
                ),
                Column(
                  children: const [
                    Icon(
                      Icons.local_mall,
                      size: 36,
                    ),
                    Text('梨籽铺')
                  ],
                ),
              ],
            ),
          ),
          artList.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: kCardBoxShadow),
                      child: Card(
                          child: InkWell(
                        onTap: () => {
                          Get.toNamed(ArtDetail.routeName, arguments: {
                            'goodNo': artList.first.goodNo,
                            'artType': ArtType.main,
                            'cover': artList.first.cover,
                          })
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: AspectRatio(
                                    aspectRatio: 1.0 / 1.0,
                                    child: Image.network(
                                      artList.first.cover,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                child: Stack(children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          artList.first.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              height: 1.5),
                                        ),
                                        Text(
                                          artList.first.ownner,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              height: 1.5),
                                        ),
                                        Text(
                                          '${artList.first.price}',
                                          style: const TextStyle(height: 1.5),
                                        )
                                      ]),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.grey.shade900,
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              )
                            ]),
                      )),
                    ),
                  ],
                )
              : Container(),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            children: artList
                .skip(1)
                .map(
                  (e) => ArtSmallCard(
                    artData: e,
                    vw: itemWidth,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

class ArtSmallCard extends StatelessWidget {
  const ArtSmallCard({Key? key, required this.artData, required this.vw})
      : super(key: key);

  final Art artData;
  final double vw;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vw,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: kCardBoxShadow),
      child: Card(
          elevation: 0,
          // margin: const EdgeInsets.only(bottom: 20),
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          child: InkWell(
            onTap: () {
              Get.toNamed(ArtDetail.routeName, arguments: {
                'goodNo': artData.goodNo,
                'artType': ArtType.main,
                'cover': artData.cover,
              });
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Hero(
                  tag: artData.cover,
                  child: AspectRatio(
                      aspectRatio: 1.0 / 1.0,
                      child: CachedImage(
                        artData.cover,
                        fit: BoxFit.cover,
                      ))),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.5),
                          ),
                          Text(
                            '${artData.ownner}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.5),
                          ),
                          Text(
                            '￥${artData.price}',
                            style: const TextStyle(height: 1.5),
                          )
                        ]),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ClipOval(
                        child: Container(
                          color: Colors.grey.shade900,
                          padding: const EdgeInsets.all(4),
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
