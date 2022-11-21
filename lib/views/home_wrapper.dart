import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/views/home.dart';
import 'package:h2verse_app/views/planets/planets.dart';
import 'package:h2verse_app/views/user_arts.dart';
import 'package:h2verse_app/views/user_zone.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;
  final pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
      _selectedIndex = index;
    });
  }

  void setInviteCode() {
    if (kIsWeb) {
      Uri uri = Uri.base;
      var query = uri.queryParameters;
      if (query['code'] != null && query['code'] != '') {
        var box = Hive.box(LocalDB.BOX);
        var user = Provider.of<UserProvider>(context, listen: false).user;
        if (user.id.isEmpty) {
          // 如果用户已经登录则删除邀请码
          box.delete(LocalDB.INVITE_CODE);
        } else {
          box.put(LocalDB.INVITE_CODE, query['code']);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setInviteCode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var params = Get.arguments;
      if (params?['tab'] != null) {
        _onItemTapped(params['tab'][0]);
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> routes = <Widget>[
      Home(changeTab: _onItemTapped),
      const Planets(),
      const UserArts(),
      UserZone(changeTab: _onItemTapped),
    ];
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: routes,
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(240, 242, 240, 1),
          selectedFontSize: 12,
          showUnselectedLabels: false,
          // showSelectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: '探索',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.catching_pokemon_outlined),
              activeIcon: Icon(Icons.catching_pokemon),
              label: '藏品',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face_outlined),
              activeIcon: Icon(Icons.face),
              label: '我的',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black38),
    );
  }
}
