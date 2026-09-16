import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/storage_config.dart';
import '../models/language.dart';
// import '../config/theme.dart';

class ThemeModeController extends GetxController {
  static late Rx<ThemeData> _themeMode;
  static late BuildContext _context;
  ThemeModeController(BuildContext context) {
    _context = context;
  }
  @override
  void onInit() {
    super.onInit();
    // _themeMode = appTheme(
    //   _context,
    //   isDark: !ConfigPreference.getThemeIsLight(),
    // ).obs;
    // isLightTheme = ConfigPreference.getThemeIsLight().obs;
    // print('SET THEME: ${ConfigPreference.getThemeIsLight()}');
  }

  // static late RxBool isLightTheme;
  //
  // static ThemeData getThemeMode() => _themeMode.value;
  // static void setThemeMode(ThemeData value) {
  //   _themeMode.value = value;
  //   isLightTheme.value = isCurrentlyLight();
  // }

  // static bool isCurrentlyLight() =>
  //     _themeMode.value == appTheme(_context, isDark: false);
  // static void toggleThemeMode() {
  //   bool isCurrentlyLight =
  //       _themeMode.value == appTheme(_context, isDark: false);
  //   setThemeMode(appTheme(_context, isDark: isCurrentlyLight));
  //   ConfigPreference.setThemeIsLight(!isCurrentlyLight);
  //   Logger().d(isCurrentlyLight);
  // }

  static Locale getLocale() {
    String lang = ConfigPreference.getLanguage();
    if (lang == 'am') return const Locale('am');
    if (lang == 'or') return const Locale('it');
    if (lang == 'ti') return const Locale('en', 'AU');
    return const Locale('en');
  }

  static final RxString languageC = RxString(
    ConfigPreference.getLanguage() == 'en'
        ? 'English'
        : ConfigPreference.getLanguage() == 'am'
        ? 'አማርኛ'
        : ConfigPreference.getLanguage() == 'ti'
        ? 'ትግርኛ'
        : 'Oromiffa',
  );

  static String getLanguage() {
    return languageC.value;
  }

  static RxString languageCode = ConfigPreference.getLanguage().obs;
  static void saveLanguage(Locale language) {
    String code = language.languageCode;
    if (language.languageCode == 'it') {
      code = 'or';
    } else if (language.languageCode == 'en' && language.countryCode == 'AU') {
      code = 'ti';
    }

    ConfigPreference.setLanguage(code);
    languageC.value = code == 'en'
        ? 'English'
        : code == 'am'
        ? 'አማርኛ'
        : code == 'ti'
        ? 'ትግርኛ'
        : 'Oromiffa';

    // Update Language model to keep it in sync
    try {
      Language.selectedLanguage = Language.languages.firstWhere(
        (l) =>
            l.code.languageCode == language.languageCode &&
            l.code.countryCode == language.countryCode,
      );
    } catch (e) {
      Language.selectedLanguage = Language.languages.firstWhere(
        (l) => l.code.languageCode == language.languageCode,
        orElse: () => Language.languages.last,
      );
    }

    languageCode.value = code;
  }
}
