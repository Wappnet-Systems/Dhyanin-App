import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManagerProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool isDark = false;

  get themeMode => _themeMode;

  Future<void> checkThemeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  Future<void> changeTheme() async {
    isDark = !isDark;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
    notifyListeners();
  }

  toggleTheme(isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
