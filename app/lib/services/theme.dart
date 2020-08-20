import 'package:flutter/material.dart';

ThemeData basicTheme(){
  TextTheme basicTextTheme(TextTheme base){
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
        color: Colors.white
      ),
      headline2: base.headline2.copyWith(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 18
      ),
      headline3: base.headline3.copyWith(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.bold,
        fontSize: 12.0,
        color: Colors.white
      ),
      headline4: base.headline4.copyWith(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.normal,
        fontSize: 10.0,
        color: Colors.grey
      ),
      headline6: base.headline6.copyWith(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 12
      ),
      subtitle1: base.subtitle1.copyWith(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        fontSize: 14
      ),
      subtitle2: base.subtitle2.copyWith(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 14
      ),
    );
  }
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: basicTextTheme(base.textTheme),
    primaryColor: Colors.black
  );
}