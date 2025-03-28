import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  //fontFamily: 'Poppins',
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF131327),
    primaryContainer: Color(0xBE202039),
    primary: Color(0xFF32324B),
    secondary: Color(0xFF49495F),
    tertiary: Color(0xff767687),
    tertiaryFixed: Color(0xFF797C88),
    inversePrimary: Color(0xFFdddde1),
    scrim: Color(0xFF5dfbaf),
    surfaceContainerHighest: Colors.transparent,
    outlineVariant: Color(0xFF5dfbaf),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.red, // Change this to your desired color
    ),
  ),
);

ThemeData lightMode = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0XFFe3e7f3),
    primaryContainer: Color(0xFFeef1f8),
    primary: Color(0XFFC6CFE6),
    secondary: Color(0XFFb2bacf),
    tertiary: Color(0XFF9296a2),
    tertiaryFixed: Color(0XFF757882),
    inversePrimary: Color(0XFF0a0a14),
    scrim: Color(0xff5dfbaf),
    surfaceContainerHighest: Color(0xff5dfbaf),
    outlineVariant: Color(0xff01b173),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.red, // Change this to your desired color
    ),
  ),
);