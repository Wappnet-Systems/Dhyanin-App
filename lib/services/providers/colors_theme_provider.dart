import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorsThemeNotifier extends ChangeNotifier {
  Color primaryColor = Color(0xffDE0CA3);
  Color backgroundColor = Color(0xfff6ddfa);
  Color secondaryColor1 = Color.fromARGB(255, 255, 207, 241);
  Color secondaryColor2 = Color(0xffc5236e);

  void selectTheme(int newThemeIndex) {
    if (newThemeIndex == 1) {
      primaryColor = Color(0xffDE0CA3);
      backgroundColor = Color(0xfff6ddfa);
      secondaryColor1 = Color.fromARGB(255, 255, 207, 241);
      secondaryColor2 = Color(0xffc5236e);
    } else if (newThemeIndex == 2) {
      primaryColor = Colors.red;
      backgroundColor = Color.fromARGB(255, 248, 222, 222);
      secondaryColor1 = Color.fromARGB(255, 255, 202, 198);
      secondaryColor2 = Color.fromARGB(255, 255, 144, 134);
    } else if (newThemeIndex == 3) {
      primaryColor = Colors.green;
      backgroundColor = Color.fromARGB(255, 225, 243, 225);
      secondaryColor1 = Color.fromARGB(255, 210, 255, 211);
      secondaryColor2 = Color.fromARGB(255, 111, 235, 115);
    } else if (newThemeIndex == 4) {
      primaryColor = Colors.blue;
      backgroundColor = Color.fromARGB(255, 207, 225, 240);
      secondaryColor1 = Color.fromARGB(255, 176, 212, 240);
      secondaryColor2 = Color.fromARGB(255, 88, 129, 162);
    } else {
      primaryColor = Colors.purple;
      backgroundColor = Color.fromARGB(255, 242, 209, 248);
      secondaryColor1 = Color.fromARGB(255, 235, 181, 244);
      secondaryColor2 = Color.fromARGB(255, 140, 84, 150);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
