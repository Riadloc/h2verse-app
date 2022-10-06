import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:h2verse_app/models/wallet_record.dart';
import 'package:h2verse_app/services/wallet_service.dart';
import 'package:h2verse_app/views/wallet/wallet_record_item.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';

class WalletList extends StatefulWidget {
  const WalletList({Key? key, required this.type}) : super(key: key);
  final int type;

  @override
  State<WalletList> createState() => _WalletListState();
}

class _WalletListState extends State<WalletList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int pageNo = 1;
  final int pageSize = 12;
  bool noMore = false;
  List<WalletRecord> recordList = [];

  void getList() async {
    if (!noMore) {
      var res = await WalletService.getRecords(
          type: widget.type, pageNo: pageNo, pageSize: pageSize);
      setState(() {
        List<WalletRecord> data = res;
        recordList.addAll(data);
        if (data.length < pageSize) {
          noMore = true;
        } else {
          pageNo += 1;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (recordList.isEmpty) {
      return const Center(
        child: EmptyPlaceholder(),
      );
    }
    return EasyRefresh(
      header: const MaterialHeader(),
      onRefresh: () async {
        setState(() {
          pageNo = 1;
          noMore = false;
          recordList.clear();
          getList();
        });
      },
      onLoad: () async {
        getList();
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: recordList.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 12,
        ),
        itemBuilder: (context, index) {
          var record = recordList[index];
          return WalletRecordItem(record: record);
        },
      ),
    );
  }
}
