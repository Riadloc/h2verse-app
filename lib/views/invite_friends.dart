import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/invite_records.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  static const routeName = '/inviteFriends';

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  GlobalKey repainKey = GlobalKey();
  String inviteCode = '';

  Future<void> onShare() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      return;
    }
    EasyLoading.show(status: '准备中');
    try {
      RenderRepaintBoundary? boundary = repainKey.currentContext
          ?.findRenderObject()! as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? finalByteData =
          await image.toByteData(format: ImageByteFormat.png);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final dir = Directory('$tempPath/氢宇宙海报.png');
      final imageFile = File(dir.path);
      await imageFile.writeAsBytes(finalByteData!.buffer.asUint8List());
      Share.shareFiles([imageFile.path]);
    } catch (err) {
      //
    } finally {
      EasyLoading.dismiss();
    }
  }

  void onCopy() {
    Clipboard.setData(
        ClipboardData(text: 'https://h5.h2verse.art/index?code=$inviteCode'));
    Toast.show('复制成功！');
  }

  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserProvider>(context, listen: false).user;
    inviteCode = '${user.userId}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('邀请好友'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.toNamed(InviteRecords.routeName);
                },
                child: const Text(
                  '邀请记录',
                  style: TextStyle(fontSize: 15),
                )),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RepaintBoundary(
                        key: repainKey,
                        child: Column(
                          children: [
                            Image.asset(
                              'lib/assets/poster.webp',
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                                color: const Color.fromRGBO(51, 51, 73, 1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          '氢宇宙',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text('不一样的 WEB3.0',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                    QrImage(
                                      data: inviteCode,
                                      version: QrVersions.auto,
                                      size: 66.0,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.all(4),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      Ink(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Ink(
                                  decoration: const ShapeDecoration(
                                    color: Colors.orange,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                      onPressed: onCopy,
                                      icon: const Icon(
                                        Icons.link,
                                        color: Colors.white,
                                      )),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  '复制链接',
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Ink(
                                  decoration: const ShapeDecoration(
                                    color: Colors.green,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                      onPressed: onShare,
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      )),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  '分享',
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}
