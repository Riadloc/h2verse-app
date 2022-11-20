import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/pin_code_form.dart';

class OptModal extends StatefulWidget {
  const OptModal(
      {super.key,
      this.onPress,
      this.title = '输入您的交易密码',
      this.buttonText = '立即支付',
      this.onClose});
  final Future<void> Function(String pin)? onPress;
  final String title;
  final String buttonText;
  final void Function()? onClose;

  @override
  State<OptModal> createState() => _OptModalState();
}

class _OptModalState extends State<OptModal> {
  String pinCode = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
                            child: Text(widget.buttonText)))
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
                      if (widget.onClose != null) {
                        widget.onClose!();
                        return;
                      }
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
