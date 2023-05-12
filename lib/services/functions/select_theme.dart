import 'package:flutter/material.dart';

import '../../utils/colors.dart';

void selectTheme(int themeIndex) {
  if (themeIndex == 1) {
    primaryColor = Color(0xffDE0CA3);
    backgroundColor = Color(0xfff6ddfa);
    secondaryColor1 = Color.fromARGB(255, 255, 207, 241);
    secondaryColor2 = Color(0xffc5236e);
  } else if (themeIndex == 2) {
    primaryColor = Colors.red;
    backgroundColor = Color.fromARGB(255, 240, 209, 207);
    secondaryColor1 = Color.fromARGB(255, 255, 202, 198);
    secondaryColor2 = Color.fromARGB(255, 255, 144, 134);
  } else if (themeIndex == 3) {
    primaryColor = Colors.green;
    backgroundColor = Color.fromARGB(255, 217, 251, 217);
    secondaryColor1 = Color.fromARGB(255, 210, 255, 211);
    secondaryColor2 = Color.fromARGB(255, 111, 235, 115);
  } else if (themeIndex == 4) {
    primaryColor = Colors.blue;
    backgroundColor = Color.fromARGB(255, 194, 221, 244);
    secondaryColor1 = Color.fromARGB(255, 176, 212, 240);
    secondaryColor2 = Color.fromARGB(255, 88, 129, 162);
  } else {
    primaryColor = Colors.purple;
    backgroundColor = Color.fromARGB(255, 245, 213, 251);
    secondaryColor1 = Color.fromARGB(255, 235, 181, 244);
    secondaryColor2 = Color.fromARGB(255, 140, 84, 150);
  }
}
