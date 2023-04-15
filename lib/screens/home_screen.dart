import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:stream_app/widgets/glass_bottom_bar.dart';

//local imports
import '../ui/recent_episodes.dart';
import '../ui/trending_anime_list.dart';
import '../ui/home_top_ui.dart';
import '../ui/popular_anime_list.dart';

//provider imports
import '../provider/anime.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).viewPadding;
    final screen = MediaQuery.of(context).size;
    final fontColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: GlassBottomBar(
        currIndex: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: screen.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xff1e2757), Color(0xff0a0d1d)],
              stops: [0, 1],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )),
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                child: HomeUpperUi(),
              ),
              Container(
                width: screen.width,
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Recent Episodes",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 200,
                child: const RecentEpisodeUi()),
              Container(
                width: screen.width,
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Trending Anime",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 220,
                child: const TrendingAnimeList()),
              Container(
                width: screen.width,
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Popular Anime",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 220,
                child: const PopularAnimeList()),
            ],
          ),
        ],
      ),
    );
  }
}
