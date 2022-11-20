import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/models/bank_card_model.dart';
import 'package:h2verse_app/models/order_config_model.dart';
import 'package:h2verse_app/models/order_result_model.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/order_service.dart';
import 'package:h2verse_app/services/wallet_service.dart';
import 'package:h2verse_app/utils/event_bus.dart';
import 'package:h2verse_app/utils/events.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/acount/bankcard_list.dart';
import 'package:h2verse_app/views/order/order_detail.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/common_field_card.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/numeric_stepper.dart';
import 'package:h2verse_app/widgets/otp_modal.dart';
import 'package:provider/provider.dart';
import 'package:tobias/tobias.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:h2verse_app/widgets/register_web_plugins/register_web_env_stub.dart'
    if (dart.library.html) 'package:h2verse_app/widgets/register_web_plugins/register_web_env.dart';

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
  int payStrategy = 0;
  int payType = PayType.unset.index;
  List<BankCard> bankCardList = [];
  OrderConfig? orderConfig;
  Map<String, dynamic> extraInfo = {};

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

  Future<void> getConfig() async {
    var res = await OrderService.getConfig(goodId: detailData.id);
    if (res != null) {
      setState(() {
        orderConfig = res;
        payStrategy = int.parse(res.payStrategy);
        if (payStrategy == 1) {
          payType = 1;
        } else if (payStrategy == 2) {
          payType = 2;
        }
      });
    }
    // Get.dialog(
    //     barrierDismissible: false,
    //     Modal(
    //         title: '提示',
    //         description: '服务遇到错误，无法创建订单',
    //         onConfirm: () {
    //           Get.back(closeOverlays: true);
    //         }));
  }

  Future createOrder() async {
    if (payType == PayType.unset.index) {
      Toast.show('请选择支付方式');
      return;
    }
    if (payType == PayType.lianlian.index && bankId.isEmpty) {
      Toast.show('请选择支付银行卡');
      return;
    }
    var config = orderConfig!.config;
    if (config?.required == 1) {
      String key = config!.key;
      String? value = extraInfo[key];
      if (value == null || value.isEmpty) {
        Toast.show('请选择${config!.title}');
        return;
      }
    }
    if (config?.needConfirm == 1) {
      String key = config!.key;
      String msg = config!.confirmMsg;
      String? value = extraInfo[key];
      if (msg.contains('\$$key')) {
        // ignore: prefer_interpolation_to_compose_strings
        msg = msg.replaceAll('\$$key', value!);
      }
      Get.dialog(Modal(
          title: '提示',
          description: msg,
          onCancel: () {
            Get.back(closeOverlays: false);
          },
          onConfirm: () {
            Get.back(closeOverlays: false);
            realCreateOrder();
          }));
    } else {
      realCreateOrder();
    }
  }

  Future realCreateOrder() async {
    setState(() {
      loading = true;
    });
    OrderResult? res = await OrderService.createOrder(
      goodId: detailData.id,
      bankId: bankId,
      payType: payType,
      count: count,
      isNative: kIsWeb ? null : 1,
      extra: extraInfo,
    );
    if (res != null) {
      success() => {
            Get.dialog(Modal(
                title: '购买结果',
                description: '购买成功，支付结果状态可能存在一定延迟，稍后可以在“我的藏品”或“我的订单”页详细查看购买情况',
                confirmText: '返回',
                onConfirm: () {
                  eventBus.fire(RefreshEvent());
                  Get.back(canPop: true, closeOverlays: true);
                }))
          };
      if (payType == PayType.lianlian.index && res.token != '') {
        Toast.show('已发送验证码至您的手机，信息可能延迟，请耐心等待');
        Get.bottomSheet(
          OptModal(
            title: '输入您收到的验证码',
            onPress: (pin) async {
              bool isSuccess = await OrderService.doTrade(
                  orderId: res.orderId,
                  payKey: pin,
                  token: res.token!,
                  orderNo: res.orderNo);
              if (isSuccess) {
                success();
              }
            },
          ),
          enableDrag: false,
          isDismissible: false,
        );
      } else if (payType == PayType.alipay.index &&
          res.url != null &&
          res.url != '') {
        if (kIsWeb) {
          openLink(res.url!);
        } else {
          var payResult = await aliPay(res.url!);
          if (payResult['result'] == '' && payResult['memo'] != '') {
            Toast.show(payResult['memo']);
            Future.delayed(const Duration(milliseconds: 1000), () {
              Get.offNamed(OrderDetail.routeName,
                  arguments: {'orderId': res.orderId});
            });
            return;
          }
          if (payResult['resultStatus'] == '9000' &&
              payResult['result'] != '') {
            //todo
            success();
            return;
          }
          Toast.show('支付未完成');
          Future.delayed(const Duration(milliseconds: 1000), () {
            Get.offNamed(OrderDetail.routeName,
                arguments: {'orderId': res.orderId});
          });
        }
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
    getConfig();
    getBankList();
  }

  Widget buildPayRadioGroup() {
    List<Widget> radios = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '银行卡快捷支付',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          bankCardList.isNotEmpty
              ? Consumer<UserProvider>(
                  builder: (context, value, child) {
                    var user = value.user;
                    return Checkbox(
                      checkColor: Colors.white,
                      shape: const CircleBorder(),
                      value: payType == PayType.lianlian.index,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool? value) {
                        setState(() {
                          payType = value!
                              ? PayType.lianlian.index
                              : PayType.unset.index;
                        });
                      },
                    );
                  },
                )
              : TextButton(
                  onPressed: () {
                    Get.offNamed(BankCardManage.routeName);
                  },
                  child: const Text('前去绑定银行卡>')),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                '支付宝',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(4)),
                child: const Text(
                  '随机立减',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Checkbox(
            checkColor: Colors.white,
            shape: const CircleBorder(),
            value: payType == PayType.alipay.index,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (bool? value) {
              setState(() {
                payType = value! ? PayType.alipay.index : PayType.unset.index;
              });
            },
          ),
        ],
      )
    ];
    if (payStrategy == 1) {
      radios.removeAt(1);
    } else if (payStrategy == 2) {
      radios.removeAt(0);
    }
    return Column(
      children: radios,
    );
  }

  Widget buildExtraForm() {
    if (orderConfig?.config == null) return Container();
    var config = orderConfig!.config!;
    return CommonFieldCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        config.title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      config.desc.isNotEmpty
          ? Text(
              config.desc,
              style: TextStyle(color: Colors.grey.shade700),
            )
          : Container(),
      const SizedBox(
        height: 6,
      ),
      for (int i = 0; i < config.options.length; i++)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              config.options[i].label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Checkbox(
              checkColor: Colors.white,
              shape: const CircleBorder(),
              value: extraInfo[config.key] == config.options[i].value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (bool? value) {
                setState(() {
                  extraInfo[config.key] = value! ? config.options[i].value : '';
                });
              },
            )
          ],
        )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('订单详情'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 12,
          ),
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
                const SizedBox(
                  height: 6,
                ),
                buildPayRadioGroup()
              ])),
          Visibility(
            visible: payType == PayType.lianlian.index,
            child: CommonFieldCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    '支付银行卡',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 6,
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
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
          ),
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
          buildExtraForm(),
          CommonFieldCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  '说明',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                DefaultTextStyle(
                    style: TextStyle(color: Colors.grey.shade700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('1. 一个用户允许同时存在一笔待支付订单'),
                        Text('2. 支付宝支付方式在微信浏览器端无法调起，请在浏览器或App中继续进行支付'),
                        Text('3. 若支付遇到问题，请尝试切换支付方式'),
                        Text('4. 银行卡快捷支付方式需要先绑定个人银行卡（不支持信用卡）')
                      ],
                    )),
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
