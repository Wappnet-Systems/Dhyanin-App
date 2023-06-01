import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:flutter/material.dart';

ThemeData buildCustomThemeData({
  required Color scaffoldBackgroundColor,
  required Color primaryColor,
  required Brightness brightness,
  required ColorScheme colorScheme,
  required Color cardColor,
  required Color hintColor,
  required Color dialogBackgroundColor,
}) {
  return ThemeData(
    fontFamily: 'ubuntu',
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    primaryColor: primaryColor,
    brightness: brightness,
    colorScheme: colorScheme,
    cardColor: cardColor,
    hintColor: hintColor,
    dialogBackgroundColor: dialogBackgroundColor,
  );
}

// Create a function that returns the light theme using the colors from the provider
ThemeData getLightThemeFromProvider(ColorsThemeNotifier provider) {
  return buildCustomThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: provider.primaryColor,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: provider.primaryColor)
        .copyWith(
            primary: provider.primaryColor,
            onSurface: Colors.black,
            background: provider.secondaryColor1,
            onPrimary: Colors.black,
            onBackground: Colors.transparent,
            brightness: Brightness.light),
    cardColor: provider.secondaryColor1,
    hintColor: Colors.black38,
    dialogBackgroundColor: provider.secondaryColor1,
  );
}

// Create a function that returns the dark theme using the colors from the provider
ThemeData getDarkThemeFromProvider(ColorsThemeNotifier provider) {
  return buildCustomThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: provider.primaryColor)
        .copyWith(
            primary: Colors.white,
            onSurface: Colors.white,
            background: Colors.grey.shade900,
            onPrimary: Colors.white,
            onBackground: provider.backgroundColor,
            brightness: Brightness.dark),
    cardColor: provider.secondaryColor1,
    hintColor: Colors.white.withOpacity(0.6),
    dialogBackgroundColor: Colors.grey.shade800,
  );
}
