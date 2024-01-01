import 'package:carteirinha_digital/state/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggler extends StatelessWidget {
  const ThemeToggler({super.key});

  Icon _getIconForTheme(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark
        ? const Icon(Icons.brightness_3)
        : const Icon(Icons.wb_sunny);
  }

  @override
  Widget build(BuildContext context) {
    final themeModeProvider = Provider.of<ThemeProvider>(context);
    return InkResponse(
      highlightShape: BoxShape.circle,
      onTap: themeModeProvider.toggleTheme,
      child: _getIconForTheme(themeModeProvider.currentThemeMode),
    );
  }
}
