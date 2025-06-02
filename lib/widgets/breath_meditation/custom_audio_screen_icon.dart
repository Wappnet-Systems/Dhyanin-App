import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/colors_theme_provider.dart';

class AudioIcon extends StatelessWidget {
  final Icon icon;
  final Function onPress;
  const AudioIcon({super.key, required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return CircleAvatar(
      radius: 35,
      backgroundColor: model.secondaryColor2.withOpacity(0.6),
      child: IconButton(
          icon: icon,
          iconSize: 40,
          onPressed: () async {
            onPress();
          }),
    );
  }
}
