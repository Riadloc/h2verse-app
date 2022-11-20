import 'package:flutter/material.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
import 'package:h2verse_app/widgets/market_list.dart';

class Market extends StatefulWidget {
  const Market({Key? key}) : super(key: key);

  static const routeName = '/market';

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  int sortKey = 0;
  GlobalKey<MarketListState> listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('流转中心'),
      ),
      body: const Center(
        child: EmptyPlaceholder(
          title: '对接元枢市场中',
        ),
      ),
    );
    ;
  }
}
