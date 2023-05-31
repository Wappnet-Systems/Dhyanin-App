import 'package:flutter/material.dart';

class ColorsThemeNotifier extends ChangeNotifier {
  Color primaryColor = Color(0xFFF06292);
  Color backgroundColor = Color(0xFFFFFFFF);
  Color secondaryColor1 = Color(0xFFFFF6F9);
  Color secondaryColor2 = Color(0xffc5236e);

  void selectTheme(int newThemeIndex) {
    if (newThemeIndex == 1) {
      primaryColor = Color(0xFFF06292);
      backgroundColor = Color(0xFFFFF5F9);
      secondaryColor1 = Color(0xFFFFE3F0);
      secondaryColor2 = Color(0xffc5236e);
    } else if (newThemeIndex == 2) {
      primaryColor = Color(0xFF4DB6AC);
      backgroundColor = Color(0xFFEAFDFB);
      secondaryColor1 = Color(0xFFE0F2E9);
      secondaryColor2 = Color(0xFF00A6BD);
    } else if (newThemeIndex == 3) {
      primaryColor = Color(0xFF81C784);
      backgroundColor = Color(0xFFF5F5F5);
      secondaryColor1 = Color(0xFFE0F1FF);
      secondaryColor2 = Color(0xFF20B993);
    } else if (newThemeIndex == 4) {
      primaryColor = Color(0xFF64B5F6);
      backgroundColor = Color(0xFFF5F5F5);
      secondaryColor1 = Color(0xFFF1EDFF);
      secondaryColor2 = Color(0xFF739EEA);
    } else {
      primaryColor = Color(0xFF9575CD);
      backgroundColor = Color(0xFFFCF8FF);
      secondaryColor1 = Color(0xFFFAEAFF);
      secondaryColor2 = Color(0xFF4F7FD1);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
