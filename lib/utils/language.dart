import 'dart:ui';

import 'package:flutter/material.dart';

import '../main.dart';

class Language {
  final int id;
  final String name, flag, languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, '🇦🇪', 'عربي', 'ar'),
      Language(2, '🇺🇸', 'English', 'en'),
    ];
  }

  static void changeLanguage(BuildContext context, Language language) {
    MyApp.setlocale(context, getLocale(language.languageCode));
  }

  static Language getLanguage(String code) {
    switch (code) {
      case 'ar':
        return Language(1, '🇦🇪', 'عربي', 'ar');
        break;
      case 'en':
        return Language(2, '🇺🇸', 'English', 'en');
        break;

      default:
        return Language(2, '🇺🇸', 'English', 'en');
        break;
    }
  }

  static Locale getLocale(String code) {
    Locale _temp;
    switch (code) {
      case 'ar':
        _temp = Locale(code, 'AE');
        break;
      case 'en':
        _temp = Locale(code, 'US');
        break;

      default:
        _temp = Locale(code, 'AE');
        break;
    }
    return _temp;
  }
}
