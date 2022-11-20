import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/models/user_model.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/copy_field.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class ChainAddressSheet extends StatefulWidget {
  const ChainAddressSheet({super.key});

  @override
  State<ChainAddressSheet> createState() => _ChainAddressSheetState();
}

class _ChainAddressSheetState extends State<ChainAddressSheet> {
  bool loading = false;
  late User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 160,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '数字钱包地址',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          user.chainAccount.isNotEmpty
              ? Column(
                  children: [
                    CopyField(text: user.chainAccount),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.black,
                          child: Image.asset(
                            'assets/images/bsn.png',
                            height: 30,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : LoadingButton(
                  loading: loading,
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: Colors.white,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    bool isSuccess = await UserService.applyMetaAccount();
                    if (isSuccess) {
                      Toast.show('创建数字钱包成功！');
                      UserService.getUserInfo().then((value) {
                        Provider.of<UserProvider>(context, listen: false).user =
                            value;
                      });
                      Get.back(closeOverlays: false);
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                  child: const Text('开通数字钱包'))
        ],
      ),
    );
  }
}
