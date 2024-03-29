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
        ? Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.file(imageFile),
          )
        : const Text('QR code indisponível, saia e entre novamente.');
  }
}
