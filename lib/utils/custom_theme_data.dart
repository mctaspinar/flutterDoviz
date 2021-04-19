import 'package:flutter/material.dart';

class CustomThemeData {
  static final val = ThemeData(
    primarySwatch: Colors.blueGrey,
    accentColor: Colors.indigo.shade200,
    errorColor: Colors.deepOrange,
    fontFamily: 'Raleway',
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontWeight: FontWeight.w200,
        color: Colors.black,
        fontSize: 20,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontSize: 18,
      ),
      headline5: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 22,
      ),
      headline6: TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 24,
      ),
    ),
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          headline6: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Raleway',
            fontSize: 24,
          ),
        ),
        color: Colors.blueGrey,
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.white,
        )),
  );
}
