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
      secondary: silver,
      onSecondary: russet,
      tertiary: russet,
      onTertiary: white,
      surface: antiFlashWhite,
      onSurface: cocoaBrown,
      onSurfaceVariant: russet,
      shadow: mikadoYellow
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white
    ),
    fontFamily: "Manrope",
    textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 18,
          color: cocoaBrown,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: TextStyle(
          letterSpacing: 0.5,
          fontSize: 15,
          color: cocoaBrown,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium : TextStyle(
          fontSize: 15,
          color: russet,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          color: white,
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
      color: antiFlashWhite,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0.5,
          color: silver
        ),
        borderRadius: allBorderRadius,
      ),
      elevation: 3,
      shadowColor: Colors.transparent
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
  static Color antiFlashWhite = const Color(0xFFECECEC);
  static Color russet = const Color(0xFF141115);
  static Color russet_O90 = const Color(0xE6141115);
  static Color seasalt = const Color(0xFFF8FAFC);
  static Color white = Colors.white;

  static BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(5), topRight: Radius.circular(5));

  static BorderRadius allBorderRadius = BorderRadius.all(Radius.circular(5));
}
