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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screen.width * 0.015),
      child: ZoomTapAnimation(
        enableLongTapRepeatEvent: false,
        longTapRepeatDuration: const Duration(milliseconds: 100),
        begin: 1.0,
        end: 0.93,
        beginDuration: const Duration(milliseconds: 200),
        endDuration: const Duration(milliseconds: 120),
        beginCurve: Curves.decelerate,
        endCurve: Curves.fastOutSlowIn,
        child: GestureDetector(
          onTap: () {
            context.pushTransparentRoute(
                transitionDuration: appSettings.transitionDuration,
                reverseTransitionDuration: appSettings.reverseTransitionDuration,
                ShowDetailScreen(id: id, image: image, tag: "recents"));
          },
          child:  Column(
              children: [
                Hero(
            tag: "${id}recents",
            child:
                Container(
                  height: screen.height * 0.23,
                  clipBehavior: Clip.hardEdge,
                  width: screen.width - 30,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(32))),
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
                ),),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Text(
                        "Episode: $episodes",
                        style:
                            const TextStyle(fontSize: 11, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
