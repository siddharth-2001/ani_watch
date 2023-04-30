import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//local imports
import '../widgets/current_watch_panel.dart';

//provider imports
import '../provider/anime.dart';

class CurrentWatchList extends StatefulWidget {
  const CurrentWatchList({super.key});

  @override
  State<CurrentWatchList> createState() => _CurrentWatchListState();
}

class _CurrentWatchListState extends State<CurrentWatchList> {
  List<Map<Anime, int>> list = [];
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = Provider.of<AnimeService>(context, listen: false)
        .fetchCurrentlyWatching();
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<AnimeService>(context).currWatchList;
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
            return const Center(
              child: Text(
                "Some error occurred while fetching your data",
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
                final Anime anime = list[index].keys.first;
                return CurrentWatchPanel(
                  id: anime.details["id"]!,
                  name: anime.details["name"]!,
                  episodeIndex: list[index].values.first.toString(),
                  image: anime.details["image"]!,
                );
              },
            ),
          );
        }
      },
    );
  }
}
