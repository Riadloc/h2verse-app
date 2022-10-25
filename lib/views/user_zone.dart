import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';

import 'package:h2verse_app/models/user_model.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/views/airdrop/airdrop_list.dart';
import 'package:h2verse_app/views/identity.dart';
import 'package:h2verse_app/views/invite_friends.dart';
import 'package:h2verse_app/views/order/orders.dart';
import 'package:h2verse_app/views/setting.dart';
import 'package:h2verse_app/views/user/user_show.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/copy_field.dart';
import 'package:h2verse_app/widgets/split_line.dart';
import 'package:h2verse_app/widgets/tap_tile.dart';
import 'package:provider/provider.dart';

class UserZone extends StatefulWidget {
  const UserZone({Key? key, required this.changeTab}) : super(key: key);
  final void Function(int index) changeTab;

  @override
  State<UserZone> createState() => _UserZoneState();
}

class _UserZoneState extends State<UserZone>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  User user = User.empty();

  void getUserInfo() {
    UserService.getUserInfo().then((value) {
      setState(() {
        user = value;
      });
      Provider.of<UserProvider>(context, listen: false).user = value;
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
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'lib/assets/milad-fakurian.jpg',
                height: 180,
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
                        backgroundColor: const Color.fromRGBO(248, 248, 249, 1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Icon(Icons.settings)),
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
                                      color: Colors.white, width: 6))),
                          child: Container(
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: user.avatar.isNotEmpty
                                    ? CachedImage(
                                        user.avatar,
                                        width: 80,
                                        height: 80,
                                      )
                                    : Image.asset(
                                        'lib/assets/avatar1.jpg',
                                        height: 80,
                                        width: 80,
                                      ),
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
              Consumer<UserProvider>(
                  builder: (context, user, child) => Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                user.user.nickname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 22),
                              ),
                              Consumer<UserProvider>(
                                builder: (context, value, child) {
                                  var user = value.user;
                                  if (user.certified == 0) {
                                    return Container();
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          CopyField(
                            text: 'UID: ${user.user.userId}',
                            copyText: '${user.user.userId}',
                            color: Colors.grey.shade800,
                          )
                        ],
                      )),
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
                child: Consumer<UserProvider>(
                  builder: (context, value, child) {
                    var stats = value.user.stats;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StaticsColumn(
                          title: '我的订单',
                          value: stats.order,
                          onTap: () {
                            Get.toNamed(Orders.routeName);
                          },
                        ),
                        const SplitLine(),
                        StaticsColumn(
                          title: '我的藏品',
                          value: stats.art,
                          onTap: () {
                            widget.changeTab(2);
                          },
                        ),
                        const SplitLine(),
                        StaticsColumn(
                          title: '我的余额',
                          value: stats.balance,
                          onTap: () {
                            //
                          },
                        ),
                        // const SplitLine(),
                        // StaticsColumn(
                        //   title: '我的交易',
                        //   value: stats.trade,
                        //   onTap: () {
                        //     //
                        //   },
                        // ),
                      ],
                    );
                  },
                )),
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
                  TapTile(
                    icon: Icons.airplane_ticket_outlined,
                    title: '空投奖励',
                    onTap: () {
                      Get.toNamed(AirdropList.routeName);
                    },
                  ),
                  // TapTile(
                  //   icon: Icons.group_outlined,
                  //   title: '官方社群',
                  //   onTap: () {
                  //     Get.toNamed(CommunityGroups.routeName);
                  //   },
                  // ),
                  // TapTile(
                  //   icon: Icons.question_answer_outlined,
                  //   title: '常见问题',
                  //   onTap: () {
                  //     //
                  //   },
                  // ),
                  // TapTile(
                  //   icon: Icons.support_agent_outlined,
                  //   title: '联系客服',
                  //   onTap: () {
                  //     Get.toNamed(CustomerService.routeName);
                  //   },
                  // ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      var user = value.user;
                      if (user.certified == 0) {
                        return TapTile(
                          icon: Icons.verified_outlined,
                          title: '前去实名认证',
                          color: Colors.orangeAccent,
                          onTap: () {
                            Get.toNamed(Identity.routeName);
                          },
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class StaticsColumn extends StatelessWidget {
  const StaticsColumn(
      {Key? key, required this.title, required this.value, required this.onTap})
      : super(key: key);
  final String title;
  final num value;
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
              '$value',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
