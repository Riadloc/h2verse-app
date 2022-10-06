import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/models/real_user_info_model.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/services/wallet_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';

class BankCardBindForm extends StatefulWidget {
  const BankCardBindForm({Key? key}) : super(key: key);

  static const routeName = '/bankCardBindForm';

  @override
  State<BankCardBindForm> createState() => _BankCardBindFormState();
}

class _BankCardBindFormState extends State<BankCardBindForm> {
  final _formKey = GlobalKey<FormState>();
  var bankNoController = TextEditingController();
  var nameController = TextEditingController();
  var phoneNoController = TextEditingController();
  var idNoController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bankNoController.dispose();
    nameController.dispose();
    phoneNoController.dispose();
    idNoController.dispose();
    super.dispose();
  }

  void getInfo() async {
    RealUserInfo realUserInfo = await UserService.getUserCertifiedInfo();
    if (realUserInfo.realName.isNotEmpty) {
      nameController.text = realUserInfo.realName;
      idNoController.text = realUserInfo.idNo;
    } else {
      Get.dialog(Modal(
        title: '提示',
        description: '你还未完成实名认证！',
        confirmText: '返回',
        onConfirm: () {
          Get.back(closeOverlays: true);
        },
      ));
    }
  }

  void onAdd() async {
    setState(() {
      loading = true;
    });
    String realName = nameController.text;
    String idNo = idNoController.text;
    String bankNo = bankNoController.text;
    String phone = phoneNoController.text;
    bool res = await WalletService.postAddBank(
        realName: realName, idNo: idNo, bankNo: bankNo, phone: phone);
    setState(() {
      loading = false;
    });
    if (res) {
      Toast.show('绑定成功！');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('绑定银行卡'),
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 12),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: '请输入银行卡卡号',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      icon: InputLabel(
                        label: '卡号',
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入卡号';
                    }
                    return null;
                  },
                ),
                const Divider(),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                      hintText: '请选择开户人姓名',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      icon: InputLabel(
                        label: '开户人',
                      )),
                ),
                const Divider(),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: '请输入开户预留手机号',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      icon: InputLabel(
                        label: '手机号',
                      )),
                ),
                const Divider(),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                      hintText: '请输入开户人身份证号',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      icon: InputLabel(
                        label: '身份证号',
                      )),
                ),
              ],
            )),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onAdd();
                    }
                  },
                  child: const Text('立即绑定')))
        ]),
      )),
    );
  }
}

class InputLabel extends StatelessWidget {
  const InputLabel({Key? key, required this.label}) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Text(
        label,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
