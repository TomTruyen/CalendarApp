import 'package:flutter/material.dart';

const Color blueColor = Color(0xFF4e5ae8);
const Color yellowolor = Color(0xFFFFB746);
const Color pinkColor = Color(0xFFFF4667);
const Color darkGreyColor = Color(0xFF121212);

class Themes {
  static const lightStatus = Colors.white;
  static const darkStatus = darkGreyColor;

  static final light = ThemeData(
    primaryColor: blueColor,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
  );

  static final dark = ThemeData(
    primaryColor: darkGreyColor,
    brightness: Brightness.dark,
    backgroundColor: darkGreyColor,
    scaffoldBackgroundColor: darkGreyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGreyColor,
    ),
  );
}
