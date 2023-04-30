import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class YouMayLikeList extends StatefulWidget {
  const YouMayLikeList({super.key});

  @override
  State<YouMayLikeList> createState() => _YouMayLikeListState();
}

class _YouMayLikeListState extends State<YouMayLikeList> {
  List<Anime> list = [];
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = Provider.of<AnimeService>(context, listen: false)
        .fetchRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<AnimeService>(context).recommendedList;

    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(color: Colors.white),
          );
        } else {
          if (snapshot.hasError) {
            log("Error while getting recommendations: ${snapshot.error.toString()}");
            return const Center(
              child: Text(
                "An error occured while getting your recommendations",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SizedBox(
            height: size.height * 0.22,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: GlassShowPanel(
                    tag: "you_may_like",
                    id: list[index].details["id"],
                    name: list[index].details["name"],
                    image: list[index].details["image"],
                    episodes: list[index].details["episodes"],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
