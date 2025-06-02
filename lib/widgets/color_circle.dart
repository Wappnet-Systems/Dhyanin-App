import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/providers/colors_theme_provider.dart';

class ColorCircle extends StatelessWidget {
  final Color color;
  final int themeIndex;
  ColorCircle(this.color, this.themeIndex);

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier colorsModel =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('theme', themeIndex);
        colorsModel.selectTheme(themeIndex);
        Navigator.of(context).pop();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white),
          color: color,
        ),
      ),
    );
  }
}
