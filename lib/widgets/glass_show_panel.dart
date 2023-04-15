import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stream_app/widgets/glass_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

//local imports
import '../screens/show_detail_screen.dart';

class GlassShowPanel extends StatelessWidget {
  GlassShowPanel(
      {required id, required name, required image, required episodes}) {
    _id = id;
    _image = image;
    _name = name;
    _episodes = episodes;
  }

  String? _id, _image, _name, _episodes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 220,
        width: 110,
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
              Navigator.of(context).pushNamed(ShowDetailScreen.routeName,
                  arguments: {"id": _id});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 145,
                  width: 110,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Image.network(
                    _image!,
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
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Text(
                    _name!,
                    // textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    "Episodes: $_episodes",
                    style: const TextStyle(fontSize: 11, color: Colors.white),
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
