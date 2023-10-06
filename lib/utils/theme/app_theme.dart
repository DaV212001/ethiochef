import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: mikadoYellow,
    unselectedWidgetColor: grey,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white
    )
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: mikadoYellow,
    unselectedWidgetColor: grey,
    scaffoldBackgroundColor: russet_O90,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: russet
      )
  );

  static Color mikadoYellow = const Color(0xFFFEC20A);
  static Color cocoaBrown = const Color(0xFFD2691E);
  static Color grey = const Color(0xFF646464);
  static Color silver = const Color(0xFFCCCACA);
  static Color russet = const Color(0xFF141115);
  static Color russet_O90 = const Color(0xE6141115);
}
