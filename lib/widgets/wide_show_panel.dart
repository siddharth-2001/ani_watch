import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

//local imports
import '../screens/show_detail_screen.dart';

//provider imports

class WideShowPanel extends StatelessWidget {
  late String id;
  late String name;
  late String image;
  late String episodes;
  late String rating;
  late List<String> genres;
  late String year;

  WideShowPanel({
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
      fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700);

  Widget genreText() {
    String result = "";

    if (genres.length == 0) return Text("Genres:  Not Available", style: detailLabelStyle,);

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
          Navigator.of(context)
              .pushNamed(ShowDetailScreen.routeName, arguments: {"id": id});
        },
        child: Container(
          height: 155,
          width: screen.width - 50,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: [
              Container(
                height: 155,
                width: 110,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CupertinoActivityIndicator(color: Colors.white,),
                      );
                    },
                ),
              ),
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.star,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            rating == "null"
                                ? "Not Available"
                                : ((int.parse(rating) / 100) * 5)
                                    .toStringAsPrecision(2),
                            style: detailLabelStyle),
                        SizedBox(
                          width: 10,
                        ),
                        Text(year, style: detailLabelStyle),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Episodes:  $episodes", style: detailLabelStyle),
                      ],
                    ),
                    SizedBox(
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
