import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: backgroundColor,
  primaryColor: primaryColor,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
      primary: primaryColor,
      onSurface: Colors.black,
      // secondary: PrimaryColor.color_black,
      background: backgroundColor,
      // onBackground: PrimaryColor.color_bottle_green,
      brightness: Brightness.light),
  cardColor: secondaryColor1,
  hintColor: Colors.black38,
  dialogBackgroundColor: backgroundColor,
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColor: Colors.white,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
      primary: Colors.white,
      onSurface: Colors.white,
      // secondary: PrimaryColor.color_black,
      background: Colors.grey.shade900,
      // onBackground: PrimaryColor.color_bottle_green,
      brightness: Brightness.dark),
  cardColor: primaryColor,
  hintColor: Colors.black38,
  dialogBackgroundColor: Colors.grey.shade800,
  // dialogBackgroundColor: Color.fromARGB(255, 185, 6, 131),
);
