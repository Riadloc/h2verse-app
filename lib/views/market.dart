import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/views/search_screen.dart';
import 'package:h2verse_app/widgets/filter_sheet.dart';
import 'package:h2verse_app/widgets/market_list.dart';

class Market extends StatefulWidget {
  const Market({Key? key}) : super(key: key);

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;
  int sortKey = 0;
  GlobalKey<MarketListState> listKey = GlobalKey();

  final List<Widget> _tabs = const <Widget>[
    Tab(text: '首发'),
    Tab(text: '寄售'),
    Tab(text: '盲盒'),
  ];

  void refreshList(int key) {
    if (_currentIndex == 1) {
      sortKey = key;
      listKey.currentState!.onRefresh(key: key);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      initialIndex: 0,
      length: _tabs.length,
      child: Builder(builder: (BuildContext ctx) {
        final TabController tabController = DefaultTabController.of(ctx)!;
        tabController.addListener(() {
          if (_currentIndex != tabController.index) {
            setState(() {
              _currentIndex = tabController.index;
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TabBar(
                      // labelColor: Colors.white,
                      indicatorColor: xPrimaryColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: _tabs,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _currentIndex == 1
                          ? IconButton(
                              // padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  maxHeight: 40, maxWidth: 40),
                              onPressed: () {
                                Get.bottomSheet(FilterSheet(
                                  sortKey: sortKey,
                                  onApply: (Map<String, int> values) {
                                    refreshList(values['sortKey']!);
                                  },
                                  onReset: () {
                                    refreshList(0);
                                  },
                                ));
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: const Icon(Icons.tune))
                          : Container(),
                      IconButton(
                          // padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(maxHeight: 40, maxWidth: 40),
                          onPressed: () {
                            Get.toNamed(SearchScreen.routeName);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: const Icon(Icons.search))
                    ],
                  ),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              for (int i = 0; i < _tabs.length; i++)
                MarketList(
                  key: i == 1 ? listKey : null,
                  type: i,
                )
            ],
          ),
        );
      }),
    );
  }
}
