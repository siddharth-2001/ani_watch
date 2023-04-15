import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class GlassWidget extends StatelessWidget {
  late double _height, _width;
  late Widget _child;
  late Color _color;

  GlassWidget(
      {required double height,
      required double width,
      required Widget child,
      required Color color}) {
    _height = height;
    _width = width;
    _child = child;
    _color = color;
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        height: _height,
        width: _width,
        blur: 9,
        color: _color.withOpacity(0.2),
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
        child: _child);
  }
}
