import 'package:carteirinha_digital/qr_code_scanner.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carteirinha Digital CNEC')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MobileScannerWidget(),
                  ),
                );
              },
              child: const Text('Escanear QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
