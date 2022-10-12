import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/models/bank_card_model.dart';
import 'package:h2verse_app/models/order_result_model.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/order_service.dart';
import 'package:h2verse_app/services/wallet_service.dart';
import 'package:h2verse_app/utils/event_bus.dart';
import 'package:h2verse_app/utils/events.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/common_field_card.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/numeric_stepper.dart';
import 'package:h2verse_app/widgets/otp_modal.dart';
import 'package:provider/provider.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({Key? key}) : super(key: key);

  static const routeName = '/orderForm';

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final Art detailData = Get.arguments;

  int count = 1;
  bool loading = false;
  String bankId = '';
  List<BankCard> bankCardList = [];

  String get orderPrice => (count * detailData.price).toStringAsFixed(2);

  void onChange(int newVal) {
    setState(() {
      count = newVal;
    });
  }

  Future<void> getBankList() async {
    var res = await WalletService.getBankList();
    setState(() {
      bankCardList = res;
    });
  }

  Future createOrder() async {
    if (bankId == '') {
      Toast.show('请选择支付银行卡');
      return;
    }
    setState(() {
      loading = true;
    });
    OrderResult? res = await OrderService.createOrder(
        goodId: detailData.id, bankId: bankId, count: count);
    if (res != null) {
      success() => {
            Get.dialog(Modal(
                title: '购买结果',
                description: '购买成功，可以在【我的藏品】进行查看',
                confirmText: '返回',
                onConfirm: () {
                  eventBus.fire(RefreshEvent());
                  Get.back(canPop: true, closeOverlays: true);
                }))
          };
      if (res.token != '') {
        Toast.show('已发送验证码至您的手机');
        Get.bottomSheet(
          OptModal(
            title: '输入您收到的验证码',
            onPress: (pin) async {
              bool isSuccess = await OrderService.doTrade(
                  orderId: res.orderId,
                  payKey: pin,
                  token: res.token,
                  orderNo: res.orderNo);
              if (isSuccess) {
                success();
              }
            },
          ),
          enableDrag: false,
          isDismissible: false,
        );
      } else {
        bool isSuccess = await OrderService.doSpecialTrade(
          orderId: res.orderId,
        );
        if (isSuccess) {
          success();
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBankList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('订单详情'),
      ),
      body: Column(
        children: [
          CommonFieldCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '商品详情',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedImage(
                      detailData.cover,
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
                            text: detailData.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: detailData.serial != null
                                      ? ' #${detailData.serial}'
                                      : ''),
                            ],
                          )),
                          Text('￥${detailData.price}')
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          CommonFieldCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  '支付方式',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '银行卡快捷支付',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Consumer<UserProvider>(
                      builder: (context, value, child) {
                        var user = value.user;
                        // if (!user.isBindPayPassword) {
                        //   return TextButton(
                        //       onPressed: () {
                        //         //
                        //       },
                        //       child: const Text(
                        //         '设置支付密码 >',
                        //         style: TextStyle(color: Colors.red),
                        //       ));
                        // }
                        return Checkbox(
                          checkColor: Colors.white,
                          shape: const CircleBorder(),
                          value: true,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (bool? value) {},
                        );
                      },
                    ),
                  ],
                )
              ])),
          CommonFieldCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  '支付银行卡',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < bankCardList.length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatBankNo(bankCardList[i].bankNo),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            shape: const CircleBorder(),
                            value: bankId == bankCardList[i].id,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (bool? value) {
                              setState(() {
                                bankId = value! ? bankCardList[i].id : '';
                              });
                            },
                          )
                        ],
                      )
                  ],
                )
              ])),
          CommonFieldCard(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                const Text(
                  '购买份数',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                NumericStepper(
                  count: count,
                  onChange: onChange,
                  max: detailData.limit ?? 10,
                )
              ])),
          CommonFieldCard(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                const Text(
                  '订单金额',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  '￥$orderPrice',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ])),
          CommonFieldCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                Text(
                  '其他说明',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('一个用户允许同时存在一笔待支付订单')
              ])),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: LoadingButton(
            loading: loading,
            onPressed: createOrder,
            style: ElevatedButton.styleFrom(
                elevation: 1,
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                textStyle: const TextStyle(fontSize: 16),
                foregroundColor: Colors.white),
            child: const Text('立即购买'),
          ),
        ),
      ),
    );
  }
}
