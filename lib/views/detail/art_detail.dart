import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/models/box_result_model.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/event_bus.dart';
import 'package:h2verse_app/utils/events.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/detail/art_gift_transfer.dart';
import 'package:h2verse_app/views/detail/art_power_consume.dart';
import 'package:h2verse_app/views/detail/art_power.dart';
import 'package:h2verse_app/views/identity.dart';

import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/views/order/order_form.dart';
import 'package:h2verse_app/views/search_screen.dart';
import 'package:h2verse_app/views/user/user_show.dart';
import 'package:h2verse_app/widgets/art_chain_info.dart';
import 'package:h2verse_app/widgets/back_button.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/gradient_button.dart';
import 'package:h2verse_app/widgets/loading_sceen.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/split_line.dart';
import 'package:h2verse_app/widgets/tap_tile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ArtDetail extends StatefulWidget {
  const ArtDetail({Key? key}) : super(key: key);

  static const String routeName = '/detail';

  @override
  State<ArtDetail> createState() => _ArtDetailState();
}

class _ArtDetailState extends State<ArtDetail> {
  final Color descriptionColor = const Color.fromRGBO(141, 152, 175, 1);
  final Map params = Get.arguments;
  int titleAlpha = 0;
  late final ScrollController scrollController;
  late Future<Art> futureRequest;
  bool btnLoading = false;
  int status = -1;

