import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/models/art.model.dart';
import 'package:pearmeta_fapp/widgets/cached_image.dart';
import 'package:pearmeta_fapp/widgets/numeric_stepper.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  static const routeName = '/orderDetail';

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final Art detailData = Get.arguments;

  int count = 1;
  void onChange(int newVal) {
    setState(() {
      count = newVal;
    });
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
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            margin: const EdgeInsets.only(top: 12),
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
                      width: 20,
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
                            children: const <TextSpan>[
                              TextSpan(text: ' # 100'),
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
          Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
              margin: const EdgeInsets.only(top: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '支付方式',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '钱包',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                            onPressed: () {
                              //
                            },
                            child: const Text('立即开通 >'))
                      ],
                    )
                  ])),
          Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              margin: const EdgeInsets.only(top: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '购买份数',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    NumericStepper(
                      count: count,
                      onChange: onChange,
                      max: 8,
                    )
                  ])),
          Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              margin: const EdgeInsets.only(top: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '订单金额',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '￥${count * detailData.price}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ])),
          Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              margin: const EdgeInsets.only(top: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '其他说明',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('一个用户允许同时存在一笔待支付订单')
                  ]))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 1,
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  textStyle: const TextStyle(fontSize: 16),
                  onPrimary: Colors.white),
              onPressed: () {
                //
              },
              child: const Text('立即购买')),
        ),
      ),
    );
  }
}
