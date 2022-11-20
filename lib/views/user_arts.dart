import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/views/record/boxopen_records.dart';
import 'package:h2verse_app/widgets/my_arts_list.dart';

class UserArts extends StatefulWidget {
  const UserArts({Key? key}) : super(key: key);

  static const routeName = '/userArts';

  @override
  State<UserArts> createState() => _UserArtsState();
}

class _UserArtsState extends State<UserArts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;

  final List<Widget> _tabs = const <Widget>[
    Tab(text: '藏品'),
    Tab(text: '盲盒'),
    // Tab(text: '寄售中'),
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
              backgroundColor: Colors.white,
              title: const Text('我的藏品'),
              toolbarHeight: 40,
              actions: [
                _currentIndex == 1
                    ? TextButton(
                        onPressed: () {
                          Get.toNamed(BoxOpenRecords.routeName);
                        },
                        child: const Text(
                          '开盒记录',
                          style: TextStyle(fontSize: 15),
                        ))
                    : Container(),
                const SizedBox(
                  width: 8,
                ),
              ],
              bottom: TabBar(
                // labelColor: Colors.white,
                indicatorColor: xPrimaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: _tabs,
              ),
            ),
            body: TabBarView(
              children: _tabs
                  .asMap()
                  .entries
                  .map((e) => MyArtsList(type: e.key))
                  .toList(),
            ),
          );
        }));
  }
}
