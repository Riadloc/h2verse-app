import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/widgets/my_arts_list.dart';

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
  final List<Widget> _tabs = const <Widget>[
    Tab(text: '藏品'),
    Tab(text: '盲盒'),
    Tab(text: '权益卡'),
    Tab(text: '已发布'),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String _currentRoute = Get.currentRoute;
    bool showTitle = _currentRoute != '/';
    return DefaultTabController(
      initialIndex: 0,
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: showTitle,
          backgroundColor: Colors.white,
          toolbarHeight: showTitle ? 40 : 0,
          title: showTitle ? const Text('我的藏品') : null,
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
      ),
    );
  }
}
