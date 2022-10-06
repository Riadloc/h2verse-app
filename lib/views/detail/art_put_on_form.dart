import 'package:flutter/material.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';

class ArtPutOnForm extends StatefulWidget {
  const ArtPutOnForm(
      {super.key,
      required this.title,
      required this.boughtPrice,
      required this.onPress});
  final String title;
  final num boughtPrice;
  final Future<void> Function(String price) onPress;

  @override
  State<ArtPutOnForm> createState() => _ArtPutOnFormState();
}

class _ArtPutOnFormState extends State<ArtPutOnForm> {
  bool loading = false;
  bool isChecked = false;
  final _priceController = TextEditingController();
  num price = 0;

  String get realPrice => (price * 0.93).toStringAsFixed(2);

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Stack(children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                LoginInput(
                  hintText: '寄售价格',
                  type: InputType.price,
                  controller: _priceController,
                  onChanged: (_price) {
                    print(_price);
                    setState(() {
                      price = _price.isNotEmpty ? num.parse(_price) : 0;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Text.rich(TextSpan(
                    text: '购买价格',
                    style: const TextStyle(height: 2),
                    children: [
                      TextSpan(
                          text: '￥${widget.boughtPrice}',
                          style: const TextStyle(color: Colors.red))
                    ])),
                Text.rich(TextSpan(
                    text: '扣除手续费后获得',
                    style: const TextStyle(height: 2),
                    children: [
                      TextSpan(
                          text: '￥$realPrice',
                          style: const TextStyle(color: Colors.blue))
                    ])),
                const Text.rich(
                  TextSpan(text: '说明：', style: TextStyle(height: 2), children: [
                    TextSpan(text: '服务费：手续费'),
                    TextSpan(text: '3.5%', style: TextStyle(color: Colors.red)),
                    TextSpan(text: '版税'),
                    TextSpan(text: '3.5%', style: TextStyle(color: Colors.red)),
                  ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      shape: const CircleBorder(),
                      value: isChecked,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    const Text('我已阅读并同意'),
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        onPressed: () => debugPrint('111'),
                        child: const Text('《商家入驻协议》')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: LoadingButton(
                            loading: loading,
                            onPressed: () async {
                              if (_priceController.text.isEmpty) {
                                Toast.show('请输入寄售价格');
                                return;
                              }
                              if (!isChecked) {
                                Toast.show('请勾选同意《商家入驻协议》');
                                return;
                              }
                              setState(() {
                                loading = true;
                              });
                              await widget.onPress('');
                              setState(() {
                                loading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                // elevation: 1,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                textStyle: const TextStyle(fontSize: 16),
                                foregroundColor: Colors.white),
                            child: const Text('立即寄售')))
                  ],
                )
              ])
        ]));
  }
}
