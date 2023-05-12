import 'package:flutter/material.dart';

import '../utils/colors.dart';

Widget MyHeaderDrawer(BuildContext context) {
  return Container(
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      padding: EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Settings',
            style: TextStyle(
                color: Theme.of(context).colorScheme.background, fontSize: 25),
          )));
}
