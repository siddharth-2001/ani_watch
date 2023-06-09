import 'package:ani_watch/provider/anime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../ui/recent_episodes.dart';
import '../ui/trending_anime_list.dart';
import '../ui/popular_anime_list.dart';
import '../ui/current_watch_list.dart';
import '../ui/you_may_like_list.dart';

//provider imports
import '../provider/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    const fontColor = Colors.white;
    final listHeight = screen.height * 0.22;
    final wideListHeight = screen.height * 0.4;
    final appSettigns = Provider.of<AppSettings>(context);

    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Watch Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              setState(() {
                
              });
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: screen.height * 0.025),
                child: const Text(
                  "Continue Watching",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                  height: wideListHeight,
                  child: const Center(child: CurrentWatchList())),
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(
                    horizontal: appSettigns.pageMarginHorizontal,
                    vertical: screen.height * 0.025),
                child: const Text(
                  "You Might Like",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                  height: listHeight,
                  child: const Center(child: YouMayLikeList())),
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(
                    horizontal: appSettigns.pageMarginHorizontal,
                    vertical: screen.height * 0.025),
                child: const Text(
                  "Trending Anime",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                  height: listHeight,
                  child: const Center(child: TrendingAnimeList())),
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(
                    horizontal: appSettigns.pageMarginHorizontal,
                    vertical: screen.height * 0.025),
                child: const Text(
                  "Recent Episodes",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                  height: wideListHeight,
                  child: const Center(child: RecentEpisodeUi())),
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(
                    horizontal: appSettigns.pageMarginHorizontal,
                    vertical: screen.height * 0.025),
                child: const Text(
                  "Popular Anime",
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                  height: listHeight,
                  child: const Center(child: PopularAnimeList())),
              SizedBox(
                height: padding.bottom + 16,
              )
            ]),
          )
        ],
      ),
    );
  }
}
