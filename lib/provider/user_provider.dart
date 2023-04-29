import 'package:flutter/material.dart';
import 'package:memento_flutter/model/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(Map json) {
    _currentUser = User.fromJson(json);
    notifyListeners();
  }

  void deleteUser() {
    _currentUser = null;
    notifyListeners();
  }
}
