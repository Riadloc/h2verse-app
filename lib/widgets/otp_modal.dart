import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/pin_code_form.dart';

class OptModal extends StatefulWidget {
  const OptModal({super.key, this.onPress});
  final Future<void> Function(String pin)? onPress;

  @override
  State<OptModal> createState() => _OptModalState();
}

class _OptModalState extends State<OptModal> {
  String pinCode = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '输入您的支付密码',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                PinCodeForm(
                  onComplete: (pin) {
                    setState(() {
                      pinCode = pin;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Expanded(
                        child: LoadingButton(
                            loading: loading,
                            onPressed: pinCode.isNotEmpty
                                ? () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await widget.onPress!(pinCode);
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                // elevation: 1,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                textStyle: const TextStyle(fontSize: 16),
                                foregroundColor: Colors.white),
                            child: const Text('确认支付')))
                  ],
                )
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    padding: const EdgeInsets.all(0),
                    constraints:
                        const BoxConstraints(maxHeight: 40, maxWidth: 40),
                    onPressed: () {
                      Get.dialog(Modal(
                        title: '支付提示',
                        description: '暂不进行支付？返回后您可在【我的订单-待支付】找到该条订单',
                        confirmText: '继续支付',
                        cancelText: '暂不支付',
                        onConfirm: () {
                          Get.back(closeOverlays: false, canPop: false);
                        },
                        onCancel: () => {
                          Get.back(closeOverlays: true, canPop: true),
                        },
                      ));
                    },
                    icon: const Icon(Icons.close)))
          ],
        ));
  }
}
