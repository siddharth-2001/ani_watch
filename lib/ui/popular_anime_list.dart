import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class PopularAnimeList extends StatefulWidget {
  const PopularAnimeList({super.key});

  @override
  State<PopularAnimeList> createState() => _PopularAnimeListState();
}

class _PopularAnimeListState extends State<PopularAnimeList> {
  late Future<void> _future;
  List<Anime> list = [];
  @override
  void initState() {
    super.initState();
    _future =
        Provider.of<PopularAnime>(context, listen: false).getPopularAnime();
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<PopularAnime>(context, listen: true).popularList;
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
            return const Center(
              child: Text(
                "Some error occurred while fetching popular anime",
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
                    tag: "popular",
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
