import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:h2verse_app/models/invitation_model.dart';
import 'package:h2verse_app/services/user_service.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';

class InviteRecords extends StatefulWidget {
  const InviteRecords({Key? key}) : super(key: key);

  static const routeName = '/inviteRecords';

  @override
  State<InviteRecords> createState() => _InviteRecordsState();
}

class _InviteRecordsState extends State<InviteRecords> {
  int pageNo = 1;
  bool noMore = false;
  List<Invitation> invitatedList = [];
  final int pageSize = 20;
  final double padding = 12.0;
  int count = 0;

  bool get initLoading => pageNo == 1 && !noMore && invitatedList.isEmpty;

  void getList() {
    if (!noMore) {
      UserService.getInvitations(pageNo: pageNo, pageSize: pageSize)
          .then((value) => {
                setState(() {
                  List<Invitation> data = value[1];
                  invitatedList.addAll(data);
                  count = value[0];
                  if (data.length < pageSize) {
                    noMore = true;
                  } else {
                    pageNo += 1;
                  }
                }),
              });
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  void onRefresh() {
    setState(() {
      pageNo = 1;
      noMore = false;
      invitatedList.clear();
      getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('邀请记录'),
          actions: [
            IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        body: EasyRefresh(
          onRefresh: onRefresh,
          onLoad: () async {
            getList();
          },
          child: ListView(children: [
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(fontSize: 32),
                    ),
                    Text(
                      '我的邀请人数',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '邀请记录',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  invitatedList.isEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(top: 12),
                          shrinkWrap: true,
                          itemCount: invitatedList.length,
                          separatorBuilder:
                              (BuildContext itemContext, int index) =>
                                  const Divider(),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext itemContext, int index) {
                            Invitation item = invitatedList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item.phone),
                                  Text(
                                    formartDate(item.createdAt),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            );
                          })
                      : const EmptyPlaceholder()
                ],
              ),
            )
          ]),
        ));
  }
}
