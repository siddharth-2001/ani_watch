import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  //page animation settings
  Duration transitionDuration = Duration(milliseconds: 500);
  Duration reverseTransitionDuration = Duration(milliseconds: 500);
}
