import 'package:flutter/material.dart';

import '../theme/my_theme_preference.dart';

class ModelTheme extends ChangeNotifier {
  ///LANGUAGE
  // LanguagePreferences languagePreferences = LanguagePreferences();
  // String _languageCode = 'en';
  // String get languageCode => _languageCode;
  //
  // Future<void> getLanguageCode() async {
  //   languageCode = await languagePreferences.getLanguage();
  // }

  // set languageCode(String value) {
  //   _languageCode = value;
  //   languagePreferences.setLanguage(value);
  //   notifyListeners();
  // }

  ///THEME
  late bool _isDark;
  late MyThemePreferences _preferences;
  bool get isDark => _isDark;

  ModelTheme() {
    _isDark = false;
    _preferences = MyThemePreferences();
    getPreferences();
  }
  //Switching the themes
  set setIsDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
