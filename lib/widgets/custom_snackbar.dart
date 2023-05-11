import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  CustomSnackbar();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      functionSnackbar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: primaryColor.withOpacity(0.6),
    ));
  }
}
