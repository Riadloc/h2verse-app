import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/models/wallet_record.dart';
import 'package:h2verse_app/services/wallet_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/widgets/common_field_card.dart';
import 'package:h2verse_app/widgets/modal.dart';

class RecordDetail extends StatefulWidget {
  const RecordDetail({super.key});

  static const routeName = '/recordDetail';

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  late Future<WalletRecord?> request;

  @override
  void initState() {
    super.initState();

    var params = Get.arguments;
    request = WalletService.getRecordDetail(params['id'] as String);
  }

  Widget buildButtons(WalletRecord record) {
    ButtonStyle buttonStylePlain = ElevatedButton.styleFrom(
        // elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(fontSize: 16),
        shadowColor: Colors.black54,
        backgroundColor: Colors.white);
    ButtonStyle buttonStylePrimary = ElevatedButton.styleFrom(
        // elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(fontSize: 16),
        foregroundColor: Colors.white);
    if (record.type == WalletRecordType.TOP_UP &&
        record.status == PayOrderStatus.PENDING) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                Get.dialog(
                  Modal(
                    title: '确认取消该充值订单',
                    onConfirm: () {
                      Get.back(canPop: false);
                    },
                    onCancel: () {
                      Get.back(canPop: false);
                    },
                  ),
                );
              },
              style: buttonStylePlain,
              child: const Text('取消支付'),
            )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: () {},
              style: buttonStylePrimary,
              child: const Text('继续支付'),
            )),
          ],
        ),
      );
    }
    if (record.type == WalletRecordType.DRAW_CASH &&
        [
          PayOrderStatus.DC_APPLYED_WAIT,
          PayOrderStatus.DC_TRANSFERED,
          PayOrderStatus.DC_APPLY_FAILED
        ].contains(record.type)) {
      return Row(
        children: [
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    //
                  },
                  child: const Text('重试'))),
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('账户变更记录详情'),
      ),
      body: FutureBuilder<WalletRecord?>(
        future: request,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.only(top: 12),
              children: [
                // CommonFieldCard(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text(
                //         '商品详情',
                //         style: TextStyle(
                //             fontSize: 15, fontWeight: FontWeight.w500),
                //       ),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           CachedImage(
                //             data.cover,
                //             width: 60,
                //             height: 60,
                //             fit: BoxFit.cover,
                //           ),
                //           const SizedBox(
                //             width: 16,
                //           ),
                //           SizedBox(
                //             height: 60,
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 Text.rich(TextSpan(
                //                   text: data.name,
                //                   style: const TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                   ),
                //                   // children: <TextSpan>[
                //                   //   TextSpan(
                //                   //       text: data.serial != null
                //                   //           ? ' #${detailData.serial}'
                //                   //           : ''),
                //                   // ],
                //                 )),
                //                 Text('￥${data.price}')
                //               ],
                //             ),
                //           )
                //         ],
                //       )
                //     ],
                //   ),
                // ),

                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Text(
                        '账户变更类型',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        recordNameMap[data.type] ?? '其他',
                        style: const TextStyle(fontSize: 15),
                      )
                    ])),
                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Text(
                        '账户变更金额',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '￥${data.change}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Text(
                        '订单编号',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data.recordNo,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                CommonFieldCard(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Text(
                        '订单完成时间',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        formartDate(data.updatedAt, showFull: true),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                CommonFieldCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text(
                        '备注',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data.payInfo.remark ?? '无',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                buildButtons(data)
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
