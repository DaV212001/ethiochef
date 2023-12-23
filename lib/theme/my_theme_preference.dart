import 'package:shared_preferences/shared_preferences.dart';

class MyThemePreferences {
  static const THEME_KEY = "theme_key";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_KEY, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_KEY) ?? false;
  }

}
class LanguagePreferences {
  static const LANGUAGE_STATUS = "languageStatus";

  setLanguage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LANGUAGE_STATUS, value);
  }

  Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LANGUAGE_STATUS) ?? 'en';
  }
}