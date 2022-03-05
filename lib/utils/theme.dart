import 'dart:ui';

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: const Color(0XFFE3F6FD),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0XFFE8DEF5),
    onSecondary: const Color(0XFFF1F1F1),
    onPrimary: Colors.black,
    error: const Color(0XFFE83A14),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(color: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0XFF1E1E1E),
  primaryColor: const Color(0XFFE3F6FD),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0XFFE8DEF5),
    onSecondary: const Color(0XFFF1F1F1),
    onPrimary: Colors.black,
    error: const Color(0XFFE83A14),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0XFF1E1E1E),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0XFFF1F1F1),
    ),
  ),
);
