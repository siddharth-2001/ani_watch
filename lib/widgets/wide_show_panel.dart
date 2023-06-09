import 'package:dismissible_page/dismissible_page.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:provider/provider.dart';

//local imports
import '../screens/show_detail_screen.dart';

//provider imports
import '../provider/settings.dart';

class WideShowPanel extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final String episodes;
  final String rating;
  final List<String> genres;
  final String year;

  const WideShowPanel({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.episodes,
    required this.rating,
    required this.genres,
    required this.year,
  });

  final detailLabelStyle = const TextStyle(
      fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500);

  Widget genreText() {
    String result = "";

    if (genres.isEmpty) {
      return Text(
        "Genres:  Not Available",
        style: detailLabelStyle,
      );
    }

    for (var element in genres) {
      result = "${result + element},  ";
    }

    result = result.substring(0, result.length - 3);

    return Text(
      "Genres:  $result",
      style: detailLabelStyle,
      maxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final appSettings = Provider.of<AppSettings>(context);

    return ZoomTapAnimation(
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
              ShowDetailScreen(id: id, image: image, tag:"search"));
        },
        child:  Container(
            height: 180,
            width: screen.width - 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                Hero(
          tag: "${id}search",
          child:
                Container(
                  height: 150,
                  width: 150,
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 1)
                  )),
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
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        maxLines: 3,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.star,
                            color: Colors.yellow,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                              rating == "null"
                                  ? "Not Available"
                                  : ((int.parse(rating) / 100) * 5)
                                      .toStringAsPrecision(2),
                              style: detailLabelStyle),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(year, style: detailLabelStyle),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Episodes:  $episodes", style: detailLabelStyle),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      genreText(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
     
    );
  }
}
