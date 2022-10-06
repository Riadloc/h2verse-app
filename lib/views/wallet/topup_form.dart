import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/widgets/common_field_card.dart';
import 'package:h2verse_app/widgets/counter_down_text_button.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';

class TopupForm extends StatefulWidget {
  const TopupForm({Key? key}) : super(key: key);

  static const routeName = '/topupForm';

  @override
  State<TopupForm> createState() => _TopupFormState();
}

class _TopupFormState extends State<TopupForm> {
  final int amount = Get.arguments;

  int count = 1;
  bool loading = false;
  // bool isChecked = false;
  int duration = 0;
  int selectedBank = 0;
  final bankList = [
    '招商银行（6732）',
    '农业银行（6211）',
  ];

  void onChange(int newVal) {
    setState(() {
      count = newVal;
    });
  }

  Future onTopup() async {
    setState(() {
      loading = true;
    });
    // var res = await OrderService.onTopup(goodId: detailData.id);
    // print(res);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          title: const Text('储值卡购买'),
          backgroundColor: Colors.white,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: gradientButtonPrimarycolors,
                    stops: [0, 0.49, 1]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        )
                      ],
                    ),
                    child: Hero(
                        tag: amount,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'lib/assets/value_cards/$amount.jpg',
                            height: 100,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          CommonFieldCard(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                const Text(
                  '储值卡额度',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  '￥$amount',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ])),
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
                    // TextButton(
                    //     onPressed: () {
                    //       //
                    //     },
                    //     child: const Text('立即开通 >'))
                    Checkbox(
                      checkColor: Colors.white,
                      shape: const CircleBorder(),
                      value: true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool? value) {
                        //
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
                  '选择支付银行卡',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                for (int i = 0; i < bankList.length; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${bankList[i]}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      // TextButton(
                      //     onPressed: () {
                      //       //
                      //     },
                      //     child: const Text('立即开通 >'))
                      Radio<int>(
                        value: i,
                        groupValue: selectedBank,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (int? value) {
                          setState(() {
                            selectedBank = value!;
                          });
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
                  '验证码',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 46,
                  child: LoginInput(
                    hintText: '验证码',
                    type: InputType.captcha,
                    suffix: CounterDownTextButton(
                      duration: duration,
                      onPressed: () {
                        //
                      },
                      onFinished: () {
                        setState(() {
                          duration = 0;
                        });
                      },
                    ),
                  ),
                )
              ])),
          CommonFieldCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                Text(
                  '购买说明',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('购买成功后储值卡金额会自动充值到平台账户中')
              ])),
        ]))
      ]),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: LoadingButton(
            loading: loading,
            onPressed: onTopup,
            style: ElevatedButton.styleFrom(
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                textStyle: const TextStyle(fontSize: 16),
                foregroundColor: Colors.white),
            child: const Text('确认支付'),
          ),
        ),
      ),
    );
  }
}
