import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme (bool isOn){
    themeMode = isOn ? ThemeMode.dark: ThemeMode.light;
    notifyListeners();
  }
}
class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: denim,
    unselectedWidgetColor: gray,
    cardColor: antiFlashWhite,
    scaffoldBackgroundColor: white,
    fontFamily: "Manrope",
    buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
            primary: denim, secondary: white, primaryContainer: denim_O20)),
    canvasColor: gold,
    colorScheme: ColorScheme.light(
        primary: denim,
        primaryContainer: denim_O20,
        tertiaryContainer: cocoaBrown2,
        secondary: antiFlashWhite,
        onSecondary: grey,
        secondaryContainer: russet,
        onTertiary: gray,
        tertiary: gunmetal,
        error: tomato,
        inversePrimary: gold,
        inverseSurface: gold_O40),
    bottomNavigationBarTheme:
    BottomNavigationBarThemeData(backgroundColor: white)
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: gold,
    unselectedWidgetColor: gray,
    cardColor: prussianBlue2,
    scaffoldBackgroundColor: prussianBlue,
    fontFamily: "Manrope",
    buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.dark(
            primary: denim, secondary: white, primaryContainer: denim_O20)),
    canvasColor: gold,
    colorScheme: ColorScheme.dark(
        primary: gold,
        primaryContainer: gold_O40,
        secondary: antiFlashWhite,
        secondaryContainer: cadetGray,
        tertiary: antiFlashWhite,
        error: tomato,
        inversePrimary: denim,
        inverseSurface: denim_O20),
    bottomNavigationBarTheme:
    BottomNavigationBarThemeData(backgroundColor: prussianBlue),
  );
  static Color cocoaBrown = const Color(0xFFFEC20A);//
  static Color denim = const Color(0xFFD2691E);//
  static Color cocoaBrown2 = const Color(0x11D2691E);//
  static Color grey = const Color(0xFF646464);//
  static Color silver = const Color(0xFFCCCACA);//
  static Color antiFlashWhite = const Color(0xFFECECEC);
  static Color russet = const Color(0xFF141115);
  static Color russet_O90 = const Color(0xE6141115);
  static Color seasalt = const Color(0xFFF8FAFC);
  static Color white = Colors.white;
  static const Color tomato = Color(0xFFFD3A39);

  static const Color mikadoYellow = Color(0xFF7E3B0E);//
  // static const Color antiFlashWhite = Color(0xFFD2691E);//
  static const Color platinum = const Color(0x11D2691E);//
  static const Color gray = const Color(0xAA646464); // //gray darker
  static const Color gunmetal = const Color(0xFFCCCACA);
  static const Color gold = const Color(0xFFECECEC);

  static const Color prussianBlue = Color(0xFF27374D);
  static const Color prussianBlue2 = Color(0xFF1E293B);
  static const Color cadetGray = Color(0xFF9E9E9E); //gray
  static const Color denim_O20 = Color(0x33285EAC);

  static const Color gold_O40 = Color(0x66FED600);
  static const Color tyrianPurple_40 = Color(0x2659002E);
  // static const Color tomato = Color(0xFFFE4A49);
  // static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static TextStyle addressCardButton(Color color) =>
      TextStyle(color: color, fontWeight: FontWeight.normal, fontSize: 15);

  static BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(5.r), topRight: Radius.circular(5.r));

  static BorderRadius bottomBorderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
  static BorderRadius allBorderRadius = BorderRadius.all(Radius.circular(5.r));

  static BoxConstraints  inputFieldIconTablet = BoxConstraints(
    minWidth: 25.w,
    minHeight: 15.h
  );
  static TextStyle inputFieldStyleTablet = TextStyle(fontSize: 10.sp);
  static TextStyle inputFieldErrorStyleTablet = TextStyle(fontSize: 10.sp);
  static TextStyle snackBarStyleTablet = TextStyle(fontSize: 13.sp);
  static TextStyle snackBarStyle = TextStyle(fontSize: 15.sp);
  //
  // static ThemeData lightTheme = ThemeData(
  //   primaryColor: mikadoYellow,
  //   unselectedWidgetColor: grey,
  //   colorScheme: ColorScheme.light(
  //     primary: cocoaBrown,
  //     tertiaryContainer: cocoaBrown2,
  //     onPrimary: white,
  //     primaryContainer: mikadoYellow,
  //     onPrimaryContainer: white,
  //     secondary: silver,
  //     onSecondary: russet,
  //     secondaryContainer: silver,
  //     onSecondaryContainer: russet,
  //     tertiary: russet,
  //     onTertiary: white,
  //     surface: antiFlashWhite,
  //     onSurface: cocoaBrown,
  //     onSurfaceVariant: russet,
  //     shadow: grey,
  //     background: white,
  //     error: tomato
  //   ),
  //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //     backgroundColor: white
  //   ),
  //   fontFamily: "Manrope",
  //   textTheme: TextTheme(
  //       headlineLarge: TextStyle(
  //         fontSize: 20,
  //         color: russet,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       headlineMedium: TextStyle(
  //         fontSize: 26,
  //         color: cocoaBrown,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       headlineSmall: TextStyle(
  //         letterSpacing: 0.5,
  //         fontSize: 15,
  //         color: cocoaBrown,
  //         fontWeight: FontWeight.w400,
  //       ),
  //       bodyMedium : TextStyle(
  //         fontSize: 15,
  //         color: russet,
  //       ),
  //       displaySmall: TextStyle(
  //         fontSize: 10,
  //         color: russet,
  //       ),
  //       labelMedium: TextStyle(
  //         fontSize: 13,
  //         color: white,
  //       ),
  //       labelSmall: TextStyle(
  //         fontSize: 10,
  //         color: white,
  //       ),
  //   ),
  //   buttonTheme: ButtonThemeData(
  //     buttonColor: cocoaBrown,
  //     textTheme: ButtonTextTheme.primary
  //   ),
  //   cardTheme: CardTheme(
  //     color: antiFlashWhite,
  //     clipBehavior: Clip.hardEdge,
  //     shape: RoundedRectangleBorder(
  //       side: BorderSide(
  //         width: 0.5,
  //         color: silver
  //       ),
  //       borderRadius: allBorderRadius,
  //     ),
  //     elevation: 3,
  //     shadowColor: Colors.transparent
  //   )
  // );
  //
  // static ThemeData darkTheme = ThemeData(
  //   primaryColor: mikadoYellow,
  //   unselectedWidgetColor: grey,
  //
  //   scaffoldBackgroundColor: russet_O90,
  //     bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //         backgroundColor: russet
  //     )
  // );
  //
  // static Color mikadoYellow = const Color(0xFFFEC20A);
  // static Color cocoaBrown = const Color(0xFFD2691E);
  // static Color cocoaBrown2 = const Color(0x11D2691E);
  // static Color grey = const Color(0xFF646464);
  // static Color silver = const Color(0xFFCCCACA);
  // static Color antiFlashWhite = const Color(0xFFECECEC);
  // static Color russet = const Color(0xFF141115);
  // static Color russet_O90 = const Color(0xE6141115);
  // static Color seasalt = const Color(0xFFF8FAFC);
  // static Color white = Colors.white;
  // static const Color tomato = Color(0xFFFD3A39);
  //
  // static BorderRadius topBorderRadius = BorderRadius.only(
  //     topLeft: Radius.circular(10), topRight: Radius.circular(10));
  //
  //
  // static BorderRadius allBorderRadius = BorderRadius.all(Radius.circular(10));
  //
  // static TextStyle snackBarStyleTablet = TextStyle(fontSize: 13.sp);
  // static TextStyle snackBarStyle = TextStyle(fontSize: 15.sp);
  //
  // static TextStyle inputFieldStyleTablet = TextStyle(fontSize: 10.sp);
  // static TextStyle inputFieldErrorStyleTablet = TextStyle(fontSize: 10.sp);
}
