import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  //visual settings
  Color appThemeColor = Colors.greenAccent.shade400;
  double blurOverlayOpacity = 0.6;
  double pageMarginVertical = 16;
  double pageMarginHorizontal = 16;
  //page animation settings
  Duration transitionDuration = const Duration(milliseconds: 650);
  Duration reverseTransitionDuration = const Duration(milliseconds: 650);

  //dismiss page settings
  Duration reverseDuration = const Duration(milliseconds: 500);
}
