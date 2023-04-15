import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:flutter/cupertino.dart';
//local imports
import './glass_widget.dart';
import '../screens/show_detail_screen.dart';

class GlassRecentPanel extends StatelessWidget {
  late String _id, _episodes, _name, _image;

  GlassRecentPanel(
      {super.key,
      required String id,
      required String episodes,
      required String name,
      required String image}) {
    _id = id;
    _episodes = episodes;
    _name = name;
    _image = image;
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Container(
      height: 200,
      width: screen.width - 30,
      padding: const EdgeInsets.all(8.0),
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
            Navigator.of(context)
                .pushNamed(ShowDetailScreen.routeName, arguments: {"id": _id});
          },
          child: Column(
            children: [
              Container(
                height: 150,
                clipBehavior: Clip.hardEdge,
                width: screen.width - 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                child: Image.network(
                  _image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CupertinoActivityIndicator(color: Colors.white,),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      "Episode: $_episodes",
                      style: const TextStyle(fontSize: 11, color: Colors.white),
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