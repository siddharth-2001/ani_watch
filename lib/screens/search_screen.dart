import 'package:ani_watch/widgets/blur_image.dart';
import 'package:flutter/material.dart';

//local imports
import '../ui/search_anime_list.dart';
import '../widgets/glass_bottom_bar.dart';

//provider imports

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).viewPadding;
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const GlassBottomBar(currIndex: 1),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BlurImageBackground(image: "assets/bg2.jpg", isAsset: true),
          Container(
            height: screen.height,
            width: screen.width,
            padding: EdgeInsets.only(top:screenPadding.top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screen.width * 0.05 , vertical: screen.height*0.025),
                  child: Text("Search Results",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.greenAccent.shade400, fontWeight: FontWeight.w800)),
                ),
                const Flexible(child: SearchAnimeList())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
