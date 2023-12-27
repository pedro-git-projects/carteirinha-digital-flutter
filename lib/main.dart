import 'package:carteirinha_digital/qr_code_fetcher.dart';
import 'package:carteirinha_digital/screens/qr_code_scanner_screen.dart';
import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:carteirinha_digital/state/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  final configProvider = ConfigProvider();
  await configProvider.loadConfig();

  final themeProvider = ThemeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: configProvider),
        ChangeNotifierProvider.value(value: themeProvider),
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
      home: const QRCodeWidget(),
    );
  }
}
