import 'package:ani_watch/widgets/blur_image.dart';
import 'package:flutter/material.dart';

//local imports
import '../widgets/glass_bottom_bar.dart';
import '../ui/favourite_anime_list.dart';

//provider imports

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  static const routeName = '/favourites';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      bottomNavigationBar: const GlassBottomBar(
        currIndex: 2,
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BlurImageBackground(image: "assets/fav_bg.jpg", isAsset: true),
          Container(
            height: screen.height,
            width: screen.width,
            padding: EdgeInsets.only(top: padding.top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screen.width * 0.05,
                      vertical: screen.height * 0.025),
                  child: Text("Favourites",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Colors.greenAccent.shade400,
                              fontWeight: FontWeight.w800)),
                ),
                const Flexible(child: FavouriteAnimeList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
