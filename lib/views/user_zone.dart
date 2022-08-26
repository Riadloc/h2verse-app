import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/services/art.service.dart';

import 'package:pearmeta_fapp/models/user.model.dart';
import 'package:pearmeta_fapp/views/identity.dart';
import 'package:pearmeta_fapp/views/invite_friends.dart';
import 'package:pearmeta_fapp/views/orders.dart';
import 'package:pearmeta_fapp/views/setting.dart';
import 'package:pearmeta_fapp/views/user_arts.dart';
import 'package:pearmeta_fapp/views/wallet.dart';
import 'package:pearmeta_fapp/widgets/split_line.dart';
import 'package:pearmeta_fapp/widgets/tap_tile.dart';

class UserZone extends StatefulWidget {
  const UserZone({Key? key}) : super(key: key);

  @override
  State<UserZone> createState() => _UserZoneState();
}

class _UserZoneState extends State<UserZone>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  User user = User.empty();

  void getUserInfo() {
    artService.getUserInfo().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      // color: Colors.white,
      // padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'lib/assets/milad-fakurian.webp',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(Setting.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(40, 40),
                        elevation: 0,
                        primary: const Color.fromRGBO(248, 248, 249, 1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Icon(Icons.settings_outlined)),
                ),
              ),
              Positioned(
                  bottom: -52,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          // padding: const EdgeInsets.all(4),
                          decoration: const ShapeDecoration(
                              // color: Colors.lightBlue,
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.white, width: 8))),
                          child: Container(
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(171, 199, 180, 1),
                                shape: CircleBorder(),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.asset(
                                    'lib/assets/default_avatar.png',
                                    width: 80),
                              )))
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 8),
            child: Column(children: [
              const Text(
                '王泽',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
              Text('UID: 10080',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: kCardBoxShadow),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StaticsColumn(
                    title: '我的订单',
                    value: '888',
                    onTap: () {
                      Get.toNamed(Orders.routeName);
                    },
                  ),
                  const SplitLine(),
                  StaticsColumn(
                    title: '我的藏品',
                    value: '666',
                    onTap: () {
                      Get.toNamed(UserArts.routeName);
                    },
                  ),
                  const SplitLine(),
                  StaticsColumn(
                    title: '我的余额',
                    value: '999',
                    onTap: () {
                      Get.toNamed(Wallet.routeName);
                    },
                  ),
                  const SplitLine(),
                  StaticsColumn(
                    title: '我的交易',
                    value: '888',
                    onTap: () {
                      //
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kCardBoxShadow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  TapTile(
                    icon: Icons.add_reaction_outlined,
                    title: '邀请好友',
                    onTap: () {
                      Get.toNamed(InviteFriends.routeName);
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                    height: 1,
                  ),
                  TapTile(
                    icon: Icons.support_agent_outlined,
                    title: '帮助中心',
                    onTap: () {
                      //
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                    height: 1,
                  ),
                  TapTile(
                    icon: Icons.verified_outlined,
                    title: '前去实名认证',
                    color: Colors.orangeAccent,
                    onTap: () {
                      Get.toNamed(Identity.routeName);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ZoneSmallCard extends StatelessWidget {
  const ZoneSmallCard(
      {Key? key, required this.title, required this.value, required this.onTap})
      : super(key: key);
  final String title;
  final String value;
  final dynamic Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(248, 248, 249, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
      elevation: 0,
      child: InkWell(
        onTap: () => null,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class StaticsColumn extends StatelessWidget {
  const StaticsColumn(
      {Key? key, required this.title, required this.value, required this.onTap})
      : super(key: key);
  final String title;
  final String value;
  final dynamic Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ));
  }
}
