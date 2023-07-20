import 'dart:ui';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:provider/provider.dart';
import 'package:figma_squircle/figma_squircle.dart';

//local imports
import '../screens/show_detail_screen.dart';

//provider imports
import '../provider/settings.dart';

class GlassShowPanel extends StatelessWidget {
  final String id, image, name, episodes, tag;

  const GlassShowPanel(
      {super.key,
      required this.id,
      required this.tag,
      required this.name,
      required this.image,
      required this.episodes});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = 11 / 18;
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final width =
        size.width > size.height ? size.width * 0.1 : size.width * 0.3;
    final height =
        size.width > size.height ? size.height * 0.3 : size.height * 0.2;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 4),
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
                ShowDetailScreen(id: id, image: image, tag: tag));
          },
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(14, 18),
                    spreadRadius: -20,
                    blurRadius: 38,
                    color: Colors.black.withOpacity(0.5),
                  )
                ],
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 16,
                  cornerSmoothing: 1,
                ),
              ),
              child: LayoutBuilder(
                builder: (p0, p1) => 
                Stack(
                  children: [
                    Hero(
                      tag: id + tag,
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
                            sigmaY: 10,
                          ),
                          child: Container(
                            height: 32,
                            color: Colors.black.withOpacity(0.4),
                            width: p1.maxWidth,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 14),
                                child: Text(
                                  name,
                                  // textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
      ),
    );
  }
}
