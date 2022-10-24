import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:h2verse_app/models/user_model.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/views/user/widgets/user_show_list.dart';
import 'package:provider/provider.dart';

class UserShow extends StatefulWidget {
  const UserShow({Key? key}) : super(key: key);

  static const routeName = '/userShow';

  @override
  State<UserShow> createState() => _UserShowState();
}

class _UserShowState extends State<UserShow>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final Map params = Get.arguments;
  late TabController _tabController;
  late final ScrollController scrollController;
  int titleAlpha = 0;

  final List<Tab> tabs = const <Tab>[
    Tab(text: '发行'),
    Tab(text: '拥有'),
    Tab(text: '资讯'),
  ];
  User user = User.empty();

  void getUserInfo() {
    UserService.getUserInfo().then((value) {
      setState(() {
        user = value;
      });
      Provider.of<UserProvider>(context, listen: false).user = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _tabController = TabController(vsync: this, length: tabs.length);
    scrollController = ScrollController();
    scrollController.addListener(() {
      var offset = scrollController.offset;
      int alpha = 0;
      if (offset > 350) {
        alpha = 255;
      } else if (offset <= 0) {
        alpha = 0;
      } else {
        alpha = offset * 255 ~/ 350;
      }
      if (alpha != titleAlpha) {
        setState(() {
          titleAlpha = alpha;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text('氢宇宙官方',
                    style:
                        TextStyle(color: Colors.black.withAlpha(titleAlpha))),
                expandedHeight: 350,
                stretch: true,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'lib/assets/milad-fakurian.jpg',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                            bottom: -52,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    // padding: const EdgeInsets.all(4),
                                    decoration: const ShapeDecoration(
                                        // color: Colors.lightBlue,
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                color: Colors.white,
                                                width: 6))),
                                    child: Container(
                                        decoration: const ShapeDecoration(
                                          shape: CircleBorder(),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          child: Image.asset(
                                              'lib/assets/avatar1.jpg',
                                              width: 80),
                                        )))
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(children: [
                        Consumer<UserProvider>(
                            builder: (context, user, child) => Column(
                                  children: [
                                    Text(
                                      user.user.nickname,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        '氢宇宙H2VERSE由来自国内知名区块链研发团队和四川氢元科技有限责任公司共同发起，以H、C、O三元素为核心，致力于构建一个可以让任何玩家参与其中的元宇宙世界。',
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13),
                                      ),
                                    )
                                  ],
                                )),
                      ]),
                    ),
                  ],
                )),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                          controller: _tabController,
                          tabs: tabs,
                          indicatorSize: TabBarIndicatorSize.label),
                    )),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            for (int i = 0; i < tabs.length; i++)
              SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(builder: (BuildContext context) {
                    return UserShowList(
                      type: i,
                      uid: params['uid'],
                    );
                  }))
          ],
        ),
      ),
    );
  }
}
