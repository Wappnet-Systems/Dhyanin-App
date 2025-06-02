import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/providers/colors_theme_provider.dart';

class CustomSnackbar {
  CustomSnackbar();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      functionSnackbar(BuildContext context, String text) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: false);
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: model.primaryColor.withOpacity(0.6),
    ));
  }
}
