import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/power_code_info.dart';
import 'package:h2verse_app/models/power_model.dart';
import 'package:h2verse_app/services/power_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/detail/art_power_records.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';

class ArtPower extends StatefulWidget {
  const ArtPower({super.key});

  static const routeName = '/artPower';

  @override
  State<ArtPower> createState() => _ArtPowerState();
}

class _ArtPowerState extends State<ArtPower> {
  PowerInfo? powerInfo;
  PowerCodeInfo? powerCodeInfo;

  final params = Get.arguments;
  void getCode([isRefresh = true]) async {
    EasyLoading.show();
    PowerCodeInfo? value = await PowerService.getPowerQrcode(params['goodId']);
    EasyLoading.dismiss();
    if (value != null) {
      if (isRefresh && value.code == powerCodeInfo?.code) {
        Toast.show('二维码及验证码未过期');
        return;
      }
      setState(() {
        powerCodeInfo = value;
      });
    }
  }

  void init() async {
    EasyLoading.show();
    var res = await Future.wait([
      PowerService.getObjectPowerDetail(params['goodId']),
      PowerService.getPowerQrcode(params['goodId'])
    ]);
    EasyLoading.dismiss();
    if (res[0] != null) {
      setState(() {
        powerInfo = res[0];
      });
    }
    if (res[1] != null) {
      setState(() {
        powerCodeInfo = res[1];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      init();
    });
  }

  Widget buildQrcode() {
    if (powerCodeInfo == null) return Container();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            width: 200,
            height: 200,
            child: SvgPicture.string(powerCodeInfo!.qrcode),
          ),
        ),
        Container(
          height: 0.5,
          color: Colors.grey.shade100,
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: FieldLine(
            width: 120,
            label: '验证码',
            value: '${powerCodeInfo!.code}（三分钟有效期）',
          ),
        ),
      ],
    );
  }

  Widget buildUsedInfo() {
    if (powerInfo != null) {
      if (powerInfo!.statsList.isNotEmpty) {
        List<Widget> cols = [];
        for (var element in powerInfo!.statsList) {
          cols.add(FieldLine(
            width: 120,
            label: element.label,
            value: element.value,
          ));
        }
        return Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: cols,
            ));
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('查看权益'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.toNamed(ArtPowerRecords.routeName);
                },
                child: const Text('核销记录')),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        body: powerInfo != null
            ? ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: kCardBoxShadow),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.blue.withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: CachedImage(
                                  powerInfo!.cover,
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    powerInfo!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    powerInfo!.powerName,
                                    style:
                                        TextStyle(color: Colors.grey.shade800),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        buildQrcode(),
                        Container(
                          height: 0.5,
                          color: Colors.grey.shade100,
                        ),
                        buildUsedInfo(),
                        Container(
                          color: Colors.purple.withOpacity(0.1),
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '权益说明',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                powerInfo!.powerDescription
                                    .replaceAll("\\n", "\n"),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            : const Center(
                child: EmptyPlaceholder(
                  title: '没有权益',
                ),
              ),
        bottomNavigationBar: powerCodeInfo != null
            ? BottomAppBar(
                child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 1,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                              foregroundColor: Colors.white),
                          onPressed: getCode,
                          child: const Text('刷新验证码')))
                ]),
              ))
            : null);
  }
}

class FieldLine extends StatelessWidget {
  const FieldLine(
      {super.key,
      required this.width,
      required this.label,
      required this.value});
  final double width;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: width,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value))
        ],
      ),
    );
  }
}
