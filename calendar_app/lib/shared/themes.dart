import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color lightThemePrimary = Color(0xFF4e5ae8);
const Color darkThemePrimary = Color(0xFFBA86FC);
const Color yellowolor = Color(0xFFFFB746);
const Color pinkColor = Color(0xFFFF4667);
const Color darkGreyColor = Color(0xFF121212);

class Themes {
  static const lightStatus = Colors.white;
  static const darkStatus = darkGreyColor;

  static final light = ThemeData(
    primaryColor: lightThemePrimary,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
  );

  static final dark = ThemeData(
    primaryColor: darkThemePrimary,
    brightness: Brightness.dark,
    backgroundColor: darkGreyColor,
    scaffoldBackgroundColor: darkGreyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGreyColor,
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
  );
}
