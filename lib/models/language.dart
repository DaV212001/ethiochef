import 'package:flutter/material.dart';

import '../config/storage_config.dart';

class Language {
  final String name;
  final Locale code;

  Language(this.name, this.code);

  static List<Language> languages = [
    Language('አማርኛ', const Locale('am')),
    Language('Afan Oromoo', const Locale('it')),
    // Language('ትግርኛ', const Locale('en', 'AU')),
    Language('English', const Locale('en')),
  ];

  static Language selectedLanguage = Language('English', const Locale('en'));

  static Language getSelectedLanguage(BuildContext context) {
    String lang = ConfigPreference.getLanguage();
    return languages.firstWhere(
      (language) {
        String code = language.code.languageCode;
        if (code == 'it') return lang == 'or';
        if (code == 'en' && language.code.countryCode == 'AU')
          return lang == 'ti';
        return code == lang;
      },
      orElse: () => languages.last, // Default to English
    );
  }

  static String getLocaleCode() {
    return ConfigPreference.getLanguage();
  }
}
