import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomSnackbar {
  CustomSnackbar();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      functionSnackbar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: primary_color.withOpacity(0.6),
    ));
  }
}
