import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigProvider extends ChangeNotifier {
  late String ip;

  Future<void> loadConfig() async {
    await dotenv.load();
    ip = dotenv.env['PUBLIC_IP_ADDRESS'] ?? '';
    notifyListeners();
  }
}