  Widget bottomButtonBuilder(UserProvider state, Art data) {
    void Function()? onPressed;
    String btnText = '';
    List<Color>? colors;
    int _status = status != -1 ? status : data.operatorStatus!;
    int duration = 0;

    switch (_status) {
      case GoodOperatorStatus.WAIT:
        {
          int time = data.nodes!.firstWhere((element) => element.id == 2).time;
          duration = DateTime.fromMillisecondsSinceEpoch(time)
              .difference(DateTime.now())
              .inSeconds;
          var countdown = Countdown(
            seconds: duration,
            build: (BuildContext context, double time) => Text(
              textAlign: TextAlign.center,
              DateFormat('HH时mm分ss秒 开售').format(
                  DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt(),
                      isUtc: true)),
              style: const TextStyle(fontSize: 16),
            ),
            interval: const Duration(seconds: 1),
            onFinished: () {
              setState(() {
                duration = 0;
                status = GoodOperatorStatus.OPEN;
              });
            },
          );
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    '${data.price} RMB',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: kCardBoxShadow),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [countdown],
                  ),
                ))
              ],
            ),
          );
        }
      case GoodOperatorStatus.WAIT_SUBSCRIBE:
        {
          onPressed = () async {
            setState(() {
              btnLoading = true;
            });
            bool result = await ArtService.postSubscribe(data.id);
            setState(() {
              btnLoading = false;
            });
            if (result) {
              Toast.show('预约成功');
              setState(() {
                status = GoodOperatorStatus.SUBSCRIBED;
              });
            }
          };
          btnText = '立即预约';
          break;
        }
      case GoodOperatorStatus.SUBSCRIBED:
        {
          btnText = '已预约，等待开售';
          break;
        }
      case GoodOperatorStatus.UN_LUCKY:
        {
          btnText = '未中签';
          break;
        }
      case GoodOperatorStatus.OPEN:
        {
          onPressed = () {
            Get.toNamed(OrderForm.routeName, arguments: data);
          };
          btnText = '立即购买';
          colors = gradientButtonPrimarycolors;
          break;
        }
      case GoodOperatorStatus.SOLD_OUT:
        {
          btnText = '已售罄';
          break;
        }
      case GoodOperatorStatus.CAN_TRANSFER:
        {
          onPressed = () => {
                Get.toNamed(ArtGiftTransfer.routeName,
                    arguments: {'goodId': data.id})
              };
          btnText = '转赠';
          break;
        }
      case GoodOperatorStatus.SHELVED:
        {
          btnText = '取消寄售';
          break;
        }
      case GoodOperatorStatus.UNSHELVE:
        {
          btnText = '立即寄售';
          break;
        }
      case GoodOperatorStatus.UNOPEN_BOX:
        {
          btnText = '立即开盒';
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SwipeableButtonView(
                  buttonText: '滑动开盒',
                  buttonColor: Colors.blue,
                  indicatorColor:
                      const AlwaysStoppedAnimation<Color>(Colors.blue),
                  buttontextstyle: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  buttonWidget: const Icon(
                    Icons.double_arrow_rounded,
                    color: Colors.white,
                  ),
                  activeColor: Colors.grey.shade100,
                  isFinished: btnLoading,
                  onWaitingProcess: () {
                    setState(() {
                      btnLoading = true;
                    });
                  },
                  onFinish: () async {
                    if (kIsWeb) {
                      EasyLoading.show(status: '开盒中...');
                    } else {
                      Get.dialog(
                          useSafeArea: false,
                          Center(
                            child: Lottie.asset(
                              'assets/lottie/present-for-you.json',
                              width: 500,
                              fit: BoxFit.fill,
                            ),
                          ),
                          barrierColor: Colors.white);
                    }
                    BoxResult? boxResult =
                        await ArtService.postOpenboxOne(id: data.id);
                    await Future.delayed(const Duration(milliseconds: 2000));
                    if (kIsWeb) {
                      EasyLoading.dismiss();
                    } else {
                      Get.back(closeOverlays: false);
                    }
                    setState(() {
                      btnLoading = false;
                    });
                    if (boxResult != null) {
                      eventBus.fire(RefreshEvent());
                      Get.dialog(Modal(
                        title: '',
                        body: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            CachedImage(
                              boxResult.data.cover,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitWidth,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            // ${boxResult.data.name}
                            Text.rich(TextSpan(
                                text: '恭喜您开到了：',
                                style: const TextStyle(fontSize: 15),
                                children: [
                                  TextSpan(
                                      text: boxResult.data.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(text: '！')
                                ]))
                          ],
                        ),
                        confirmText: '查看',
                        cancelText: '返回',
                        onConfirm: () {
                          Get.back(closeOverlays: false);
                          Get.offAndToNamed(ArtDetail.routeName, arguments: {
                            'goodId': boxResult.data.id,
                            'artType': ArtType.second,
                            'cover': boxResult.data.cover,
                          });
                        },
                        onCancel: () {
                          Get.back(closeOverlays: true);
                        },
                      ));
                    }
                  }));
        }
      default:
        {
          btnText = '';
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {
              status = 999;
            });
          });
          return Container();
        }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          params['artType'] != ArtType.second
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    '${data.price} RMB',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              : const SizedBox(),
          Expanded(
              child: GradientButton(
                  loading: btnLoading,
                  text: btnText,
                  onPressed: onPressed,
                  borderRadius: 8,
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 18),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  colors: colors))
        ],
      ),
    );
  }

  Widget buildTopStepper(Art data) {
    List<IconData> icons = [
      Icons.alarm_add_outlined,
      Icons.alarm_on_outlined,
      Icons.add_shopping_cart_outlined,
      Icons.published_with_changes_outlined
    ];
    List<ArtNode> steps = data.nodes ?? [];
    if (steps.isEmpty) return Container();
    if (data.showNodes == 0) return Container();
    Widget arrowForward = const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Icon(
        Icons.remove,
        size: 20,
      ),
    );
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 102,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        itemCount: steps.length,
        separatorBuilder: (context, index) => arrowForward,
        itemBuilder: (context, index) {
          var stepInfo = steps[index];
          Color color = Colors.black;
          if (data.nodeIndex == index) {
            color = Colors.blue;
          } else if (data.nodeIndex! < index) {
            color = Colors.grey;
          }
          return DefaultTextStyle(
            style: TextStyle(color: color),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[index],
                  color: color,
                ),
                Text(stepInfo.name),
                Text(
                  formartTimestamp(stepInfo.time),
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> buildBasicInfo(Art data) {
    var list = [
      {
        'label': '创作者',
        'value': data.ownner,
        "onTap": () {
          Get.toNamed(UserShow.routeName, arguments: {"uid": data.ownerUuid});
        }
      },
      // {'label': '拥有者', 'value': data.ownner},
      {'label': '发行', 'value': data.copies},
    ];
    if (data.operatorStatus == GoodOperatorStatus.SOLD_OUT) {
      list.add(
        {'label': '流通', 'value': data.realCopies ?? data.copies},
      );
    }
    if (data.showNodes == 1 &&
        data.operatorStatus != GoodOperatorStatus.SOLD_OUT) {
      list.add(
        {'label': '预约', 'value': data.reservation ?? 0},
      );
    }
    if (params['artType'] == ArtType.second) {
      list.add(
        {'label': '发行价', 'value': '￥${data.price}'},
      );
    }
    List<Widget> widgets = [];
    for (var i = 0; i < list.length; i++) {
      var ele = list[i];
      widgets.add(Expanded(
        child: Ink(
          child: InkWell(
            onTap: ele['onTap'] as Function()?,
            child: Column(
              children: [
                Text(
                  '${ele['value']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  ele['label'] as String,
                  style: const TextStyle(
                      color: Color.fromRGBO(141, 152, 175, 1), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ));
      if (i != list.length - 1) {
        widgets.add(const SplitLine());
      }
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    futureRequest = (params['artType'] == ArtType.main
        ? ArtService.getArtDetail
        : ArtService.getFluxArtDetail)(params['goodId']);
    scrollController = ScrollController();
    scrollController.addListener(() {
      var offset = scrollController.offset;
      int alpha = 0;
      if (offset > 100) {
        alpha = 255;
      } else if (offset <= 0) {
        alpha = 0;
      } else {
        alpha = offset * 255 ~/ 100;
      }
      if (alpha != titleAlpha) {
        setState(() {
          titleAlpha = alpha;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Art>(
      initialData: Art.empty(),
      future: futureRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
        } else if (snapshot.hasData) {
          Art detailData = snapshot.data!;
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                  backgroundColor: Colors.white.withAlpha(titleAlpha),
                  elevation: 0,
                  title: Text(detailData.name,
                      style:
                          TextStyle(color: Colors.black.withAlpha(titleAlpha))),
                  // titleTextStyle:
                  //     TextStyle(color: Colors.black.withAlpha(titleAlpha)),
                  leading: const CircleBackButton()),
              body: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      CachedImage(params['cover'] ?? detailData.cover),
                      buildTopStepper(detailData),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            color: Colors.white, boxShadow: kCardBoxShadow),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectionArea(
                                    child: Text(
                                  '${detailData.name}${detailData.serial != null ? ' #${detailData.serial}' : ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      height: 1.5),
                                )),
                                detailData.description == null ||
                                        detailData.description == ''
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          detailData.description ?? '',
                                          style: TextStyle(
                                              color: descriptionColor),
                                        )),
                                const SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  decoration: const ShapeDecoration(
                                      color: Color.fromRGBO(248, 250, 251, 1),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)))),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: buildBasicInfo(detailData),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 20, vertical: 8),
                      //   decoration: const BoxDecoration(
                      //       color: Color.fromRGBO(251, 250, 251, 1),
                      //       boxShadow: kCardBoxShadow),
                      //   child: Text(
                      //     '购买数字作品须知',
                      //     style: TextStyle(color: Colors.grey.shade700),
                      //   ),
                      // ),
                      detailData.pictures!.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: kCardBoxShadow),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < detailData.pictures!.length;
                                      i++)
                                    CachedImage(
                                      detailData.pictures![i],
                                    )
                                ],
                              ))
                          : Container(),
                      const SizedBox(
                        height: 12,
                      ),
                      if (params['artType'] != ArtType.main &&
                          detailData.powerId != null) ...[
                        TapTile(
                            title: '查看权益',
                            onTap: () {
                              Get.toNamed(ArtPower.routeName,
                                  arguments: {'goodId': detailData.id});
                            }),
                        const Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 1,
                        ),
                      ],
                      TapTile(
                          title: '上链信息',
                          onTap: () {
                            Get.bottomSheet(ArtChainInfo(
                                token: detailData.tokenId ?? '排队上链中'));
                          }),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        height: 1,
                      ),
                      TapTile(
                          title: '查看流转',
                          onTap: () {
                            Get.toNamed(SearchScreen.routeName, arguments: {
                              'index': 1,
                              'query': detailData.name
                            });
                          }),

                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            color: Colors.white, boxShadow: kCardBoxShadow),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '购买须知',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.5),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                                '氢宇宙中的数字藏品是虚拟数字商品，而非实物商品，仅限实名认证为年满18周岁的中国大陆用户购买。因数字藏品的特殊性，一经购买成功，将不支持退换。数字藏品的知识产权或其他权益属发行方或权利人所有，除另行取得发行方或权利人授权外，您不得将数字藏品用于任何商业用途。请勿对数字藏品进行炒作、场外交易或任何非法方式进行使用。',
                                style: TextStyle(
                                  color: descriptionColor,
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // if (params['artType'] != ArtType.main) ...[
                      //   TapTile(
                      //       title: '流转历史',
                      //       onTap: () {
                      //         //
                      //       }),
                      //   const SizedBox(
                      //     height: 12,
                      //   ),
                      // ]
                    ],
                  )),
              bottomNavigationBar: status != 999
                  ? BottomAppBar(
                      elevation: 5,
                      child: Consumer<UserProvider>(
                        builder: (context, value, child) => bottomButtonBuilder(
                          value,
                          detailData,
                        ),
                      ),
                    )
                  : null);
        }
        return Container();
      },
    );
  }
}
