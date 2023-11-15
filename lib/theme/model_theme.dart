import 'package:ethio_chef/theme/my_theme_preference.dart';
import 'package:flutter/material.dart';

class ModelTheme extends ChangeNotifier {
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