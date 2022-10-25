import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';

import 'package:h2verse_app/models/user_short_info_model.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/views/user/widgets/user_show_list.dart';

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
    Tab(text: '资讯'),
  ];
  UserShortInfo? user;

  void getUserInfo() {
    UserService.getShortInfo(id: params['uid']).then((value) {
      setState(() {
        user = value;
      });
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
      if (offset > 300) {
        alpha = 255;
      } else if (offset <= 0) {
        alpha = 0;
      } else {
        alpha = offset * 255 ~/ 300;
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
    if (user == null) {
      return Container();
    }
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
                title: Text(user!.nickname,
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
                      child: Column(
                        children: [
                          Text(
                            user!.nickname,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              user!.intro,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: kCardBoxShadow,
                        color: Colors.white,
                      ),
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
