import 'package:flutter/material.dart';
import 'package:h2verse_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  User _user = User.empty();

  User get user => _user;

  set user(User item) {
    _user = item;
    notifyListeners();
  }

  void setKey(String key, dynamic value) {
    _user = User.copyWith(_user, {key: value});
  }
}
