import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/theme.dart';
import 'package:pearmeta_fapp/widgets/empty_placeholder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final OutlineInputBorder kInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
  );

  final List<Widget> _tabs = const <Widget>[
    Tab(
      text: '全部',
    ),
    Tab(
      text: '首发',
    ),
    Tab(
      text: '寄售',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _tabs.length,
      child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 0,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(102),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.arrow_back)),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(246, 246, 246, 1),
                              border: kInputBorder,
                              focusedBorder: kInputBorder,
                              enabledBorder: kInputBorder,
                              hintText: '搜索藏品',
                              contentPadding: EdgeInsets.zero,
                              constraints: const BoxConstraints(maxHeight: 40),
                              prefixIcon: Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                child: const Icon(Icons.search),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(onPressed: () {}, child: const Text('搜索'))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TabBar(
                            // labelColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            indicatorColor: xPrimaryColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: _tabs,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
          body: TabBarView(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: const [EmptyPlaceholder()],
              ),
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: const [EmptyPlaceholder()],
              ),
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: const [EmptyPlaceholder()],
              )
            ],
          )),
    );
  }
}
