import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

//Project title
const String projectTitle = 'Dhyanin';

//textstyles
const TextStyle headingStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.w500);
const TextStyle bodyStyle = TextStyle(fontSize: 22);
const TextStyle sliderText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
);

//audio files urls for assets
const String audio1 = "audios/audio1.m4a";
const String audio2 = "audios/audio2.m4a";
const String audio3 = "audios/audio3.m4a";
const String audio4 = "audios/audio4.m4a";
const String audio5 = "audios/audio5.m4a";

//Theme constants
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: background_color,
  primaryColor: primary_color,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: primary_color).copyWith(
      primary: primary_color,
      onSurface: Colors.black,
      // secondary: PrimaryColor.color_black,
      background: background_color,
      // onBackground: PrimaryColor.color_bottle_green,
      brightness: Brightness.light),
  cardColor: Color(0xFFFFD8F4),
  hintColor: Colors.black38,
  dialogBackgroundColor: background_color,
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColor: Colors.white,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: primary_color).copyWith(
      primary: Colors.white,
      onSurface: Colors.white,
      // secondary: PrimaryColor.color_black,
      background: Colors.grey.shade900,
      // onBackground: PrimaryColor.color_bottle_green,
      brightness: Brightness.dark),
  cardColor: primary_color,
  hintColor: Colors.black38,
  dialogBackgroundColor: Color.fromARGB(255, 185, 6, 131),
);
