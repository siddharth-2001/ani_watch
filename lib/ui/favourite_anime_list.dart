import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/wide_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class FavouriteAnimeList extends StatefulWidget {
  const FavouriteAnimeList({super.key});

  @override
  State<FavouriteAnimeList> createState() => _FavouriteAnimeListState();
}

class _FavouriteAnimeListState extends State<FavouriteAnimeList> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future =
        Provider.of<AnimeService>(context, listen: false).fetchFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<AnimeService>(context).favouriteList;

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return const SliverFillRemaining(
              child: Center(
                child: Text(
                  "Some error occurred while fetching favourites",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: list.length,
              (context, index) {
                final anime = list[index].details;

                return WideShowPanel(
                    id: anime["id"],
                    name: anime["name"],
                    image: anime["image"],
                    episodes: anime["episodes"],
                    rating: anime["rating"],
                    genres: anime["genres"],
                    year: anime["releaseDate"]);
              },
            ),
          );
        }
      },
    );
  }
}
