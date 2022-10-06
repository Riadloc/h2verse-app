import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/widgets/empty_placeholder.dart';
import 'package:h2verse_app/widgets/market_list.dart';
import 'package:h2verse_app/widgets/search_history.dart';

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

  final _searchController = TextEditingController();
  bool showHistory = true;
  int initialIndex = 0;

  final List<Widget> _tabs = const <Widget>[
    Tab(
      text: '首发',
    ),
    Tab(
      text: '寄售',
    ),
  ];

  void onHistorySelect(String query) {
    _searchController.text = query;
    onSearch();
  }

  void onSearch() {
    String query = _searchController.text;
    if (query.isEmpty) {
      Toast.show('请输入搜索内容');
      return;
    }
    setState(() {
      showHistory = false;
    });
    var box = Hive.box(LocalDB.BOX);
    List<String> history = box.get(LocalDB.SEARCH, defaultValue: <String>[]);
    history.remove(query);
    if (history.length >= LocalDB.SEARCH_HISTORY_MAX) {
      history.removeLast();
    }
    history.insert(0, query);
    box.put(LocalDB.SEARCH, history);
  }

  void clearQuery() {
    setState(() {
      showHistory = true;
    });
  }

  @override
  void initState() {
    super.initState();
    var params = Get.arguments;
    if (params != null) {
      initialIndex = params['index'] as int;
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          onHistorySelect(params['query']);
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: initialIndex,
        length: _tabs.length,
        child: Scaffold(
          body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
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
                                controller: _searchController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(246, 246, 246, 1),
                                  border: kInputBorder,
                                  focusedBorder: kInputBorder,
                                  enabledBorder: kInputBorder,
                                  hintText: '搜索藏品',
                                  contentPadding: EdgeInsets.zero,
                                  constraints:
                                      const BoxConstraints(maxHeight: 40),
                                  prefixIcon: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.search),
                                  ),
                                  // suffixIcon: IconButton(
                                  //   onPressed: () {},
                                  //   splashColor: Colors.transparent,
                                  //   highlightColor: Colors.transparent,
                                  //   style: IconButton.styleFrom(
                                  //       tapTargetSize:
                                  //           MaterialTapTargetSize.shrinkWrap),
                                  //   icon: const Icon(Icons.close),
                                  // ),
                                ),
                                style: const TextStyle(fontSize: 14),
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    clearQuery();
                                  }
                                },
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  String query = _searchController.text;
                                  if (query.isEmpty) {
                                    Toast.show('请输入搜索内容');
                                    return;
                                  }
                                  var box = Hive.box(LocalDB.BOX);
                                  List<String> history = box.get(LocalDB.SEARCH,
                                      defaultValue: <String>[]);
                                  var newVal = [query];
                                  history.remove(query);
                                  newVal.addAll(history);
                                  box.put(LocalDB.SEARCH, newVal);
                                  print(history);
                                },
                                child: const Text('搜索'))
                          ],
                        ),
                      ],
                    ),
                  ),
                  showHistory
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SearchHistory(
                            onTap: onHistorySelect,
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: TabBar(
                            // labelColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            indicatorColor: xPrimaryColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: _tabs,
                          ),
                        ),
                  if (!showHistory)
                    Expanded(
                        child: TabBarView(
                      children: [
                        for (int i = 0; i < _tabs.length; i++)
                          MarketList(
                            type: i,
                            query: _searchController.text,
                          )
                      ],
                    ))
                ],
              )),
        ));
  }
}
