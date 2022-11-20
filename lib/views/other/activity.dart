import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/activity_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';
import 'package:h2verse_app/views/home_wrapper.dart';
import 'package:h2verse_app/views/signup.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  static const routeName = '/activity';

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Map<String, dynamic> actConfig = {};
  bool isWx = false;
  bool checked = false;

  void goHome() {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    if (user.id.isNotEmpty) {
      var box = Hive.box(LocalDB.BOX);
      box.delete(LocalDB.ACT);
      if (actConfig['goodId'] != null) {
        Get.offAllNamed(ArtDetail.routeName, arguments: {
          'goodId': actConfig['goodId'],
          'artType': ArtType.main,
        });
      } else {
        Get.offNamed(HomeWrapper.routeName);
      }
    } else {
      Get.offNamed(Signup.routeName);
    }
  }

  void getActivityConfig() async {
    var config = await ActivityService.getActivityConfig(Uri.base.path);
    if (config != null) {
      actConfig = config;
      var box = Hive.box(LocalDB.BOX);
      box.put(LocalDB.ACT, json.encode(config));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getActivityConfig();
      bool _isWx = await isWeixin();
      setState(() {
        checked = true;
        isWx = _isWx;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text('CYBER SOCCER PLAYER 数字盲盒首发'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        toolbarHeight: 40,
        backgroundColor: const Color.fromRGBO(71, 178, 96, 1),
        leadingWidth: 0,
        automaticallyImplyLeading: false,
      ),
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  const CachedImage(
                    'https://h2verse-1313597710.cos.ap-shanghai.myqcloud.com/uday_poster_1.jpg?imageMogr2/format/webp',
                  ),
                  if (!isWx && checked) ...[
                    const CachedImage(
                      'https://h2verse-1313597710.cos.ap-shanghai.myqcloud.com/uday_poster_2.jpg?imageMogr2/format/webp',
                    ),
                    const CachedImage(
                      'https://h2verse-1313597710.cos.ap-shanghai.myqcloud.com/uday_poster_3.jpg?imageMogr2/format/webp',
                    ),
                  ]
                ],
              ),
              isWx
                  ? Positioned.fill(
                      child: Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12, top: 12),
                        child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text('点击右上角 . . .'),
                                SizedBox(
                                  height: 6,
                                ),
                                Text('选择在浏览器中打开'),
                                SizedBox(
                                  height: 6,
                                ),
                                Text('即可参与活动'),
                              ],
                            )),
                      ),
                    ))
                  : Positioned(
                      bottom: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              backgroundColor: Colors.greenAccent,
                              // foregroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: goHome,
                          child: const Text('立即购买')))
            ],
          )),
    );
  }
}
