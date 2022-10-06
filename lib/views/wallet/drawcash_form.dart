import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/widgets/common_field_card.dart';
import 'package:h2verse_app/widgets/counter_down_text_button.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';

class DrawcashForm extends StatefulWidget {
  const DrawcashForm({Key? key}) : super(key: key);

  static const routeName = '/drawcashForm';

  @override
  State<DrawcashForm> createState() => _DrawcashFormState();
}

class _DrawcashFormState extends State<DrawcashForm> {
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
          title: const Text('提现'),
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
              child: Lottie.network(
                  'https://assets3.lottiefiles.com/packages/lf20_yvwcdrrw.json',
                  fit: BoxFit.contain),
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
                  '我的账户余额',
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
                  '提现方式',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '提现到银行卡',
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
                        bankList[i],
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
                  '提现说明',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('提现金额将会在一个工作日内到账，请耐心等待'),
                Text('第三方支付会收取 1% 的手续费，请以实际到账的为准')
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
            child: const Text('确认提现'),
          ),
        ),
      ),
    );
  }
}
