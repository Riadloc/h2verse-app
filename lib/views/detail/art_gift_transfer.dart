import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/event_bus.dart';
import 'package:h2verse_app/utils/events.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/login_input.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/pin_code_form.dart';

class ArtGiftTransfer extends StatefulWidget {
  const ArtGiftTransfer({super.key});

  static const routeName = '/artGiftTransfer';

  @override
  State<ArtGiftTransfer> createState() => _ArtGiftTransferState();
}

class _ArtGiftTransferState extends State<ArtGiftTransfer> {
  final _phoneController = TextEditingController();
  bool loading = false;

  void onSubmit() {
    var phone = _phoneController.text;
    if (phone.isEmpty) {
      Toast.show('请输入手机号');
      return;
    }
    if (!RegExp(r'1[0-9]\d{9}$').hasMatch(phone)) {
      Toast.show('手机号格式不正确');
      return;
    }
    var arguments = Get.arguments;
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '输入您的交易密码',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Positioned(
                      top: 0,
                      right: 12,
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          constraints:
                              const BoxConstraints(maxHeight: 40, maxWidth: 40),
                          onPressed: () {
                            //
                          },
                          icon: const Icon(Icons.close)))
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            PinCodeForm(
              onComplete: (pin) async {
                Get.back(closeOverlays: false);
                setState(() {
                  loading = true;
                });
                bool isSuccess = await ArtService.postGift(
                    goodId: arguments['goodId'], receiver: phone, payKey: pin);
                if (isSuccess) {
                  eventBus.fire(RefreshEvent());
                  Get.dialog(Modal(
                    title: '您已成功转赠给$phone',
                    confirmText: '返回',
                    onConfirm: () {
                      Get.until((route) =>
                          Get.currentRoute == '/userArts' ||
                          Get.currentRoute == '/');
                    },
                  ));
                }
                setState(() {
                  loading = false;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text('转赠'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            LoginInput(
              hintText: '接收者手机号',
              icon: Icons.people,
              type: InputType.phone,
              controller: _phoneController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(children: [
          Expanded(
              child: LoadingButton(
                  loading: loading,
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: Colors.white),
                  onPressed: onSubmit,
                  child: const Text('转赠')))
        ]),
      )),
    );
  }
}
