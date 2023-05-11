import 'package:flutter/material.dart';

class AudioIcon extends StatelessWidget {
  Icon icon;
  Function onPress;
  AudioIcon({super.key, required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor:
          const Color.fromARGB(255, 239, 101, 200).withOpacity(0.8),
      child: IconButton(
          icon: icon,
          iconSize: 40,
          onPressed: () async {
            onPress();
          }),
    );
  }
}
