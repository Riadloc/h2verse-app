import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/openbox_record.dart';
import 'package:h2verse_app/services/record_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';

class BoxOpenRecords extends StatefulWidget {
  const BoxOpenRecords({Key? key}) : super(key: key);

  static const routeName = '/boxOpenRecords';

  @override
  State<BoxOpenRecords> createState() => _BoxOpenRecordsState();
}

class _BoxOpenRecordsState extends State<BoxOpenRecords> {
  int pageNo = 1;
  final int pageSize = 12;
  bool noMore = false;
  List<BoxOpenRecord> records = [];

  void getList() async {
    if (!noMore) {
      var value = await RecordService.getBoxOpenRecords(pageNo: pageNo);
      List<BoxOpenRecord> data = value;
      setState(() {
        records.addAll(data);
        if (data.length < pageSize) {
          noMore = true;
        } else {
          pageNo += 1;
        }
      });
    }
  }

  void reload() {
    setState(() {
      pageNo = 1;
      noMore = false;
      records.clear();
      getList();
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('开盒记录'),
        ),
        body: EasyRefresh(
          header: const MaterialHeader(),
          onRefresh: reload,
          onLoad: () async {
            getList();
          },
          child: records.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: records.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemBuilder: (context, index) {
                    var e = records[index];
                    return Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: kCardBoxShadow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // margin: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () {
                          //
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: CachedImage(
                                  e.cover,
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(left: 12),
                                height: 42,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          e.openName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('盲盒：${e.boxName}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            )),
                                        const Spacer(),
                                        Text(formartDate(e.createdAt),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : ListView(
                  children: const [EmptyPlaceholder()],
                ),
        ));
  }
}
