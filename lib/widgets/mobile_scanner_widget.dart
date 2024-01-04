import 'dart:convert';

import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MobileScannerWidget extends StatefulWidget {
  const MobileScannerWidget({super.key});

  @override
  MobileScannerWidgetState createState() => MobileScannerWidgetState();
}

class MobileScannerWidgetState extends State<MobileScannerWidget> {
  MobileScannerController cameraController = MobileScannerController();

  Future<void> recordAttendance(
      BuildContext context, String studentToken) async {
    final config = Provider.of<ConfigProvider>(context, listen: false);
    final ip = config.ip;
    try {
      final String? authToken = await StorageService().read('token');

      if (authToken != null) {
        final Uri uri = Uri.parse('http://$ip:8080/auth/record-attendance');
        final Map<String, String> headers = {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        };
        final Map<String, String> body = {'student_token': studentToken};

        final http.Response response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          debugPrint('Entrada registrada com sucesso!');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Entrada registrada com sucesso!'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Falha ao registrar a entrada.',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        debugPrint('No authToken found.');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    cameraController.torchState.addListener(() {
      setState(() {});
    });
    cameraController.cameraFacingState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            final studentToken = barcode.rawValue ?? '';
            recordAttendance(context, studentToken);
          }
          Navigator.of(context).pop();
          cameraController.dispose();
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
