import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//local imports
import '../widgets/wide_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class SearchAnimeList extends StatefulWidget {
  final String query;
  const SearchAnimeList({super.key, required this.query});

  @override
  State<SearchAnimeList> createState() => _SearchAnimeListState();
}

class _SearchAnimeListState extends State<SearchAnimeList> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = Provider.of<AnimeService>(context, listen: false)
        .searchAnime(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<AnimeService>(context).getSearchList;
    final padding = MediaQuery.of(context).padding;

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
                "Some error occurred while searching",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.only(
                top: padding.top + 16,
                bottom: padding.bottom,
                left: 8,
                right: 8),
            itemCount: list.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return WideShowPanel(
                id: list[index].details["id"],
                name: list[index].details["name"],
                image: list[index].details["image"],
                episodes: list[index].details["episodes"],
                rating: list[index].details["rating"],
                genres: list[index].details["genres"],
                year: list[index].details["releaseDate"],
              );
            },
          );
        }
      },
    );
  }
}
