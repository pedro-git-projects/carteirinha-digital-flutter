import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:provider/provider.dart';

class QRCodeManager extends ChangeNotifier {
  File? _imageFile;
  bool _isLoading = false;
  String? _errorMessage;

  QRCodeManager();

  Future<void> downloadAndSaveQRCode(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final configProvider =
          Provider.of<ConfigProvider>(context, listen: false);
      final ip = configProvider.ip;

      final storageService =
          Provider.of<StorageService>(context, listen: false);
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
      } else {
        throw Exception('Failed to download QR code: ${response.statusCode}');
      }
    } catch (error) {
      _errorMessage = error.toString();
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  File? get qrCodeImage => _imageFile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
}
