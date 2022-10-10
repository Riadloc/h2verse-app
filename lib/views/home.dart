import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/views/fuel/fule_list.dart';
import 'package:lottie/lottie.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/views/bulletin/bulletin.dart';
import 'package:h2verse_app/views/compose/compose_list.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/views/search_screen.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/notice_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.changeTab}) : super(key: key);
  final void Function(int index) changeTab;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<dynamic> artList = [];
  int pageNo = 1;
  bool noMore = false;
  final int pageSize = 8;
  final int padding = 12;
  final List<String> banners = [
    'https://pearmeta-1253493520.file.myqcloud.com/banner0810.jpg',
    'https://pearmeta-1253493520.file.myqcloud.com/banner_0722m.jpg',
  ];
  final colorizeColors = [
    Colors.black,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() {
    if (!noMore && mounted) {
      ArtService.getArts(pageNo).then((value) => {
            if (mounted)
              {
                setState(() {
                  List<Art> data = value;
                  artList.addAll(data);
                  if (data.length < pageSize || pageNo == 1) {
                    noMore = true;
                  }
                }),
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - padding * 3) / 2;
    double mainItemWidth = screenWidth - padding * 2;
    return EasyRefresh(
        header: const MaterialHeader(),
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
        child: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true,
            scrolledUnderElevation: 0,
            title: Text(
              'H2VERSE',
              style: GoogleFonts.kalam(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            expandedHeight: 200,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.toNamed(SearchScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(30, 30),
                      elevation: 0,
                      backgroundColor: const Color.fromRGBO(240, 242, 240, 1),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Icon(
                    Icons.search,
                    size: 22,
                  )),
              const SizedBox(
                width: 12,
              ),
            ],
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                // borderRadius: const BorderRadius.only(
                //   bottomLeft: Radius.circular(20),
                //   bottomRight: Radius.circular(20),
                // ),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: gradientButtonPrimarycolors,
                        stops: [0, 0.49, 1]),
                  ),
                  child: Lottie.asset(
                    'lib/assets/lottie/shaking-head-when-driving-front-view.zip',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: NoticeBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 20),
                  child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ShortCutCard(
                            text: '流转中心',
                            icon: Icons.explore,
                            color: Colors.blue,
                            onTap: () {
                              widget.changeTab(1);
                            },
                          ),
                          // ShortCutCard(
                          //   text: '积分商城',
                          //   icon: Icons.local_mall,
                          //   color: Colors.orange,
                          //   onTap: () {
                          //     Get.toNamed(FuleStore.routeName);
                          //   },
                          // ),
                          // ShortCutCard(
                          //   text: '合成中心',
                          //   icon: Icons.smart_toy,
                          //   color: Colors.green,
                          //   onTap: () {
                          //     Get.toNamed(ComposeList.routeName);
                          //   },
                          // ),
                          ShortCutCard(
                            text: '官方公告',
                            icon: Icons.assignment,
                            color: Colors.orange,
                            onTap: () {
                              Get.toNamed(BulletinList.routeName);
                            },
                          ),
                        ],
                      ))),
              artList.isNotEmpty
                  ? Column(
                      children: [
                        ArtSmallCard(
                          artData: artList.first,
                          vw: mainItemWidth,
                          radius: 12,
                        )
                      ],
                    )
                  : Container(),
              Wrap(
                spacing: 12,
                children: artList
                    .skip(1)
                    .map(
                      (e) => ArtSmallCard(
                        artData: e,
                        vw: itemWidth,
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey.shade300,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: const Size(0, 30),
                      ),
                      onPressed: () {
                        widget.changeTab(1);
                      },
                      child: Row(
                        children: const [
                          Text(
                            '查看更多',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                          )
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 12,
              )
            ])),
          ),
        ]));
  }
}

class ArtSmallCard extends StatelessWidget {
  const ArtSmallCard(
      {Key? key, required this.artData, required this.vw, this.radius = 0})
      : super(key: key);

  final Art artData;
  final double vw;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vw,
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius!),
      ),
      child: Card(
          elevation: 0,
          child: InkWell(
            onTap: () {
              Get.toNamed(ArtDetail.routeName, arguments: {
                'goodId': artData.id,
                'artType': ArtType.main,
                'cover': artData.cover,
              });
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AspectRatio(
                  aspectRatio: 1.0 / 1.0,
                  child: CachedImage(
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
                            style: const TextStyle(
                                height: 1.5, fontWeight: FontWeight.w500),
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

class ShortCutCard extends StatelessWidget {
  const ShortCutCard(
      {Key? key,
      required this.text,
      required this.icon,
      required this.color,
      this.onTap})
      : super(key: key);

  final String text;
  final IconData icon;
  final Color color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(240, 242, 240, 1),
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: -10,
              right: -10,
              child: Icon(
                icon,
                size: 50,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
