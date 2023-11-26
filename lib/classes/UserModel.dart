import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  Map<String, dynamic> _userDetails = {};

  void setUser(Map<String, dynamic> userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  void clearUser() {
    _userDetails = {};
    notifyListeners();
  }

  Map<String, dynamic> get getUser => _userDetails;
}
