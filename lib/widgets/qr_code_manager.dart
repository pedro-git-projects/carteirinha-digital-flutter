import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class QRCodeManager extends ChangeNotifier {
  File? _imageFile;

  Future<void> downloadAndSaveQRCodeOnLogin(
      BuildContext context, String studentId, String password) async {
    final config = Provider.of<ConfigProvider>(context, listen: false);
    final ip = config.ip;

    final storageService = Provider.of<StorageService>(context, listen: false);
    final token = await storageService.read('token');

    final response = await http.get(
      Uri.parse('http://$ip:8080/auth/qr-code'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final appDir = await getApplicationDocumentsDirectory();
      final imageFile = File('${appDir.path}/qr_code.jpg');
      await imageFile.writeAsBytes(response.bodyBytes, flush: true);
      _imageFile = imageFile;
      notifyListeners();
    } else {
      print('Failed to download QR code: ${response.statusCode}');
    }
  }

  File? get qrCodeImage => _imageFile;
}
