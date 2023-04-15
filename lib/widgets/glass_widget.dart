import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class GlassWidget extends StatelessWidget {
  final double height, width;
  final Widget child;
  final Color color;

  const GlassWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.child,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        height: height,
        width: width,
        blur: 9,
        color: color.withOpacity(0.2),
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
        // shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(32),
        shadowColor: Colors.black.withOpacity(0.24),
        child: child);
  }
}
