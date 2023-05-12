import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorsThemeNotifier extends ChangeNotifier {
  Color primaryColorProvider = Color(0xffDE0CA3);
  Color backgroundColorProvider = Color(0xfff6ddfa);
  Color secondaryColor1Provider = Color.fromARGB(255, 255, 207, 241);
  Color secondaryColor2Provider = Color(0xffc5236e);

  void selectTheme(int newThemeIndex) {
    if (newThemeIndex == 1) {
      primaryColorProvider = Color(0xffDE0CA3);
      backgroundColorProvider = Color(0xfff6ddfa);
      secondaryColor1Provider = Color.fromARGB(255, 255, 207, 241);
      secondaryColor2Provider = Color(0xffc5236e);
    } else if (newThemeIndex == 2) {
      primaryColorProvider = Colors.red;
      backgroundColorProvider = Color.fromARGB(255, 240, 209, 207);
      secondaryColor1Provider = Color.fromARGB(255, 255, 202, 198);
      secondaryColor2Provider = Color.fromARGB(255, 255, 144, 134);
    } else if (newThemeIndex == 3) {
      primaryColorProvider = Colors.green;
      backgroundColorProvider = Color.fromARGB(255, 217, 251, 217);
      secondaryColor1Provider = Color.fromARGB(255, 210, 255, 211);
      secondaryColor2Provider = Color.fromARGB(255, 111, 235, 115);
    } else if (newThemeIndex == 4) {
      primaryColorProvider = Colors.blue;
      backgroundColorProvider = Color.fromARGB(255, 194, 221, 244);
      secondaryColor1Provider = Color.fromARGB(255, 176, 212, 240);
      secondaryColor2Provider = Color.fromARGB(255, 88, 129, 162);
    } else {
      primaryColorProvider = Colors.purple;
      backgroundColorProvider = Color.fromARGB(255, 245, 213, 251);
      secondaryColor1Provider = Color.fromARGB(255, 235, 181, 244);
      secondaryColor2Provider = Color.fromARGB(255, 140, 84, 150);
    }
    primaryColor = primaryColorProvider;
    backgroundColor = backgroundColorProvider;
    secondaryColor1 = secondaryColor1Provider;
    secondaryColor2 = secondaryColor2Provider;
    notifyListeners();
  }
}
