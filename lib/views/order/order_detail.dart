import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/models/order_model.dart';
import 'package:h2verse_app/services/order_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/common_field_card.dart';
import 'package:h2verse_app/widgets/copy_field.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:tobias/tobias.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  static const routeName = '/orderDetail';

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  int count = 1;
  bool loading = false;
  String orderId = '';
  late Future<Order> getDetail;

  @override
  void initState() {
    super.initState();
    var params = Get.arguments;
    orderId = params['orderId'];
    getDetail = OrderService.getDetail(orderId: params['orderId']);
  }

  Widget buildTopInfo(Order orderInfo) {
    String tips = '';
    Color backgroundColor = Colors.white;
    if (orderInfo.status == PayOrderStatus.FAILED) {
      tips = '订单已取消/失败';
      backgroundColor = Colors.orange;
    } else if (orderInfo.status == PayOrderStatus.SUCCESSED) {
      tips = '订单支付成功';
      backgroundColor = Colors.green;
    } else if (orderInfo.status == PayOrderStatus.PENDING) {
      tips = '订单待支付';
      backgroundColor = Colors.orange;
    }

    return Container(
      color: backgroundColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tips,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget buildBottomButtons(Order orderInfo) {
    if (orderInfo.status == PayOrderStatus.PENDING) {
      const double padding = 24.0;
      return Padding(
          padding: const EdgeInsets.all(padding),
          child: Row(
            children: [
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setState) => LoadingButton(
                    loading: loading,
                    onPressed: () {
                      Get.dialog(
                        Modal(
                          title: '确认取消订单？',
                          onConfirm: () async {
                            setState(() {
                              loading = true;
                            });
                            var res = await OrderService.cancelOrder(
                                orderNo: orderInfo.orderNo);
                            if (res) {
                              Toast.show('订单已取消');
                              Get.back(closeOverlays: true, result: true);
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                          onCancel: () {
                            Get.back(canPop: false);
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        textStyle: const TextStyle(fontSize: 16),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    child: const Text('取消订单'),
                  ),
                ),
              ),
              const SizedBox(
                width: padding,
              ),
              Expanded(
                  child: ElevatedButton(
                onPressed: () async {
                  if (orderInfo.url != null) {
                    success() => {
                          Get.dialog(Modal(
                              title: '支付结果',
                              description: '支付成功，藏品已转入您的仓库，可以在【我的藏品】进行查看',
                              confirmText: '确定',
                              onConfirm: () async {
                                Get.back(closeOverlays: false);
                                EasyLoading.show();
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                EasyLoading.dismiss();
                                setState(() {
                                  getDetail =
                                      OrderService.getDetail(orderId: orderId);
                                });
                              }))
                        };
                    if (orderInfo.url!.startsWith('https')) {
                      if (kIsWeb) {
                        launchUrlString(orderInfo.url!);
                      } else {
                        launchUrlString(orderInfo.url!,
                            mode: LaunchMode.externalApplication);
                      }
                      Future.delayed(const Duration(seconds: 1), () {
                        Get.dialog(Modal(
                          title: '支付',
                          description: '已完成支付',
                          cancelText: '未支付',
                          confirmText: '已支付',
                          onConfirm: () {
                            Get.back(closeOverlays: false);
                            success();
                          },
                          onCancel: () {
                            Get.back(closeOverlays: false);
                          },
                        ));
                      });
                    } else {
                      if (kIsWeb) {
                        Toast.show('请在App端操作继续支付');
                      } else {
                        var payResult = await aliPay(orderInfo.url!);
                        if (payResult['resultStatus'] == '9000' &&
                            payResult['result'] != '') {
                          success();
                          return;
                        }
                        Toast.show(payResult['memo'] != ''
                            ? payResult['memo']
                            : '支付未完成');
                      }
                    }
                  } else {
                    Toast.show('通过银行卡快捷支付方式支付的订单无法继续支付，请取消后重新发起订单');
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: Colors.white,
                ),
                child: const Text('继续支付'),
              ))
            ],
          ));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('订单详情'),
      ),
      body: FutureBuilder<Order>(
        future: getDetail,
        initialData: Order.empty(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListView(
              children: [
                buildTopInfo(data),
                CommonFieldCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '订单详情',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImage(
                            data.cover,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text.rich(TextSpan(
                                  text: data.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // children: <TextSpan>[
                                  //   TextSpan(
                                  //       text: data.serial != null
                                  //           ? ' #${detailData.serial}'
                                  //           : ''),
                                  // ],
                                )),
                                Text('￥${data.price}')
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Text(
                        '购买份数',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${data.buyCount}',
                        style: const TextStyle(fontSize: 15),
                      )
                    ])),
                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Text(
                        '订单金额',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '￥${count * data.price!}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Text(
                        '订单编号',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      CopyField(text: data.orderNo),
                    ])),
                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text(
                        '订单${data.status == PayOrderStatus.PENDING ? '创建' : '完成'}时间',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        formartDate(data.updatedAt, showFull: true),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                buildBottomButtons(data)
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
