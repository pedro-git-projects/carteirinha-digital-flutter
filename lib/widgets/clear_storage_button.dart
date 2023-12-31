import 'package:carteirinha_digital/state/auth_provider.dart';
import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearStorageButton extends StatelessWidget {
  const ClearStorageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        Provider.of<StorageService>(context, listen: false).clearStorage();
        authProvider.checkAuthentication();
      },
      child: const Text('Sair'),
    );
  }
}
