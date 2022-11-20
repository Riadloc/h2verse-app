import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/views/planets/planet_list.dart';
import 'package:h2verse_app/views/search_screen.dart';
import 'package:h2verse_app/widgets/filter_sheet.dart';
import 'package:h2verse_app/widgets/market_list.dart';

class Planets extends StatefulWidget {
  const Planets({super.key});

  static const routeName = '/plantes';

  @override
  State<Planets> createState() => _PlanetsState();
}

class _PlanetsState extends State<Planets> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int sortKey = 0;

  final List<Widget> _tabs = const <Widget>[
    Tab(text: '藏品'),
    Tab(text: '创作者'),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        initialIndex: 0,
        length: _tabs.length,
        child: Builder(builder: (BuildContext ctx) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                // toolbarHeight: 40,
                leadingWidth: 0,
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      constraints: const BoxConstraints(maxHeight: 40),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: '搜索',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      focusedBorder: kInputBorder,
                      enabledBorder: kInputBorder,
                    ),
                    style: const TextStyle(fontSize: 14),
                    readOnly: true,
                    onTap: () {
                      Get.toNamed(SearchScreen.routeName);
                    },
                  ),
                ),
                // actions: [
                //   IconButton(
                //       // padding: EdgeInsets.zero,
                //       // constraints:
                //       //     const BoxConstraints(maxHeight: 40, maxWidth: 40),
                //       onPressed: () {
                //         Get.bottomSheet(FilterSheet(
                //           sortKey: sortKey,
                //           onApply: (Map<String, int> values) {
                //             // refreshList(values['sortKey']!);
                //           },
                //           onReset: () {
                //             // refreshList(0);
                //           },
                //         ));
                //       },
                //       splashColor: Colors.transparent,
                //       highlightColor: Colors.transparent,
                //       icon: const Icon(Icons.tune))
                // ],
                backgroundColor: Colors.white,
                bottom: TabBar(
                  // labelColor: Colors.white,
                  indicatorColor: xPrimaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: _tabs,
                ),
              ),
              body: const TabBarView(
                children: [MarketList(type: 0), PlanetList()],
              ));
        }));
  }
}
