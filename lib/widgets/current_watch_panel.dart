import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dismissible_page/dismissible_page.dart';

//local imports
import '../screens/watch_episode_screen.dart';

//provider imports
import '../provider/settings.dart';

class CurrentWatchPanel extends StatelessWidget {
  final String id, episodeIndex, name, image;

  const CurrentWatchPanel(
      {super.key,
      required this.id,
      required this.episodeIndex,
      required this.name,
      required this.image});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final appSettings = Provider.of<AppSettings>(context);

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
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
                  WatchEpisodeScreen(
                    id: id,
                    tag: "watch",
                    index: int.parse(episodeIndex),
                  ));
            },
            child: Container(
              height: screen.height * 0.22,
              clipBehavior: Clip.hardEdge,
              width: screen.width * 0.9,
              decoration: ShapeDecoration(shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(cornerRadius: 24, cornerSmoothing: 1)
                      )),
              child: Stack(
                children: [
                  Hero(
                    tag: "${id}watch",
                    child: Container(
                      height: screen.height * 0.22,
                    
                      width: screen.width * 0.9,
  
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
                            tileMode: TileMode.decal, sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: screen.width * 0.9,
                          color: Colors.black.withOpacity(0.2),
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  "Episode: ${int.parse(episodeIndex) + 1}",
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
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
        ));
  }
}
