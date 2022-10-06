import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/enum.dart';

class CommonProvider extends ChangeNotifier {
  int _sortKey = FilterItemKeysEnum.SORT_NEW.index;

  int get sortKey => _sortKey;

  setSortKey(int key) {
    _sortKey = key;
    notifyListeners();
  }
}
