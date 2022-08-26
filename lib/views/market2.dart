import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/views/search_screen.dart';
import 'package:pearmeta_fapp/widgets/filter_sheet.dart';
import 'package:pearmeta_fapp/widgets/market_list.dart';

enum FilterKeys { latest, lowPrice, highPrice }

class Market extends StatefulWidget {
  const Market({Key? key}) : super(key: key);

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;

  final List<Widget> _tabs = const <Widget>[
    Tab(text: '首发'),
    Tab(text: '寄售'),
    Tab(text: '盲盒'),
  ];

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
                                Get.bottomSheet(const FilterSheet());
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
            children: _tabs
                .asMap()
                .entries
                .map((e) => MarketList(type: e.key))
                .toList(),
          ),
        );
      }),
    );
  }
}
