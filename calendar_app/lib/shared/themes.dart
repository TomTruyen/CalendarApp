import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blueColor = Color(0xFF4e5ae8);
const Color yellowolor = Color(0xFFFFB746);
const Color pinkColor = Color(0xFFFF4667);
const Color darkGreyColor = Color(0xFF121212);

class Themes {
  static const lightPrimary = blueColor;
  static const darkPrimary = darkGreyColor;

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

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.black,
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
      color: Colors.black,
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
