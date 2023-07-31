import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/compose/compose_list.dart';
import 'package:h2verse_app/views/invite_friends.dart';
import 'package:h2verse_app/views/market.dart';
import 'package:h2verse_app/views/other/app_download.dart';
import 'package:h2verse_app/widgets/clippers/cyber_clipper.dart';
import 'package:lottie/lottie.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/views/bulletin/bulletin.dart';
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
  bool lottieLoaded = false;
  final int pageSize = 8;
  final int padding = 12;
  final colorizeColors = [
    Colors.black,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
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

  Widget buildQuickNav() {
    List<Widget> children = [
      ShortCutCard(
        text: '邀请好友',
        icon: Icons.emoji_emotions,
        color: Colors.orange,
        onTap: () {
          Get.toNamed(InviteFriends.routeName);
        },
      ),
      ShortCutCard(
        text: '官方公告',
        icon: Icons.assignment,
        color: Colors.grey,
        onTap: () {
          Get.toNamed(BulletinList.routeName);
        },
      ),
      ShortCutCard(
        text: '流转中心',
        icon: Icons.explore,
        color: Colors.blue,
        onTap: () {
          Get.toNamed(Market.routeName);
        },
      ),
      ShortCutCard(
        text: '合成活动',
        icon: Icons.science,
        color: Colors.green,
        onTap: () {
          Get.toNamed(ComposeList.routeName);
        },
      ),
    ];
    if (kIsWeb) {
      children.add(ShortCutCard(
        text: '下载APP',
        icon: Icons.smart_toy,
        color: Colors.green,
        onTap: () async {
          bool isiOS = await isiOSBrower();
          if (isiOS) {
            Toast.show('iOS应用还在上架审核中，请您耐性等待');
            return;
          }
          Get.toNamed(AppDownload.routeName);
        },
      ));
    }
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Widget buildMoreButton() {
    if (artList.isEmpty) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.grey.shade200,
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
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = getDimensions().width;
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
        refreshOnStart: true,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 0,
            title: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'H2VERSE',
                  style: GoogleFonts.limelight(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.white70),
                ),
                Text(
                  'H2VERSE',
                  style: GoogleFonts.limelight(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            centerTitle: false,
            backgroundColor: Colors.white,
            expandedHeight: 240,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(41, 25, 52, 1),
                  ),
                  child: kIsWeb
                      ? Image.asset(
                          'assets/images/astronaut-in-space.jpg',
                          fit: BoxFit.cover,
                        )
                      : Lottie.asset(
                          'assets/lottie/astronaut-in-space.zip',
                          fit: BoxFit.cover,
                        ),
                  // child: Container(),
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
                  margin: const EdgeInsets.only(top: 0, bottom: 16),
                  child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: buildQuickNav())),
              artList.isNotEmpty
                  ? Column(
                      children: [
                        ArtSmallCard(
                          artData: artList.first,
                          vw: mainItemWidth,
                          radius: 6,
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
                        radius: 6,
                      ),
                    )
                    .toList(),
              ),
              buildMoreButton(),
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
          boxShadow: kCardBoxShadow),
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
              Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 1.0 / 1.0,
                      child: CachedImage(
                        artData.cover,
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                      top: 8,
                      right: 8,
                      child: Badge(
                        artData: artData,
                      ))
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artData.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            height: 1.5),
                      ),
                      Text(
                        '${artData.ownner}',
                        style:
                            TextStyle(color: Colors.grey.shade700, height: 1.5),
                      ),
                      Text(
                        '￥${artData.price}',
                        style: const TextStyle(
                            color: Colors.blue,
                            height: 1.5,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
              )
            ]),
          )),
    );
  }
}

class Badge extends StatelessWidget {
  const Badge({Key? key, required this.artData}) : super(key: key);

  final Art artData;

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    String text = '';
    if (artData.operatorStatus == GoodOperatorStatus.OPEN) {
      icon = Icons.whatshot;
      text = '热卖中';
    } else if (artData.operatorStatus == GoodOperatorStatus.SOLD_OUT) {
      text = '已售罄';
    } else if (artData.operatorStatus == GoodOperatorStatus.WAIT) {
      text = '${formartTimestamp(artData.shelfTime!)} 开售';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, .7),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            )
          ]),
      child: Row(
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              : Container(),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )
        ],
      ),
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
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
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
                size: 40,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
