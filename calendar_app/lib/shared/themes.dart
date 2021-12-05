import 'package:flutter/material.dart';

const Color blueColor = Color(0xFF4e5ae8);
const Color yellowolor = Color(0xFFFFB746);
const Color pinkColor = Color(0xFFFF4667);
const Color darkGreyColor = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);

class Themes {
  static const lightStatus = blueColor;
  static const darkStatus = darkHeaderColor;

  static final light = ThemeData(
    primaryColor: blueColor,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(backgroundColor: blueColor),
  );

  static final dark = ThemeData(
    primaryColor: darkGreyColor,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkHeaderColor,
    ),
  );
}
