import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/models/apollo_model.dart';

class CommonProvider extends ChangeNotifier {
  int _sortKey = FilterItemKeysEnum.SORT_NEW.index;

  int get sortKey => _sortKey;

  Apollo _apollo = Apollo(payStrategy: '1');

  Apollo get apollo => _apollo;

  setSortKey(int key) {
    _sortKey = key;
    notifyListeners();
  }

  setApollo(Map<String, dynamic> json) {
    _apollo = Apollo.fromMap(json);
    notifyListeners();
  }
}
