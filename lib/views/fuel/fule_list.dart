import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';

class FuleStore extends StatefulWidget {
  const FuleStore({super.key});

  static const routeName = '/fuleStore';

  @override
  State<FuleStore> createState() => _FuleStoreState();
}

class _FuleStoreState extends State<FuleStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text('积分商城'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: const BoxDecoration(
                color: Colors.white, boxShadow: kCardBoxShadow),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('我的积分'),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      '10',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Row(
                          children: const [
                            Text('明细'),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            )
                          ],
                        ))
                  ],
                ),
                // TextButton(onPressed: () {}, child: const Text('我的订单'))
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white, boxShadow: kCardBoxShadow),
            child: Text(
              '商品持续上架中，敬请期待',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          )
        ],
      ),
    );
  }
}
