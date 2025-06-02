import 'package:flutter/material.dart';

import '../../utils/images.dart';
import '../providers/colors_theme_provider.dart';

String selectLottiePath(ColorsThemeNotifier provider) {
  if (provider.primaryColor == Color(0xFFF06292)) {
    return emptyHistoryListPink;
  } else if (provider.primaryColor == Color(0xFF4DB6AC)) {
    return emptyHistoryListTeal;
  } else if (provider.primaryColor == Color(0xFF81C784)) {
    return emptyHistoryListGreen;
  } else if (provider.primaryColor == Color(0xFF64B5F6)) {
    return emptyHistoryListBlue;
  }
  return emptyHistoryListPurple;
}
