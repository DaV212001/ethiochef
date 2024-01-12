import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/model_theme.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ModelTheme>(context);

    return IconButton(
      icon: Icon(
        themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
        color: themeProvider.isDark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        // final provider = Provider.of<ModelTheme>(context, listen: false);
        // provider.setIsDark = !themeProvider.isDark;
      },
    );

  }
}
