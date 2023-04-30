import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class TrendingAnimeList extends StatefulWidget {
  const TrendingAnimeList({super.key});

  @override
  State<TrendingAnimeList> createState() => _TrendingAnimeListState();
}

class _TrendingAnimeListState extends State<TrendingAnimeList> {
  late Future<void> _future;
  List<Anime> list = [];
  @override
  void initState() {
    super.initState();
    _future =
        Provider.of<TrendingAnime>(context, listen: false).fetchTrendingAnime();
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<TrendingAnime>(context).trendingList;
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          );
        } else {
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return const Center(
              child: Text(
                "Error Fetching Trending List",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SizedBox(
            height: size.height * 0.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GlassShowPanel(
                  tag: "trending",
                  id: list[index].details["id"],
                  name: list[index].details["name"],
                  image: list[index].details["image"],
                  episodes: list[index].details["episodes"],
                );
              },
            ),
          );
        }
      },
    );
  }
}
