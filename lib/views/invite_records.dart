import 'package:flutter/material.dart';

class InviteRecords extends StatefulWidget {
  const InviteRecords({Key? key}) : super(key: key);

  static const routeName = '/inviteRecords';

  @override
  State<InviteRecords> createState() => _InviteRecordsState();
}

class _InviteRecordsState extends State<InviteRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('邀请记录'),
        actions: [
          IconButton(
              onPressed: () {
                //
              },
              icon: const Icon(Icons.refresh)),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: ListView(children: [
        Container(
          alignment: Alignment.center,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                const Text(
                  '1000人',
                  style: TextStyle(fontSize: 32),
                ),
                Text(
                  '我的邀请人数',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ListView.separated(
                  padding: const EdgeInsets.only(top: 12),
                  shrinkWrap: true,
                  itemCount: 10,
                  separatorBuilder: (BuildContext itemContext, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext itemContext, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('133****8888'),
                          Text(
                            '2022-08-20',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        )
      ]),
    );
  }
}
