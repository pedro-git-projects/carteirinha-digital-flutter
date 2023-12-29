import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  File? _imageFile;

  Future<void> downloadAndSaveImage() async {
    final config = Provider.of<ConfigProvider>(context, listen: false);
    final ip = config.ip;

    try {
      final response = await http.get(Uri.parse('http://$ip:8080/qr-code'));

      if (response.statusCode == 200) {
        final appDir = await getApplicationDocumentsDirectory();
        final imageFile = File('${appDir.path}/qr_code.jpg');

        await imageFile.writeAsBytes(response.bodyBytes, flush: true);

        setState(() {
          _imageFile = imageFile;
        });
      } else {
        print('Failed to download image: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _imageFile != null
            ? Image.file(_imageFile!)
            : const Text('Image not loaded yet'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: downloadAndSaveImage,
        child: const Icon(Icons.download),
      ),
    );
  }
}
