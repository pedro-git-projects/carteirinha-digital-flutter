import 'package:carteirinha_digital/state/auth_provider.dart';
import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:carteirinha_digital/widgets/theme_toggler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Carteirinha Digital'),
          ),
          const ListTile(
            title: ThemeToggler(),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    final storageService = Provider.of<StorageService>(context, listen: false);
    storageService.delete('token');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
  }
}
