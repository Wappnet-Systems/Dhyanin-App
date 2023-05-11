import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CheckInternetConnectivity {
  static checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(days: 1),
        dismissDirection: DismissDirection.none,
        action: SnackBarAction(
          label: 'Check Now!',
          textColor: backgroundColor, // or some operation you would like
          onPressed: () {
            checkConnectivity(context);
          },
        ),
        content: Text('Please, Connect to the internet!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor.withOpacity(0.6),
      ));
    }
  }
}
