import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_recent_episode_panel.dart';

//provider imports
import '../provider/anime.dart';

class RecentEpisodeUi extends StatefulWidget {
  const RecentEpisodeUi({super.key});

  @override
  State<RecentEpisodeUi> createState() => _RecentEpisodeUiState();
}

class _RecentEpisodeUiState extends State<RecentEpisodeUi> {
  late Future<void> _future;
  List<Anime> list = [];

  @override
  void initState() {
    super.initState();
    _future =
        Provider.of<RecentEpisodes>(context, listen: false).getRecentEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<RecentEpisodes>(context).recentList;
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
                "Some error occurred while fetching recent episodes",
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
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              itemBuilder: (BuildContext context, int index) {
                return GlassRecentPanel(
                  id: list[index].details["id"]!,
                  name: list[index].details["name"]!,
                  episodes: list[index].details["episodes"]!,
                  image: list[index].details["image"]!,
                );
              },
            ),
          );
        }
      },
    );
  }
}
