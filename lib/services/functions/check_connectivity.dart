import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/colors_theme_provider.dart';

class CheckInternetConnectivity {
  static checkConnectivity(BuildContext context) async {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: false);
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(days: 1),
        dismissDirection: DismissDirection.none,
        action: SnackBarAction(
          label: 'Check Now!',
          textColor: model.backgroundColor, // or some operation you would like
          onPressed: () {
            checkConnectivity(context);
          },
        ),
        content: Text('Please, Connect to the internet!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: model.primaryColor.withOpacity(0.6),
      ));
    }
  }
}
