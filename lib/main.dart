import 'package:carteirinha_digital/screens/login_screen.dart';
import 'package:carteirinha_digital/screens/qr_code_display_screen.dart';
import 'package:carteirinha_digital/screens/qr_code_scanner_screen.dart';
import 'package:carteirinha_digital/state/auth_provider.dart';
import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:carteirinha_digital/state/theme_provider.dart';
import 'package:carteirinha_digital/state/user_type_provider.dart';
import 'package:carteirinha_digital/widgets/qr_code_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  final configProvider = ConfigProvider();
  await configProvider.loadConfig();

  final authProvider = AuthProvider();
  await authProvider.checkAuthentication();

  final storageService = StorageService();

  final themeProvider = ThemeProvider();

  final userTypeProvider = UserTypeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: configProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: userTypeProvider),
        Provider.value(value: storageService),
        ChangeNotifierProvider(create: (context) => QRCodeManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Carteirinha Digital',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.currentThemeMode,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthProvider>(context, listen: true);
    final userTypeProvider =
        Provider.of<UserTypeProvider>(context, listen: true);

    if (authState.isAuthenticated) {
      switch (userTypeProvider.userType) {
        case "students":
          return const QRCodeDisplayScreen();
        case "parents":
          return const QRCodeDisplayScreen();
        case "staff":
          return const QRCodeScannerScreen();
        default:
          return const LoginScreen();
      }
    } else {
      return const LoginScreen();
    }
  }
}
