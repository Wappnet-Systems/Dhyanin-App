import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/providers/colors_theme_provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return AppBar(
      centerTitle: true,
      backgroundColor: model.primaryColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: model.backgroundColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: model.backgroundColor),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
