import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ImageElevatedButton extends StatelessWidget {
  final Function onPress;
  final Icon icon;
  final String label;
  ImageElevatedButton(
      {super.key,
      required this.onPress,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          onPressed: () {
            onPress();
          },
          icon: icon,
          label: Text(label)),
    );
  }
}
