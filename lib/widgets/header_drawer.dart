import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/providers/colors_theme_provider.dart';

Widget MyHeaderDrawer(BuildContext context) {
  ColorsThemeNotifier model =
      Provider.of<ColorsThemeNotifier>(context, listen: true);
  return Container(
      color: model.primaryColor,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      padding: EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontSize: 25),
          )));
}
