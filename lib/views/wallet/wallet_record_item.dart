import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/views/wallet/record_detail.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/models/wallet_record.dart';

class WalletRecordItem extends StatelessWidget {
  const WalletRecordItem({super.key, required this.record});
  final WalletRecord record;

  Widget buildThumbnail() {
    String assetName = '';
    if (record.type == WalletRecordType.TOP_UP) {
      assetName = 'lib/assets/cunkuan.svg';
    } else if (record.type == WalletRecordType.TRADE) {
      assetName = 'lib/assets/duizhang.svg';
    } else if (record.type == WalletRecordType.DRAW_CASH) {
      assetName = 'lib/assets/kabao.svg';
    }
    if (assetName.isNotEmpty) {
      return SvgPicture.asset(
        assetName,
        height: 50,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: kCardBoxShadow,
        ),
        child: InkWell(
            onTap: () {
              Get.toNamed(RecordDetail.routeName, arguments: {'id': record.id});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  buildThumbnail(),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recordNameMap[record.type]!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${record.change}',
                              style: TextStyle(
                                  color: record.change < 0 ||
                                          record.type == WalletRecordType.TOP_UP
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(statusNameMap[record.status]!,
                                style: TextStyle(color: Colors.grey.shade500)),
                            Text(
                              formartDate(record.createdAt, showFull: true),
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
