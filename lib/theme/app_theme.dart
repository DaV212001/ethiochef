import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: mikadoYellow,
    unselectedWidgetColor: grey,
    colorScheme: ColorScheme.light(
      primary: cocoaBrown,
      onPrimary: white,
      primaryContainer: mikadoYellow,
      onPrimaryContainer: white,
      secondary: seasalt,
      onSecondary: russet,
      surface: seasalt,
      onSurface: cocoaBrown,
      onSurfaceVariant: russet,
      shadow: mikadoYellow
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white
    ),
    textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 18,
          color: cocoaBrown,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium : TextStyle(
          fontSize: 15,
          color: russet,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          color: white,
        )
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: cocoaBrown,
      textTheme: ButtonTextTheme.primary
    ),
    cardTheme: CardTheme(
      color: seasalt,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: allBorderRadius
      ),
      shadowColor: mikadoYellow
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
  static Color seasalt = const Color(0xFFF8FAFC);
  static Color white = Colors.white;

  static BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(5), topRight: Radius.circular(5));

  static BorderRadius allBorderRadius = BorderRadius.all(Radius.circular(5));
}
