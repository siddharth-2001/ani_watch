import 'package:flutter/material.dart';

//local imports
import '../ui/recent_episodes.dart';
import '../ui/trending_anime_list.dart';
import '../ui/home_top_ui.dart';
import '../ui/popular_anime_list.dart';
import '../ui/current_watch_list.dart';
import '../ui/you_may_like_list.dart';
import '../widgets/glass_bottom_bar.dart';
import '../widgets/blur_image.dart';

//provider imports
import '../provider/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    const fontColor = Colors.white;
    final listHeight = screen.height * 0.22;
    final wideListHeight = screen.height * 0.25;
    final user = UserService();
    user.login("test@test.com", "test@test");

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: const GlassBottomBar(
        currIndex: 0,
      ),
      body: Stack(
        children: [
          BlurImageBackground(image: "assets/bg1.jpg", isAsset: true,),
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screen.width * 0.05,
                    vertical: screen.height * 0.025),
                child: const HomeUpperUi(),
              ),
              Container(
                width: screen.width,
                padding: EdgeInsets.symmetric(
                    horizontal: screen.width * 0.05,
                    vertical: screen.height * 0.025),
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
                    horizontal: screen.width * 0.05,
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
                    horizontal: screen.width * 0.05,
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
                    horizontal: screen.width * 0.05,
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
                    horizontal: screen.width * 0.05,
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
            ],
          ),
        ],
      ),
    );
  }
}
