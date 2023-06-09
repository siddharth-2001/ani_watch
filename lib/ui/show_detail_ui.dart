import 'dart:developer';

import 'package:ani_watch/widgets/blur_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_button.dart';
import '../screens/watch_episode_screen.dart';
import '../ui/recommendation_list.dart';

//provider imports
import '../provider/anime.dart';
import '../provider/settings.dart';

class ShowDetailUi extends StatefulWidget {
  final String id;
  final String image;
  final String tag;

  const ShowDetailUi(
      {super.key, required this.id, required this.image, required this.tag});

  @override
  State<ShowDetailUi> createState() => _ShowDetailUiState();
}

class _ShowDetailUiState extends State<ShowDetailUi> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = Provider.of<AnimeService>(context, listen: false)
        .getAnimeById(widget.id);
  }

  final detailLabelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 11,
  );

  Widget genreText(details) {
    String result = "";

    if (details["genres"].length == 0) {
      return Text(
        "Genres:  Not Available",
        style: detailLabelStyle,
      );
    }

    for (var element in details["genres"]) {
      result = "${result + element},  ";
    }

    result = result.substring(0, result.length - 3);

    return Text("Genres:  $result", style: detailLabelStyle);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final appSettings = Provider.of<AppSettings>(context);

    return SingleChildScrollView(
      child: Stack(
        children: [
         BlurImageBackground(
              image: widget.image,
              isAsset: false,
            ),
          
          SizedBox(
            height: screen.height,
            width: screen.width,
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(color: Colors.white),
                  );
                } else {
                  if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return const Center(
                      child: Text(
                        "Some error occurred while fetching anime details",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final details = Provider.of<AnimeService>(context)
                        .getAnimeFromMemory(widget.id)
                        .details;
                    return Column(
                      children: [
                        Hero(
                          tag: widget.id + widget.tag,
                          child: SizedBox(
                            height: screen.height * 0.2,
                            width: screen.width,
                            child: Image.network(
                              details["cover"],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
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
                        SizedBox(
                          height: screen.height * 0.8,
                          width: screen.width,
                          child:

                              //Main box that shows all the details
                              SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                                top: 15,
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screen.width * 0.05),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(details["name"]!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24)),
                                      SizedBox(
                                        height: screen.height * 0.025,
                                      ),
                                      //First detail row
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                CupertinoIcons.star,
                                                color: Colors.yellow,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                details["rating"] == "null"
                                                    ? "Not Available"
                                                    : (int.parse(details[
                                                                "rating"]) /
                                                            100 *
                                                            5)
                                                        .toStringAsFixed(1),
                                                style: detailLabelStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                              "Year: ${details["releaseDate"]}",
                                              style: detailLabelStyle),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "Episodes: ${details["episodes"]}",
                                            style: detailLabelStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: screen.height * 0.025,
                                      ),

                                      //Genre Info row
                                      genreText(details),

                                      SizedBox(
                                        height: screen.height * 0.025,
                                      ),

                                      Text("Status: ${details["status"]}",
                                          style: detailLabelStyle),
                                      SizedBox(
                                        height: screen.height * 0.025,
                                      ),

                                      //Summary about the anime
                                      Text(
                                        "Summary:",
                                        style: detailLabelStyle,
                                      ),
                                      SizedBox(
                                        height: screen.height * 0.025,
                                      ),
                                      Text(
                                        "${details["description"]}",
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                      SizedBox(
                                        height: screen.height * 0.025,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GlassButton(
                                              icon: const Icon(
                                                CupertinoIcons.play_rectangle,
                                                color: Colors.white,
                                              ),
                                              function: () {
                                                Provider.of<AnimeService>(
                                                        context,
                                                        listen: false)
                                                    .addToRecommendations(
                                                        widget.id);
                                                context.pushTransparentRoute(
                                                    reverseTransitionDuration:
                                                        appSettings
                                                            .transitionDuration,
                                                    transitionDuration: appSettings
                                                        .reverseTransitionDuration,
                                                    WatchEpisodeScreen(
                                                      id: widget.id,
                                                      tag: "watch",
                                                      index: 0,
                                                    ));
                                              }),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GlassButton(
                                              icon: Provider.of<AnimeService>(
                                                          context)
                                                      .isFavourite(
                                                          details["id"])
                                                  ? const Icon(
                                                      CupertinoIcons.heart_fill,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      CupertinoIcons.heart,
                                                      color: Colors.white,
                                                    ),
                                              function: () {
                                                Provider.of<AnimeService>(
                                                        context,
                                                        listen: false)
                                                    .addToFavourite(
                                                        details["id"]);
                                                setState(() {});
                                              }),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screen.height * 0.025),
                                        child: Text("Recommendations",
                                            style: detailLabelStyle),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screen.height * 0.225,
                                  width: screen.width,
                                  child: RecommendedAnimeList(
                                      recommendationList:
                                          details["recommendations"]),
                                ),
                                SizedBox(
                                  height: screen.height * 0.025,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
