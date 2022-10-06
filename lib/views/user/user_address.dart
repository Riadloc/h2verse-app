import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/models/address_model.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/loading_button.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({Key? key}) : super(key: key);

  static const routeName = '/userAddress';

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  bool loading = false;

  void selectCity() async {
    Result? result = await CityPickers.showCityPicker(
      context: context,
    );
    if (result != null) {
      _areaController.text =
          '${result.provinceName}/${result.cityName}/${result.areaName}';
    }
  }

  void getAddress() async {
    Address? address = await UserService.getAddress();
    if (address != null) {
      _phoneController.text = address.phone;
      _nameController.text = address.name;
      _areaController.text = address.area;
      _addressController.text = address.address;
    }
  }

  void saveAddress() async {
    setState(() {
      loading = true;
    });
    String phone = _phoneController.text;
    String name = _nameController.text;
    String area = _areaController.text;
    String address = _addressController.text;
    bool isSuccess = await UserService.saveAddress(
        phone: phone, name: name, area: area, address: address);
    if (isSuccess) {
      Toast.show('地址更新成功');
      Get.back();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('地址管理'),
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: '请输入收件人姓名',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    icon: InputLabel(
                      label: '收件人',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入收件人姓名';
                    }
                    return null;
                  },
                ),
                const Divider(),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      hintText: '请输入联系电话',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      icon: InputLabel(
                        label: '联系电话',
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入联系电话';
                    }
                    return null;
                  },
                ),
                const Divider(),
                TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                      hintText: '请选择省市地址',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      icon: InputLabel(
                        label: '省市地址',
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择省市地址';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: selectCity,
                ),
                const Divider(),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      hintText: '请输入详细地址',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      icon: InputLabel(
                        label: '详细地址',
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入详细地址';
                    }
                    return null;
                  },
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
                      saveAddress();
                    }
                  },
                  child: const Text('保存')))
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
