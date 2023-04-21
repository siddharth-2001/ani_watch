import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:provider/provider.dart';

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
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
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
                reverseTransitionDuration: appSettings.reverseTransitionDuration,
                ShowDetailScreen(id: id, image: image, tag: tag));
          },
          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
            tag: id + tag,
            child:
                Container(
                  height: size.height * 0.16,
                  width: size.width * 0.27,
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
                    borderRadius: BorderRadius.circular(1 / 5.5 * 145),
                  ),
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
                  padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
                  child: SizedBox(
                    width: 110,
                    child: Text(
                      name,
                      // textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
