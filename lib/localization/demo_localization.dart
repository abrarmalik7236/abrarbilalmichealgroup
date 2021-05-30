import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DemoLocalizations{
  final Locale locale;
  DemoLocalizations(this.locale);

  static DemoLocalizations of(BuildContext context){
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  Map<String,String> _localizedvalues;

  Future load() async {
    String jsonStringValues = await rootBundle.loadString("lib/lang/${locale.languageCode}.json");

    Map<String,dynamic> rappedjson = json.decode(jsonStringValues);

    _localizedvalues = rappedjson.map((key, value) => MapEntry(key,value.toString()));
  }

  String gettranslatedValue(String key){
    return _localizedvalues[key];
  }

  static const LocalizationsDelegate<DemoLocalizations> delegate = DemoLocalizationsDelegate();
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) async{
    DemoLocalizations localizations = new DemoLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}