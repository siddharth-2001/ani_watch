import 'dart:ui';
import 'package:flutter/material.dart';

class BlurImageBackground extends StatelessWidget {
  final String image;
  final bool isAsset;

  const BlurImageBackground({super.key, required this.image, required this.isAsset});

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
              sigmaX: 25,
              sigmaY: 25,
            ),
            child: isAsset
                ? Image.asset(
                    image,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Container(
          height: size.height,
          width: size.width,
          color: Colors.black.withOpacity(0.7),
        ),
      ],
    );
  }
}
