import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:provider/provider.dart';
//local imports
import '../screens/show_detail_screen.dart';

//PROVIDER IMPORTS
import '../provider/settings.dart';

class GlassRecentPanel extends StatelessWidget {
  final String id, episodes, name, image;

  const GlassRecentPanel(
      {super.key,
      required this.id,
      required this.episodes,
      required this.name,
      required this.image});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final appSettings = Provider.of<AppSettings>(context);
    final aspectRatio = 1 / 1;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ZoomTapAnimation(
          enableLongTapRepeatEvent: false,
          longTapRepeatDuration: const Duration(milliseconds: 100),
          begin: 1.0,
          end: 0.93,
          beginDuration: const Duration(milliseconds: 20),
          endDuration: const Duration(milliseconds: 120),
          beginCurve: Curves.decelerate,
          endCurve: Curves.fastOutSlowIn,
          child: GestureDetector(
            onTap: () {
              context.pushTransparentRoute(
                  transitionDuration: appSettings.transitionDuration,
                  reverseTransitionDuration:
                      appSettings.reverseTransitionDuration,
                  ShowDetailScreen(id: id, image: image, tag: "recents"));
            },
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 24, cornerSmoothing: 1))),
                child: LayoutBuilder(
                  builder: (p0, p1) => Stack(
                    children: [
                      Hero(
                        tag: "${id}recents",
                        child: AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                tileMode: TileMode.decal,
                                sigmaX: 10,
                                sigmaY: 10),
                            child: Container(
                              width: p1.maxWidth,
                              color: Colors.black.withOpacity(0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Episode: ${int.parse(episodes)}",
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
