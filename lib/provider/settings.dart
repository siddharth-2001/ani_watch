import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  //page animation settings
  Duration transitionDuration = const Duration(milliseconds: 500);
  Duration reverseTransitionDuration = const Duration(milliseconds: 500);
}
