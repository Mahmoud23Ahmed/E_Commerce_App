import 'package:flutter/material.dart';

final primaryColor = Color(0xff035696);
final secondaryColor = Color(0xffc8e6c9);

final appTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Color(0xff035696),
    ),
    bodyLarge: TextStyle(
      fontSize: 20.0,
      color: Colors.grey[800],
    ),
    bodyMedium: const TextStyle(
      fontSize: 16.0,
      color: Colors.grey,
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: secondaryColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: TextStyle(color: primaryColor),
    iconColor: secondaryColor,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xff035696),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xff035696),
    textTheme: ButtonTextTheme.primary,
  ),
);
