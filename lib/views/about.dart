import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/views/my_webview.dart';
import 'package:h2verse_app/widgets/tap_tile.dart';

class About extends StatefulWidget {
  const About({super.key});

  static const routeName = '/about';

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('关于'),
      ),
      body: ListView(
        children: [
          TapTile(
            icon: Icons.public_outlined,
            title: '关于氢宇宙',
            onTap: () {
              Get.toNamed(MyWebview.routeName, arguments: {
                'title': '关于氢宇宙',
                'url': 'https://h5.h2verse.art/agreement/platform'
              });
            },
          ),
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          TapTile(
            icon: Icons.account_box_outlined,
            title: '用户协议',
            onTap: () {
              Get.toNamed(MyWebview.routeName, arguments: {
                'title': '用户协议',
                'url': 'https://h5.h2verse.art/agreement/user'
              });
            },
          ),
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          TapTile(
            icon: Icons.privacy_tip_outlined,
            title: '隐私协议',
            onTap: () {
              Get.toNamed(MyWebview.routeName, arguments: {
                'title': '隐私协议',
                'url': 'https://h5.h2verse.art/agreement/privacy'
              });
            },
          ),
        ],
      ),
    );
  }
}
