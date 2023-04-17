import 'package:flutter/material.dart';
import 'package:stream_app/widgets/glass_bottom_bar.dart';

//local imports
import '../ui/recent_episodes.dart';
import '../ui/trending_anime_list.dart';
import '../ui/home_top_ui.dart';
import '../ui/popular_anime_list.dart';

//provider imports

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    const fontColor = Colors.white;

    return Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        bottomNavigationBar: const GlassBottomBar(
          currIndex: 0,
        ),
        body: Container(
          height: screen.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff1e2757), Color(0xff0a0d1d)],
            stops: [0, 1],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          )),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screen.width * 0.05, vertical: screen.height * 0.025),
                child: const HomeUpperUi(),
              ),
              Container(
                width: screen.width,
                padding:  
                    EdgeInsets.symmetric(horizontal: screen.width * 0.05, vertical: screen.height * 0.025),
                child: const Text(
                  "Recent Episodes",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: screen.height * 0.23  , child: RecentEpisodeUi()),
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(horizontal: screen.width * 0.05, vertical: screen.height * 0.025),
                child: const Text(
                  "Trending Anime",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height:screen.height * 0.2, child: const TrendingAnimeList()),
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(horizontal: screen.width * 0.05, vertical: screen.height * 0.025),
                child: const Text(
                  "Popular Anime",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: screen.height * 0.2, child: const PopularAnimeList()),
            ],
          ),
        ));
  }
}
