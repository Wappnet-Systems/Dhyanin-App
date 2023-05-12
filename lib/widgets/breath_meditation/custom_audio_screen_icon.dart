import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

class AudioIcon extends StatelessWidget {
  Icon icon;
  Function onPress;
  AudioIcon({super.key, required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: primaryColor.withOpacity(0.6),
      child: IconButton(
          icon: icon,
          iconSize: 40,
          onPressed: () async {
            onPress();
          }),
    );
  }
}
