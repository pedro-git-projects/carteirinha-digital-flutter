import 'package:carteirinha_digital/widgets/drawer_menu.dart';
import 'package:carteirinha_digital/widgets/qr_code_display_widget.dart';
import 'package:flutter/material.dart';

class QRCodeDisplayScreen extends StatelessWidget {
  const QRCodeDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteirinha'),
      ),
      drawer: const DrawerMenu(),
      body: const SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QRCodeDisplayWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
