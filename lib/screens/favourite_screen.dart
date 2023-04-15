import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
      bottomNavigationBar: GlassBottomBar(
        currIndex: 2,
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screen.height,
        width: screen.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff1e2757), Color(0xff0a0d1d)],
          stops: [0, 1],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )),
        padding: EdgeInsets.only(top: padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text("Favourites", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            Flexible(child: const FavouriteAnimeList()),
          ],
        ),
      ),
    );
  }
}
