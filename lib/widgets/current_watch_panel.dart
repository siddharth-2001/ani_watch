import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter/cupertino.dart';
//local imports
import '../screens/watch_episode_screen.dart';

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

    return Container(
      width: screen.width - 50,
      padding: EdgeInsets.symmetric(horizontal: screen.width * 0.015),
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
            Navigator.of(context).pushNamed(WatchEpisodeScreen.routeName,
                arguments: {"id": id, "index": int.parse(episodeIndex),"tag":"watch"});
          },
          child: Hero(
            tag: id+"watch",
            child: Column(
              children: [
                Container(
                  height: screen.height * 0.17,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                        "Episode: ${int.parse(episodeIndex) + 1}",
                        style: const TextStyle(fontSize: 11, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
