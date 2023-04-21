import 'dart:ui';
import 'package:flutter/material.dart';

class BlurImageBackground extends StatelessWidget {
  final String image;
  const BlurImageBackground({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              tileMode: TileMode.decal,
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: size.height,
          width: size.width,
          color: Colors.black.withOpacity(0.5),
        ),
      ],
    );
  }
}
