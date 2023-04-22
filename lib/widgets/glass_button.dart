import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GlassButton extends StatelessWidget {
  final Icon icon;
  final Function()? function;

  const GlassButton({super.key, required this.icon, required this.function});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
        enableLongTapRepeatEvent: false,
        longTapRepeatDuration: const Duration(milliseconds: 100),
        begin: 1.0,
        end: 0.93,
        beginDuration: const Duration(milliseconds: 20),
        endDuration: const Duration(milliseconds: 120),
        beginCurve: Curves.decelerate,
        endCurve: Curves.fastOutSlowIn,
        child: GlassContainer(
          height: 60,
          width: 60,
          blur: 9,
          color: Colors.black.withOpacity(0.2),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Colors.white.withOpacity(0.2),
          //     Colors.blue.withOpacity(0.3),
          //   ],
          // ),
          //--code to remove border
          border: const Border.fromBorderSide(BorderSide.none),
          shadowStrength: 5,
          // // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(24),
          shadowColor: Colors.white.withOpacity(0.24),
          child: IconButton(
              onPressed: function,
              icon: icon,
              style: const ButtonStyle(splashFactory: NoSplash.splashFactory)),
        ));
  }
}
