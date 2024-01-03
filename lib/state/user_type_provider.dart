import 'package:flutter/material.dart';

class UserTypeProvider with ChangeNotifier {
  String _userType = "";

  String get userType => _userType;

  set userType(String newUserType) {
    _userType = newUserType;
    notifyListeners();
  }
}
