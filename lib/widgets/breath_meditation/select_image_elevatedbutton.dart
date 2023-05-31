import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/colors_theme_provider.dart';

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
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: model.primaryColor,
          ),
          onPressed: () {
            onPress();
          },
          icon: icon,
          label: Text(label)),
    );
  }
}
