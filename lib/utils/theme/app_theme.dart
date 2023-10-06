import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: mikadoYellow,
    textTheme: const TextTheme(
        bodyMedium:
            TextStyle(fontWeight: FontWeight.w400, color: Colors.black)),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: mikadoYellow,
    scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
  );

  static Color mikadoYellow = const Color(0xFFFEC20A);
  static Color cocoaBrown = const Color(0xFFD2691E);
  static Color darkBrown = const Color(0xFF602E08);
}
