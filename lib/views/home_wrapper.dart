import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/views/home.dart';
import 'package:pearmeta_fapp/views/market2.dart';
import 'package:pearmeta_fapp/views/user_arts.dart';
import 'package:pearmeta_fapp/views/user_zone.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key, required this.title}) : super(key: key);

  static const String routeName = '/';
  final String title;

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;

  final pageController = PageController();

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _routes = const <Widget>[
    Home(),
    Market(),
    UserArts(),
    UserZone(),
  ];

  final colorizeColors = [
    Colors.black,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: _selectedIndex == 0
          ? AppBar(
              title: SizedBox(
                width: 250,
                child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        widget.title,
                        textStyle: GoogleFonts.kalam(
                            fontWeight: FontWeight.w700, fontSize: 20),
                        colors: colorizeColors,
                      ),
                    ],
                    repeatForever: true,
                    pause: const Duration(microseconds: 300)),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _routes,
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
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
              label: '寄售',
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
          selectedItemColor: xPrimaryColor,
          unselectedItemColor: Colors.black38),
    );
  }
}
