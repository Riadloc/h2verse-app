import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/models/power_model.dart';
import 'package:h2verse_app/services/power_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/detail/art_power_records.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/modal.dart';
import 'package:h2verse_app/widgets/otp_modal.dart';

class ArtPowerConsume extends StatefulWidget {
  const ArtPowerConsume({super.key});

  static const routeName = '/artPowerConsume';

  @override
  State<ArtPowerConsume> createState() => _ArtPowerConsumeState();
}

class _ArtPowerConsumeState extends State<ArtPowerConsume> {
  final params = Get.arguments;
  bool checked = false;
  bool consumed = false;
  String merchantCode = '';
  Map<String, String> query = {};

  PowerInfo? powerInfo;
  void getPowerDetail() async {
    var value = await PowerService.getPowerShortDetail(query);
    if (value != null) {
      setState(() {
        powerInfo = value;
      });
    }
  }

  Future<PowerInfo?> getPowerFullDetail([bool showSuccess = false]) async {
    var value =
        await PowerService.checkAndGetObjectPowerDetail(query, merchantCode);
    if (value != null) {
      if (showSuccess) {
        Toast.show('校验通过');
      }
      setState(() {
        powerInfo = value;
        checked = true;
      });
    }
    return value;
  }

  Map<String, String> getQuery() {
    Uri uri = Uri.base;
    var query = uri.queryParameters;
    return query;
  }

  void checkMerchantCode() {
    Get.bottomSheet(
      OptModal(
        title: '输入商家码',
        buttonText: '校验',
        onPress: (pin) async {
          merchantCode = pin;
          var value = await getPowerFullDetail(true);
          if (value != null) {
            Get.back(closeOverlays: false);
          }
        },
        onClose: () {
          Get.back(closeOverlays: false);
        },
      ),
      enableDrag: false,
    );
  }

  void writeOff() {
    Get.dialog(Modal(
        title: '提示',
        description: '确认用户核销信息无误，确认核销本次权益？',
        onConfirm: () async {
          Get.back(closeOverlays: false);
          bool isSuccess = await PowerService.consumePower(query, merchantCode);
          if (isSuccess) {
            setState(() {
              consumed = true;
            });
            Get.dialog(Modal(
                title: '权益核销成功',
                onConfirm: () {
                  getPowerFullDetail();
                  Get.back(closeOverlays: false);
                }));
          }
        }));
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      query = getQuery();
      if (query['goodId'] == null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.dialog(Modal(
              title: '二维码信息不完整',
              onConfirm: () {
                Get.back(closeOverlays: true);
              }));
        });
        return;
      }
      getPowerDetail();
    }
  }

  Widget buildUsedInfo() {
    List<Widget> cols = [];
    if (powerInfo != null && powerInfo!.statsList.isNotEmpty) {
      for (var element in powerInfo!.statsList) {
        cols.add(FieldLine(
          width: 120,
          label: element.label,
          value: checked ? element.value : '******',
        ));
      }
    }
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FieldLine(
            width: 120,
            label: '核销人',
            value: checked ? powerInfo?.userName ?? '' : '******',
          ),
          FieldLine(
            width: 120,
            label: '手机号',
            value: checked ? powerInfo?.phone ?? '' : '******',
          ),
          FieldLine(
            width: 120,
            label: 'UID',
            value: checked ? '${powerInfo?.uid}' : '******',
          ),
          ...cols,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (powerInfo == null) return Container();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('权益核销'),
          actions: [
            checked
                ? TextButton(
                    onPressed: () {
                      Get.toNamed(ArtPowerRecords.routeName, arguments: {
                        'code': merchantCode,
                        'goodId': query['goodId']
                      });
                    },
                    child: const Text('核销记录'))
                : Container(),
            const SizedBox(
              width: 8,
            )
          ],
          automaticallyImplyLeading: false,
          leadingWidth: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 8),
                      blurRadius: 8,
                      spreadRadius: 8,
                      color: Color.fromRGBO(200, 200, 200, 0.2),
                    )
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.blue.withOpacity(0.1),
                    padding: const EdgeInsets.all(12),
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
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              powerInfo!.powerName,
                              style: TextStyle(color: Colors.grey.shade800),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        FieldLine(
                          width: 120,
                          label: '验证码',
                          value: checked
                              ? (powerInfo?.code != null &&
                                      powerInfo?.code != ''
                                  ? powerInfo!.code!
                                  : '验证码无效，需要用户端刷新二维码')
                              : '******',
                        ),
                      ],
                    ),
                  ),
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
                          powerInfo!.powerDescription.replaceAll("\\n", "\n"),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
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
        ),
        bottomNavigationBar: !consumed
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
                          onPressed: checked ? writeOff : checkMerchantCode,
                          child: Text(checked ? '确认核销' : '校验商家码')))
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
