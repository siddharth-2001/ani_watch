import 'dart:ui';
import 'package:flutter/material.dart';

class BlurImageBackground extends StatelessWidget {
  final String image;
  final Image localImage = Image.asset("assets/bg2.jpg", fit: BoxFit.cover,);
  BlurImageBackground({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height: size.height,
          width: size.width,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              tileMode: TileMode.decal,
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: image == "none" ? localImage : Image.network(
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
