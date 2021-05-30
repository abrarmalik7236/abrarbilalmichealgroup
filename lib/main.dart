import 'package:departure/HomePage.dart';
import 'package:departure/routes/custom_router.dart';
import 'package:departure/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization/demo_localization.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setlocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setlocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void initState() {
    super.initState();
  }

  void setlocale(Locale locale){
    setState((){
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: CustomRouter.allRoutes,
        initialRoute: homeRoute,
        supportedLocales: [Locale('ar', 'AE'), Locale('en', 'US')],
        localizationsDelegates: [
          DemoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (devicelocal, supportedlocals) {
          for (var locale in supportedlocals) {
            if (locale.languageCode == devicelocal.languageCode &&
                locale.countryCode == devicelocal.countryCode) {
              return devicelocal;
            }
          }
          return supportedlocals.first;
        },
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        locale: _locale,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/test22.jpg"), fit: BoxFit.cover)),
          child: MyHomePage(),
        ));
  }
}



/*
import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Departure',
      home: MyHomePage(),
    );
  }
}

 */


