import 'package:carteirinha_digital/widgets/mobile_scanner_widget.dart';
import 'package:flutter/material.dart';

class QRCodeScannerScreen extends StatelessWidget {
  const QRCodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Carteirinha'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MobileScannerWidget(),
                    ),
                  );
                },
                child: const Text('Escanear QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
