import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;

  Future<void> checkAuthentication() async {
    try {
      print("READING>>>>>>>>>>>>>>");
      final token = await StorageService().read('token');
      print("TOKEN >>>>>>>>>>>>>> $token");
      isAuthenticated = token != null;
      print("IS AUTH >>>>>>> $isAuthenticated");
      notifyListeners();
      print("NOTIFIED SUCCESS");
    } catch (e) {
      isAuthenticated = false;
      notifyListeners();
      print("NOTIFIED FAILIURE");
    }
  }
}
