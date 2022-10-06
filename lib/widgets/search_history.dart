import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:h2verse_app/constants/constants.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key, required this.onTap}) : super(key: key);

  final void Function(String query) onTap;

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    var box = Hive.box(LocalDB.BOX);
    var _history = box.get(LocalDB.SEARCH, defaultValue: <String>[]);
    setState(() {
      history = _history;
    });
  }

  void onClearHistory() {
    if (history.isNotEmpty) {
      var box = Hive.box(LocalDB.BOX);
      box.delete(LocalDB.SEARCH);
      setState(() {
        history = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '搜索历史',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            IconButton(
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
                onPressed: onClearHistory,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                ))
          ],
        ),
        history.isNotEmpty
            ? Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < history.length; i++)
                    ActionChip(
                        label: Text(
                          history[i],
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                        onPressed: () => widget.onTap(history[i]))
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '没有搜索历史',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              )
      ],
    );
  }
}
