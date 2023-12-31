import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;

  Future<void> checkAuthentication() async {
    try {
      final token = await StorageService().read('token');
      isAuthenticated = token != null;
      notifyListeners();
    } catch (e) {
      isAuthenticated = false;
      notifyListeners();
    }
  }
}
