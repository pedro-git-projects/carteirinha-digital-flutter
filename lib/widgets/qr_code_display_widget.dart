import 'package:carteirinha_digital/widgets/qr_code_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QRCodeDisplayWidget extends StatelessWidget {
  const QRCodeDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final qrCodeManager = Provider.of<QRCodeManager>(context);
    final imageFile = qrCodeManager.qrCodeImage;

    return imageFile != null
        ? Image.file(imageFile)
        : const Text('QR code not available');
  }
}

