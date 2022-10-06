import 'package:flutter/material.dart';
import 'package:h2verse_app/views/home.dart';
import 'package:h2verse_app/views/market.dart';
import 'package:h2verse_app/views/user_arts.dart';
import 'package:h2verse_app/views/user_zone.dart';
import 'package:h2verse_app/widgets/animated_index_stack.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> routes = <Widget>[
      Home(changeTab: _onItemTapped),
      const Market(),
      const UserArts(),
      UserZone(changeTab: _onItemTapped),
    ];
    return Scaffold(
      body: AnimatedIndexedStack(index: _selectedIndex, children: routes),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(240, 242, 240, 1),
          selectedFontSize: 12,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: '探索',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.token_outlined),
              activeIcon: Icon(Icons.token),
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
