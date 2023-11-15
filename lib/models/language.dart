import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Language {
  final String name;
  final Locale code;

  Language(this.name, this.code);

  static List<Language> languages = [
        Language('አማርኛ', const Locale('am')),
        Language('Afan Oromoo', const Locale('en', 'GB')),
        Language('ትግርኛ', const Locale('en', 'AU')),
        Language('English', const Locale('en'))
      ];

  static Language selectedLanguage = Language('English', const Locale('en'));

  static Language getSelectedLanguage(BuildContext context) {
    final Locale currentLocale = context.locale;
    final Language lang  = languages.firstWhere((language) => language.code == currentLocale,
        orElse: () => languages.first);
    return lang;
  }

  static String getLocaleCode(){
    if(selectedLanguage == languages[0]){
      return "am";
    } else if (selectedLanguage == languages[1]){
      return "om";
    } else if (selectedLanguage == languages[2]){
      return "ti";
    } else {
      return "en";
    }
  }

  
}
