import 'package:flutter/material.dart';
import 'package:memento_flutter/model/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void refreshUser(Map json) {
    _currentUser = User.fromJson(json);
  }

  void setUser(Map json) {
    _currentUser = User.fromJson(json);
  }
}
