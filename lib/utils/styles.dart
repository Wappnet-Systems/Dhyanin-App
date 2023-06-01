import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:flutter/material.dart';

const TextStyle headingStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.w500);
const TextStyle bodyStyle = TextStyle(fontSize: 22);
const TextStyle sliderText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
);

//text style for sessions card title
const TextStyle sessionStyleHeading =
    TextStyle(fontWeight: FontWeight.normal, fontSize: 16);
const TextStyle sessionStyleBody =
    TextStyle(fontWeight: FontWeight.w300, fontSize: 16);

//Box decoration for gradient styles
BoxDecoration topLeftToBottomRightGradient(ColorsThemeNotifier provider) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        provider.primaryColor,
        provider.secondaryColor1,
        provider.secondaryColor1,
        provider.primaryColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

BoxDecoration leftToRightGradient(
    ColorsThemeNotifier provider, int value, int index) {
  return BoxDecoration(
    gradient: (value == index)
        ? LinearGradient(
            colors: [
              provider.secondaryColor2,
              provider.primaryColor,
              provider.secondaryColor1,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
        : null,
    borderRadius: BorderRadius.circular(10),
  );
}

LinearGradient rightToLeftGradient(ColorsThemeNotifier provider) {
  return LinearGradient(
    colors: [
      provider.secondaryColor1,
      provider.primaryColor,
      provider.secondaryColor2,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
